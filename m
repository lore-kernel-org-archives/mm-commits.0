From: akpm@linux-foundation.org
Subject: + fs-befs-kernel-doc-fixes.patch added to -mm tree
Date: Mon, 28 Apr 2014 14:04:28 -0700
Message-ID: <535ec25c.zmKAhViHF0SvPLRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaD1VE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 17:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: + fs-befs-kernel-doc-fixes.patch added to -mm tree
To: fabf@skynet.be,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 14:04:28 -0700


The patch titled
     Subject: fs/befs: kernel-doc fixes
has been added to the -mm tree.  Its filename is
     fs-befs-kernel-doc-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-kernel-doc-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-kernel-doc-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs: kernel-doc fixes

Fix some comment errors.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c      |    4 ++--
 fs/befs/datastream.c |    2 +-
 fs/befs/linuxvfs.c   |   16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/befs/btree.c~fs-befs-kernel-doc-fixes fs/befs/btree.c
--- a/fs/befs/btree.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/btree.c
@@ -318,7 +318,7 @@ befs_btree_find(struct super_block *sb,
  * befs_find_key - Search for a key within a node
  * @sb: Filesystem superblock
  * @node: Node to find the key within
- * @key: Keystring to search for
+ * @findkey: Keystring to search for
  * @value: If key is found, the value stored with the key is put here
  *
  * finds exact match if one exists, and returns BEFS_BT_MATCH
@@ -706,7 +706,7 @@ befs_bt_get_key(struct super_block *sb,
  * @key1: pointer to the first key to be compared 
  * @keylen1: length in bytes of key1
  * @key2: pointer to the second key to be compared
- * @kelen2: length in bytes of key2
+ * @keylen2: length in bytes of key2
  *
  * Returns 0 if @key1 and @key2 are equal.
  * Returns >0 if @key1 is greater.
diff -puN fs/befs/datastream.c~fs-befs-kernel-doc-fixes fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/datastream.c
@@ -116,7 +116,7 @@ befs_fblock2brun(struct super_block *sb,
  * befs_read_lsmylink - read long symlink from datastream.
  * @sb: Filesystem superblock 
  * @ds: Datastrem to read from
- * @buf: Buffer in which to place long symlink data
+ * @buff: Buffer in which to place long symlink data
  * @len: Length of the long symlink in bytes
  *
  * Returns the number of bytes read
diff -puN fs/befs/linuxvfs.c~fs-befs-kernel-doc-fixes fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/linuxvfs.c
@@ -582,21 +582,21 @@ befs_utf2nls(struct super_block *sb, con
 /**
  * befs_nls2utf - Convert NLS string to utf8 encodeing
  * @sb: Superblock
- * @src: Input string buffer in NLS format
- * @srclen: Length of input string in bytes
- * @dest: The output string in UTF-8 format
- * @destlen: Length of the output buffer
+ * @in: Input string buffer in NLS format
+ * @in_len: Length of input string in bytes
+ * @out: The output string in UTF-8 format
+ * @out_len: Length of the output buffer
  * 
- * Converts input string @src, which is in the format of the loaded NLS map,
+ * Converts input string @in, which is in the format of the loaded NLS map,
  * into a utf8 string.
  * 
- * The destination string @dest is allocated by this function and the caller is
+ * The destination string @out is allocated by this function and the caller is
  * responsible for freeing it with kfree()
  * 
- * On return, *@destlen is the length of @dest in bytes.
+ * On return, *@out_len is the length of @out in bytes.
  *
  * On success, the return value is the number of utf8 characters written to
- * the output buffer @dest.
+ * the output buffer @out.
  *  
  * On Failure, a negative number coresponding to the error code is returned.
  */
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

