From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:39:44 -0700
Message-ID: <53ea6d80.fyitnadv4NtSRxX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:40934 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbaHLTjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:45 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670052pab.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, qiuxishi@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: use PAGE_ALIGN instead of ALIGN(PAGE_SIZE)
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/proc/kcore.c: use PAGE_ALIGN instead of ALIGN(PAGE_SIZE)

Use mm.h definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~fs-proc-kcorec-use-page_align-instead-of-alignpage_size fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-kcorec-use-page_align-instead-of-alignpage_size
+++ a/fs/proc/kcore.c
@@ -172,7 +172,7 @@ get_sparsemem_vmemmap_info(struct kcore_
 
 	start = ((unsigned long)pfn_to_page(pfn)) & PAGE_MASK;
 	end = ((unsigned long)pfn_to_page(pfn + nr_pages)) - 1;
-	end = ALIGN(end, PAGE_SIZE);
+	end = PAGE_ALIGN(end);
 	/* overlap check (because we have to align page */
 	list_for_each_entry(tmp, head, list) {
 		if (tmp->type != KCORE_VMEMMAP)
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

