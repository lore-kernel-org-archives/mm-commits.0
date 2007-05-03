From: akpm@linux-foundation.org
Subject: + afs-af_rxrpc-miscellaneous-fixes.patch added to -mm tree
Date: Wed, 02 May 2007 22:51:25 -0700
Message-ID: <200705030551.l435pPwL005827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767399AbXECFvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, geert@linux-m68k.org


The patch titled
     AFS/AF_RXRPC: Miscellaneous fixes
has been added to the -mm tree.  Its filename is
     afs-af_rxrpc-miscellaneous-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFS/AF_RXRPC: Miscellaneous fixes
From: David Howells <dhowells@redhat.com>

Make miscellaneous fixes to AFS and AF_RXRPC:

 (*) Make AF_RXRPC select KEYS rather than RXKAD or AFS_FS in Kconfig.

 (*) Don't use FS_BINARY_MOUNTDATA.

 (*) Remove a done 'TODO' item in a comemnt on afs_get_sb().

 (*) Don't pass a void * as the page pointer argument of kmap_atomic() as this
     breaks on m68k.  Patch from Geert Uytterhoeven <geert@linux-m68k.org>.

 (*) Use match_*() functions rather than doing my own parsing.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig        |    1 
 fs/afs/fsclient.c |    3 -
 fs/afs/super.c    |  102 ++++++++++++++++++--------------------------
 net/rxrpc/Kconfig |    3 -
 4 files changed, 48 insertions(+), 61 deletions(-)

diff -puN fs/Kconfig~afs-af_rxrpc-miscellaneous-fixes fs/Kconfig
--- a/fs/Kconfig~afs-af_rxrpc-miscellaneous-fixes
+++ a/fs/Kconfig
@@ -2068,7 +2068,6 @@ config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	select AF_RXRPC
-	select KEYS
 	help
 	  If you say Y here, you will get an experimental Andrew File System
 	  driver. It currently only supports unsecured read-only AFS access.
diff -puN fs/afs/fsclient.c~afs-af_rxrpc-miscellaneous-fixes fs/afs/fsclient.c
--- a/fs/afs/fsclient.c~afs-af_rxrpc-miscellaneous-fixes
+++ a/fs/afs/fsclient.c
@@ -266,7 +266,8 @@ static int afs_deliver_fs_fetch_data(str
 		call->unmarshall++;
 
 		if (call->count < PAGE_SIZE) {
-			buffer = kmap_atomic(call->reply3, KM_USER0);
+			page = call->reply3;
+			buffer = kmap_atomic(page, KM_USER0);
 			memset(buffer + PAGE_SIZE - call->count, 0,
 			       call->count);
 			kunmap_atomic(buffer, KM_USER0);
diff -puN fs/afs/super.c~afs-af_rxrpc-miscellaneous-fixes fs/afs/super.c
--- a/fs/afs/super.c~afs-af_rxrpc-miscellaneous-fixes
+++ a/fs/afs/super.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/parser.h>
 #include "internal.h"
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
@@ -42,7 +43,7 @@ struct file_system_type afs_fs_type = {
 	.name		= "afs",
 	.get_sb		= afs_get_sb,
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_BINARY_MOUNTDATA,
+	.fs_flags	= 0,
 };
 
 static const struct super_operations afs_super_ops = {
@@ -58,6 +59,20 @@ static const struct super_operations afs
 static struct kmem_cache *afs_inode_cachep;
 static atomic_t afs_count_active_inodes;
 
+enum {
+	afs_no_opt,
+	afs_opt_cell,
+	afs_opt_rwpath,
+	afs_opt_vol,
+};
+
+static const match_table_t afs_options_list = {
+	{ afs_opt_cell,		"cell=%s"	},
+	{ afs_opt_rwpath,	"rwpath"	},
+	{ afs_opt_vol,		"vol=%s"	},
+	{ afs_no_opt,		NULL		},
+};
+
 /*
  * initialise the filesystem
  */
@@ -115,31 +130,6 @@ void __exit afs_fs_exit(void)
 }
 
 /*
- * check that an argument has a value
- */
-static int want_arg(char **_value, const char *option)
-{
-	if (!_value || !*_value || !**_value) {
-		printk(KERN_NOTICE "kAFS: %s: argument missing\n", option);
-		return 0;
-	}
-	return 1;
-}
-
-/*
- * check that there's no subsequent value
- */
-static int want_no_value(char *const *_value, const char *option)
-{
-	if (*_value && **_value) {
-		printk(KERN_NOTICE "kAFS: %s: Invalid argument: %s\n",
-		       option, *_value);
-		return 0;
-	}
-	return 1;
-}
-
-/*
  * parse the mount options
  * - this function has been shamelessly adapted from the ext3 fs which
  *   shamelessly adapted it from the msdos fs
@@ -148,48 +138,46 @@ static int afs_parse_options(struct afs_
 			     char *options, const char **devname)
 {
 	struct afs_cell *cell;
-	char *key, *value;
-	int ret;
+	substring_t args[MAX_OPT_ARGS];
+	char *p;
+	int token;
 
 	_enter("%s", options);
 
 	options[PAGE_SIZE - 1] = 0;
 
-	ret = 0;
-	while ((key = strsep(&options, ","))) {
-		value = strchr(key, '=');
-		if (value)
-			*value++ = 0;
-
-		_debug("kAFS: KEY: %s, VAL:%s", key, value ?: "-");
-
-		if (strcmp(key, "rwpath") == 0) {
-			if (!want_no_value(&value, "rwpath"))
-				return -EINVAL;
-			params->rwpath = 1;
-		} else if (strcmp(key, "vol") == 0) {
-			if (!want_arg(&value, "vol"))
-				return -EINVAL;
-			*devname = value;
-		} else if (strcmp(key, "cell") == 0) {
-			if (!want_arg(&value, "cell"))
-				return -EINVAL;
-			cell = afs_cell_lookup(value, strlen(value));
+	while ((p = strsep(&options, ","))) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, afs_options_list, args);
+		switch (token) {
+		case afs_opt_cell:
+			cell = afs_cell_lookup(args[0].from,
+					       args[0].to - args[0].from);
 			if (IS_ERR(cell))
 				return PTR_ERR(cell);
 			afs_put_cell(params->cell);
 			params->cell = cell;
-		} else {
-			printk("kAFS: Unknown mount option: '%s'\n",  key);
-			ret = -EINVAL;
-			goto error;
+			break;
+
+		case afs_opt_rwpath:
+			params->rwpath = 1;
+			break;
+
+		case afs_opt_vol:
+			*devname = args[0].from;
+			break;
+
+		default:
+			printk(KERN_ERR "kAFS:"
+			       " Unknown or invalid mount option: '%s'\n", p);
+			return -EINVAL;
 		}
 	}
 
-	ret = 0;
-error:
-	_leave(" = %d", ret);
-	return ret;
+	_leave(" = 0");
+	return 0;
 }
 
 /*
@@ -361,7 +349,6 @@ error:
 
 /*
  * get an AFS superblock
- * - TODO: don't use get_sb_nodev(), but rather call sget() directly
  */
 static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags,
@@ -386,7 +373,6 @@ static int afs_get_sb(struct file_system
 			goto error;
 	}
 
-
 	ret = afs_parse_device_name(&params, dev_name);
 	if (ret < 0)
 		goto error;
diff -puN net/rxrpc/Kconfig~afs-af_rxrpc-miscellaneous-fixes net/rxrpc/Kconfig
--- a/net/rxrpc/Kconfig~afs-af_rxrpc-miscellaneous-fixes
+++ a/net/rxrpc/Kconfig
@@ -5,6 +5,7 @@
 config AF_RXRPC
 	tristate "RxRPC session sockets"
 	depends on EXPERIMENTAL
+	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
 	  the transport part, not the presentation part: (un)marshalling is
@@ -29,7 +30,7 @@ config AF_RXRPC_DEBUG
 
 config RXKAD
 	tristate "RxRPC Kerberos security"
-	depends on AF_RXRPC && KEYS
+	depends on AF_RXRPC
 	select CRYPTO
 	select CRYPTO_MANAGER
 	select CRYPTO_BLKCIPHER
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
get_unmapped_area-handles-map_fixed-on-powerpc.patch
get_unmapped_area-handles-map_fixed-on-frv.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
get_unmapped_area-handles-map_fixed-in-generic-code.patch
get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
m68k-export-csum_partial_copy_from_user.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
use-slab_panic-flag-cleanup.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
afs-make-the-match_-functions-take-const-options.patch
afs-af_rxrpc-miscellaneous-fixes.patch
afs-fix-use-of-__exit-functions-from-__init-path.patch
mutex-subsystem-synchro-test-module.patch
