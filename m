From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-provide-arch_kexec_protectunprotect_crashkres-v4.patch removed from
 -mm tree
Date: Tue, 22 Mar 2016 11:30:25 -0700
Message-ID: <56f18f41.sPbF7HrINlHJhzkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbcCVSa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 14:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mhuang@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-provide-arch_kexec_protectunprotect_crashkres-v4
has been removed from the -mm tree.  Its filename was
     kexec-provide-arch_kexec_protectunprotect_crashkres-v4.patch

This patch was dropped because it was folded into kexec-provide-arch_kexec_protectunprotect_crashkres.patch

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec-provide-arch_kexec_protectunprotect_crashkres-v4

v3->v4:
Add some comments according to Minfei's suggestion.

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres-v4 arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres-v4
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -539,18 +539,21 @@ overflow:
 }
 #endif /* CONFIG_KEXEC_FILE */
 
-#ifdef CONFIG_KEXEC_CORE
 static int
 kexec_mark_range(unsigned long start, unsigned long end, bool protect)
 {
 	struct page *page;
 	unsigned int nr_pages;
 
-	if (!start || !end || start >= end)
+	/*
+	 * For physical range: [start, end]. We must skip the unassigned
+	 * crashk resource with zero-valued "end" member.
+	 */
+	if (!end || start > end)
 		return 0;
 
 	page = pfn_to_page(start >> PAGE_SHIFT);
-	nr_pages = (end + 1 - start) >> PAGE_SHIFT;
+	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
 	if (protect)
 		return set_pages_ro(page, nr_pages);
 	else
@@ -566,9 +569,9 @@ static void kexec_mark_crashkres(bool pr
 	/* Don't touch the control code page used in crash_kexec().*/
 	control = PFN_PHYS(page_to_pfn(kexec_crash_image->control_code_page));
 	/* Control code page is located in the 2nd page. */
-	control = control + PAGE_SIZE;
-	kexec_mark_range(crashk_res.start, control - 1, protect);
-	kexec_mark_range(control + PAGE_SIZE, crashk_res.end, protect);
+	kexec_mark_range(crashk_res.start, control + PAGE_SIZE - 1, protect);
+	control += KEXEC_CONTROL_PAGE_SIZE;
+	kexec_mark_range(control, crashk_res.end, protect);
 }
 
 void arch_kexec_protect_crashkres(void)
@@ -580,4 +583,3 @@ void arch_kexec_unprotect_crashkres(void
 {
 	kexec_mark_crashkres(false);
 }
-#endif
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch
kexec-provide-arch_kexec_protectunprotect_crashkres.patch

