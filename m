From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:02:45 -0700
Message-ID: <53e3db65.3NtDr/XDLf2ankc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:57188 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:46 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so836614oig.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/slot_map.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ocfs2/slot_map.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/slot_map.c~fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/ocfs2/slot_map.c
@@ -382,7 +382,7 @@ static int ocfs2_map_slot_buffers(struct
 
 	trace_ocfs2_map_slot_buffers(bytes, si->si_blocks);
 
-	si->si_bh = kzalloc(sizeof(struct buffer_head *) * si->si_blocks,
+	si->si_bh = kcalloc(si->si_blocks, sizeof(struct buffer_head *),
 			    GFP_KERNEL);
 	if (!si->si_bh) {
 		status = -ENOMEM;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-ufs-inodec-kernel-doc-warning-fixes.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

