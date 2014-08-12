From: akpm@linux-foundation.org
Subject: [merged]
 fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:38 -0700
Message-ID: <53ea6db6.JothH3MTTMZYu9YO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45566 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaHLTkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:39 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so472389qcx.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, bharrosh@panasas.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exofs/ore_raid.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/exofs/ore_raid.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/ore_raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exofs/ore_raid.c~fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc fs/exofs/ore_raid.c
--- a/fs/exofs/ore_raid.c~fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/exofs/ore_raid.c
@@ -116,7 +116,7 @@ static int _sp2d_alloc(unsigned pages_in
 			num_a1pa = min_t(unsigned, PAGE_SIZE / sizeof__a1pa,
 							pages_in_unit - i);
 
-			__a1pa = kzalloc(num_a1pa * sizeof__a1pa, GFP_KERNEL);
+			__a1pa = kcalloc(num_a1pa, sizeof__a1pa, GFP_KERNEL);
 			if (unlikely(!__a1pa)) {
 				ORE_DBGMSG("!! Failed to _alloc_1p_arrays=%d\n",
 					   num_a1pa);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

