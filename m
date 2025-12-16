Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0772D23B6
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909455; cv=none; b=BeXlUIF4TzsyL0NK9Y03JGo19BLJQRDnRr2y2rSQuE45kV21DHP0M85BX4rMz4S62H1wP6izomlAuMDL6cARcEJQT5aWTrGisVo2B1RXYsce8tGfplzplazWL/pvPVhWeh8CyCaxjWSptxVAGXBiROPbXB4CiRWKlkULfQLWisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909455; c=relaxed/simple;
	bh=4rHpRi0ckbgx+CUwRvCiIdCD6L1nEdQon9UmQC/MN9I=;
	h=Date:To:From:Subject:Message-Id; b=UccOvhRVe4tpb/WKTRQAD7TuAtZgXMl2CqAAyix6BNgl2yqHPmboED60d1exzSLdDBqcBk3y83zfMgKeZ8v7QgPp75aVT//mkakqxXqsTFuGXEMlaFZ8mYQoszwYmGE2rdi/GSPwE9e4LSNZpB3DRSywYPfXNGyURKDXWc/m2U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CssUQ/3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CssUQ/3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021EEC4CEF1;
	Tue, 16 Dec 2025 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765909455;
	bh=4rHpRi0ckbgx+CUwRvCiIdCD6L1nEdQon9UmQC/MN9I=;
	h=Date:To:From:Subject:From;
	b=CssUQ/3ipfOcB7EiF1+/fuSXmAxjzaTZvJI3jDKJsrEYoQ/FhwajiWOkqTvNtzKvF
	 gfds4xNo1cAPw0Y8Vj5OzfCzD9eHpy4nMv1WzUTSYMR6tDZvh9OQPpvoOV7l/s58Ef
	 Zjhnjjg0RW+21xKIj3vE0lXRlkxeOmqKJ2LUGxm8=
Date: Tue, 16 Dec 2025 10:24:14 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch added to mm-nonmm-unstable branch
Message-Id: <20251216182415.021EEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/crash: handle multi-page vmcoreinfo in crash kernel copy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch
kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch

