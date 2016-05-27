From: akpm@linux-foundation.org
Subject: [merged]
 kexec-provide-arch_kexec_protectunprotect_crashkres.patch removed from -mm
 tree
Date: Fri, 27 May 2016 11:43:36 -0700
Message-ID: <57489558.EEqQf8XgTl4DYhIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Snh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mhuang@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: provide arch_kexec_protect(unprotect)_crashkres()
has been removed from the -mm tree.  Its filename was
     kexec-provide-arch_kexec_protectunprotect_crashkres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: provide arch_kexec_protect(unprotect)_crashkres()

Implement the protection method for the crash kernel memory reservation
for the 64-bit x86 kdump.

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   45 +++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -538,3 +538,48 @@ overflow:
 	return -ENOEXEC;
 }
 #endif /* CONFIG_KEXEC_FILE */
+
+static int
+kexec_mark_range(unsigned long start, unsigned long end, bool protect)
+{
+	struct page *page;
+	unsigned int nr_pages;
+
+	/*
+	 * For physical range: [start, end]. We must skip the unassigned
+	 * crashk resource with zero-valued "end" member.
+	 */
+	if (!end || start > end)
+		return 0;
+
+	page = pfn_to_page(start >> PAGE_SHIFT);
+	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
+	if (protect)
+		return set_pages_ro(page, nr_pages);
+	else
+		return set_pages_rw(page, nr_pages);
+}
+
+static void kexec_mark_crashkres(bool protect)
+{
+	unsigned long control;
+
+	kexec_mark_range(crashk_low_res.start, crashk_low_res.end, protect);
+
+	/* Don't touch the control code page used in crash_kexec().*/
+	control = PFN_PHYS(page_to_pfn(kexec_crash_image->control_code_page));
+	/* Control code page is located in the 2nd page. */
+	kexec_mark_range(crashk_res.start, control + PAGE_SIZE - 1, protect);
+	control += KEXEC_CONTROL_PAGE_SIZE;
+	kexec_mark_range(control, crashk_res.end, protect);
+}
+
+void arch_kexec_protect_crashkres(void)
+{
+	kexec_mark_crashkres(true);
+}
+
+void arch_kexec_unprotect_crashkres(void)
+{
+	kexec_mark_crashkres(false);
+}
_

Patches currently in -mm which might be from xlpang@redhat.com are


