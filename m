From: akpm@linux-foundation.org
Subject: + kexec-provide-arch_kexec_protectunprotect_crashkres.patch added to -mm tree
Date: Wed, 23 Dec 2015 12:30:12 -0800
Message-ID: <567b0454.3xBRJ4esKvIdoQQm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbbLWUaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 15:30:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: provide arch_kexec_protect(unprotect)_crashkres()
has been added to the -mm tree.  Its filename is
     kexec-provide-arch_kexec_protectunprotect_crashkres.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-provide-arch_kexec_protectunprotect_crashkres.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-provide-arch_kexec_protectunprotect_crashkres.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: provide arch_kexec_protect(unprotect)_crashkres()

Implement the protection method for the crash kernel memory reservation
for the 64-bit x86 kdump.

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-provide-arch_kexec_protectunprotect_crashkres
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -538,3 +538,46 @@ overflow:
 	return -ENOEXEC;
 }
 #endif /* CONFIG_KEXEC_FILE */
+
+#ifdef CONFIG_KEXEC_CORE
+static int
+kexec_mark_range(unsigned long start, unsigned long end, bool protect)
+{
+	struct page *page;
+	unsigned int nr_pages;
+
+	if (!start || !end || start >= end)
+		return 0;
+
+	page = pfn_to_page(start >> PAGE_SHIFT);
+	nr_pages = (end + 1 - start) >> PAGE_SHIFT;
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
+	control = control + PAGE_SIZE;
+	kexec_mark_range(crashk_res.start, control - 1, protect);
+	kexec_mark_range(control + PAGE_SIZE, crashk_res.end, protect);
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
+#endif
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch
kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch
kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch
kexec-provide-arch_kexec_protectunprotect_crashkres.patch

