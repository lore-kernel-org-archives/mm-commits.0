From: akpm@linux-foundation.org
Subject: - afs-fix-use-of-__exit-functions-from-__init-path.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:52 -0700
Message-ID: <200705031931.l43JVqg6018298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767894AbXECTeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Fix use of __exit functions from __init path
has been removed from the -mm tree.  Its filename was
     afs-fix-use-of-__exit-functions-from-__init-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix use of __exit functions from __init path
From: David Howells <dhowells@redhat.com>

Fix use of __exit functions from __init path.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/callback.c  |    2 +-
 fs/afs/internal.h  |    4 ++--
 fs/afs/vlocation.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/afs/callback.c~afs-fix-use-of-__exit-functions-from-__init-path fs/afs/callback.c
--- a/fs/afs/callback.c~afs-fix-use-of-__exit-functions-from-__init-path
+++ a/fs/afs/callback.c
@@ -468,7 +468,7 @@ int __init afs_callback_update_init(void
 /*
  * shut down the callback update process
  */
-void __exit afs_callback_update_kill(void)
+void afs_callback_update_kill(void)
 {
 	destroy_workqueue(afs_callback_update_worker);
 }
diff -puN fs/afs/internal.h~afs-fix-use-of-__exit-functions-from-__init-path fs/afs/internal.h
--- a/fs/afs/internal.h~afs-fix-use-of-__exit-functions-from-__init-path
+++ a/fs/afs/internal.h
@@ -392,7 +392,7 @@ extern void afs_give_up_callback(struct 
 extern void afs_dispatch_give_up_callbacks(struct work_struct *);
 extern void afs_flush_callback_breaks(struct afs_server *);
 extern int __init afs_callback_update_init(void);
-extern void __exit afs_callback_update_kill(void);
+extern void afs_callback_update_kill(void);
 
 /*
  * cell.c
@@ -591,7 +591,7 @@ extern struct afs_vlocation *afs_vlocati
 						  struct key *,
 						  const char *, size_t);
 extern void afs_put_vlocation(struct afs_vlocation *);
-extern void __exit afs_vlocation_purge(void);
+extern void afs_vlocation_purge(void);
 
 /*
  * vnode.c
diff -puN fs/afs/vlocation.c~afs-fix-use-of-__exit-functions-from-__init-path fs/afs/vlocation.c
--- a/fs/afs/vlocation.c~afs-fix-use-of-__exit-functions-from-__init-path
+++ a/fs/afs/vlocation.c
@@ -602,7 +602,7 @@ int __init afs_vlocation_update_init(voi
 /*
  * discard all the volume location records for rmmod
  */
-void __exit afs_vlocation_purge(void)
+void afs_vlocation_purge(void)
 {
 	afs_vlocation_timeout = 0;
 
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
git-net.patch
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
mutex-subsystem-synchro-test-module.patch
