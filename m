Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEEE23A564
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967331; cv=none; b=e96kr47nUpTNfl3Rhk+jwYlUVwF3i4MgH5l7N50yc4I6iQlBTZ9EZ5wXmf0fSiA/v+5e+YutZKAS/svhoNsOivO9gzj+gTGglx2/wUVxAjsNcCyhQnh9928qlnjSdHsStbF7/ehwoZ2ePIktSPYWN4kYbqK8VPMObtBEmZfkhLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967331; c=relaxed/simple;
	bh=oWp2EAg1obXz/yR/pKriNCl+9dZ8l1tt8z01yAcVAzQ=;
	h=Date:To:From:Subject:Message-Id; b=m2z2mRDbFHCICxXrwkRiH1DV+zymJUM483gH1sAPtR8Gtx35Cbbuh5CWOix/amIxnHa+aphOTpgMo2w/9TTs/RaTZn+sKrB8quQ/PbdpPnIDJJhw0BXKnxiZdmrER3Ozfp+5eyr4rb+y1m5X16SavpbZke0NnTjCXrTqt68kkYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EV08dktG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EV08dktG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47447C16AAE;
	Wed, 21 Jan 2026 03:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967330;
	bh=oWp2EAg1obXz/yR/pKriNCl+9dZ8l1tt8z01yAcVAzQ=;
	h=Date:To:From:Subject:From;
	b=EV08dktGhdrld4EZ4nd5ROI+F11OCeKLm1ABszvgmulbaR+3H7lCoD5YiFoEVAYxg
	 zXiLZTyoKsU+wI6At7RvF2bZoVbw4/ZrnZnZPzvvWH4h1R4if+tGJcS6XrM1YFrCQC
	 KAdzqS0CnQKogTWgiK6AaOpUGTs4TwmTrLMOQagE=
Date: Tue, 20 Jan 2026 19:48:49 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch removed from -mm tree
Message-Id: <20260121034850.47447C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/crash: handle multi-page vmcoreinfo in crash kernel copy
has been removed from the -mm tree.  Its filename was
     kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pnina Feder <pnina.feder@mobileye.com>
Subject: kernel/crash: handle multi-page vmcoreinfo in crash kernel copy
Date: Tue, 16 Dec 2025 15:28:01 +0200

kimage_crash_copy_vmcoreinfo() currently assumes vmcoreinfo fits in a
single page.  This breaks if VMCOREINFO_BYTES exceeds PAGE_SIZE.

Allocate the required order of control pages and vmap all pages needed to
safely copy vmcoreinfo into the crash kernel image.

Link: https://lkml.kernel.org/r/20251216132801.807260-3-pnina.feder@mobileye.com
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/kernel/crash_core.c~kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy
+++ a/kernel/crash_core.c
@@ -44,9 +44,15 @@ note_buf_t __percpu *crash_notes;
 
 int kimage_crash_copy_vmcoreinfo(struct kimage *image)
 {
-	struct page *vmcoreinfo_page;
+	struct page *vmcoreinfo_base;
+	struct page *vmcoreinfo_pages[DIV_ROUND_UP(VMCOREINFO_BYTES, PAGE_SIZE)];
+	unsigned int order, nr_pages;
+	int i;
 	void *safecopy;
 
+	nr_pages = DIV_ROUND_UP(VMCOREINFO_BYTES, PAGE_SIZE);
+	order = get_order(VMCOREINFO_BYTES);
+
 	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
 		return 0;
 	if (image->type != KEXEC_TYPE_CRASH)
@@ -61,12 +67,15 @@ int kimage_crash_copy_vmcoreinfo(struct
 	 * happens to generate vmcoreinfo note, hereby we rely on
 	 * vmap for this purpose.
 	 */
-	vmcoreinfo_page = kimage_alloc_control_pages(image, 0);
-	if (!vmcoreinfo_page) {
+	vmcoreinfo_base = kimage_alloc_control_pages(image, order);
+	if (!vmcoreinfo_base) {
 		pr_warn("Could not allocate vmcoreinfo buffer\n");
 		return -ENOMEM;
 	}
-	safecopy = vmap(&vmcoreinfo_page, 1, VM_MAP, PAGE_KERNEL);
+	for (i = 0; i < nr_pages; i++)
+		vmcoreinfo_pages[i] = vmcoreinfo_base + i;
+
+	safecopy = vmap(vmcoreinfo_pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!safecopy) {
 		pr_warn("Could not vmap vmcoreinfo buffer\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are


