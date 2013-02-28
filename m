From: akpm@linux-foundation.org
Subject: [folded-dropped] fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:40:17 -0800
Message-ID: <20130228004017.D850A5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:50399 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1AkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:40:18 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so138617ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:40:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch

This patch was dropped because it was folded into fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix

s/max_t/min_t/

Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix
+++ a/fs/proc/vmcore.c
@@ -178,7 +178,7 @@ static ssize_t read_vmcore(struct file *
         	return -EINVAL;
 
 	while (buflen) {
-		tsz = max_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
+		tsz = min_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
 
 		/* Calculate left bytes in current memory segment. */
 		nr_bytes = (curr_m->size - (start - curr_m->paddr));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

