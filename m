From: akpm@linux-foundation.org
Subject: [failures] printk-fix-devkmsg_writev-efault-handling.patch removed from -mm tree
Date: Tue, 05 Jun 2012 16:47:33 -0700
Message-ID: <20120605234733.DBE6BA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36160 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2FEXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 19:47:35 -0400
Received: by qcsp5 with SMTP id p5so657140qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 16:47:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix devkmsg_writev() EFAULT handling
has been removed from the -mm tree.  Its filename was
     printk-fix-devkmsg_writev-efault-handling.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk: fix devkmsg_writev() EFAULT handling

On a fault, correctly return the partial-write info, or -EFAULT.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-fix-devkmsg_writev-efault-handling kernel/printk.c
--- a/kernel/printk.c~printk-fix-devkmsg_writev-efault-handling
+++ a/kernel/printk.c
@@ -355,7 +355,7 @@ static ssize_t devkmsg_writev(struct kio
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_length(iv, count);
-	ssize_t ret = len;
+	ssize_t ret;
 
 	if (len > LOG_LINE_MAX)
 		return -EINVAL;
@@ -365,8 +365,12 @@ static ssize_t devkmsg_writev(struct kio
 
 	line = buf;
 	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
+			ret = line - buf;
+			if (!ret)
+				ret = -EFAULT;
 			goto out;
+		}
 		line += iv[i].iov_len;
 	}
 
@@ -396,6 +400,7 @@ static ssize_t devkmsg_writev(struct kio
 	line[len] = '\0';
 
 	printk_emit(facility, level, NULL, 0, "%s", line);
+	ret = 0;
 out:
 	kfree(buf);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

