From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 21 Dec 2010 12:48:35 -0800
Message-ID: <201012212052.oBLKq5Jb025577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280Ab0LUUwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 15:52:43 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id oBLKq7VV031383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2010 12:52:07 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    3 ---
 fs/ceph/dir.c         |    5 -----
 2 files changed, 8 deletions(-)

diff -puN drivers/block/cciss.c~linux-next-git-rejects drivers/block/cciss.c
--- a/drivers/block/cciss.c~linux-next-git-rejects
+++ a/drivers/block/cciss.c
@@ -2834,11 +2834,8 @@ static int cciss_revalidate(struct gendi
 	InquiryData_struct *inq_buff = NULL;
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
-<<<<<<< HEAD
 		if (!h->drv[logvol])
 			continue;
-=======
->>>>>>> FETCH_HEAD
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
diff -puN fs/ceph/dir.c~linux-next-git-rejects fs/ceph/dir.c
--- a/fs/ceph/dir.c~linux-next-git-rejects
+++ a/fs/ceph/dir.c
@@ -40,14 +40,9 @@ int ceph_init_dentry(struct dentry *dent
 	if (dentry->d_fsdata)
 		return 0;
 
-<<<<<<< HEAD
 	if (dentry->d_parent == NULL ||   /* nfs fh_to_dentry */
 	    ceph_snap(dentry->d_parent->d_inode) == CEPH_NOSNAP)
 		dentry->d_op = &ceph_dentry_ops;
-=======
-	if (ceph_snap(dentry->d_parent->d_inode) == CEPH_NOSNAP)
-		d_set_d_op(dentry, &ceph_dentry_ops);
->>>>>>> FETCH_HEAD
 	else if (ceph_snap(dentry->d_parent->d_inode) == CEPH_SNAPDIR)
 		d_set_d_op(dentry, &ceph_snapdir_dentry_ops);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

