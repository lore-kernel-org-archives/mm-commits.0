Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E6933B6FE
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967329; cv=none; b=Vj7uYnbuVlFnd5MgqvnZ3FeYIAiuv4jiEbp62UaiyBDTpJIiSP62PWzhcKZ5AZtcPsMZ+9tV/FOdULLwpSK4fCXF40COoiU29u1WWDZQ//eLyr5dGhzsnfwm3cSs2zeZvAcMeHTW1GKb1enaJ6etZd3IjR43i0JN4Z/zL+ILQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967329; c=relaxed/simple;
	bh=cginHxK4ZcVvRM32tf0dBtrFXWfnT5iSYyl2yuFu7vY=;
	h=Date:To:From:Subject:Message-Id; b=NxxyTkRyt5XH2DWXTLJALZZrjHg8zm0xquhqVHq90/2DUZESvQpFdTmtVxRym1i+o8Pp+8uAlplDm7ZcHaMfSNecnpUbVYPPaL4d5sXsxLkcbzkGSZa6h0uk6233lf8lwwOEDDzgXEH2INHjOJy9anbfvAACzNkThYCUHT85cGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kpc/qcP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kpc/qcP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BEAC16AAE;
	Wed, 21 Jan 2026 03:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967329;
	bh=cginHxK4ZcVvRM32tf0dBtrFXWfnT5iSYyl2yuFu7vY=;
	h=Date:To:From:Subject:From;
	b=kpc/qcP/GfX09J1C86JHOlM4bLTnPd/S4gf8nmmzQWCm0Uc/PFM+CPm66qePM92HZ
	 b/O7qZhxumOtWtMg0bJXN+Xd4dj6f5Mwfpg9/TimzR2dRdeTJSoQbtfTiklabCeXrg
	 QyvmfD9T0rZDdpskI5jnhUxBaODbptVvSk9icQh8=
Date: Tue, 20 Jan 2026 19:48:48 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch removed from -mm tree
Message-Id: <20260121034849.24BEAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: vmcoreinfo: allocate vmcoreinfo_data based on VMCOREINFO_BYTES
has been removed from the -mm tree.  Its filename was
     kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pnina Feder <pnina.feder@mobileye.com>
Subject: kernel: vmcoreinfo: allocate vmcoreinfo_data based on VMCOREINFO_BYTES
Date: Tue, 16 Dec 2025 15:28:00 +0200

Patch series "vmcoreinfo: support VMCOREINFO_BYTES larger than PAGE_SIZE".

VMCOREINFO_BYTES is defined as a configurable size, but multiple
code paths implicitly assume it always fits into a single page.

This series removes that assumption by allocating and mapping
vmcoreinfo based on its actual size.

Patch 1 updates vmcoreinfo allocation to use get_order(VMCOREINFO_BYTES).
Patch 2 updates crash kernel handling to correctly allocate and map
multiple pages when copying vmcoreinfo.

This makes vmcoreinfo size consistent across the kernel and avoids
future breakage if VMCOREINFO_BYTES grows.

(No functional change when VMCOREINFO_BYTES == PAGE_SIZE.)


This patch (of 2):

VMCOREINFO_BYTES defines the size of vmcoreinfo data, but the current
implementation assumes a single page allocation.

Allocate vmcoreinfo_data using get_order(VMCOREINFO_BYTES) so that
vmcoreinfo can safely grow beyond PAGE_SIZE.

This avoids hidden assumptions and keeps vmcoreinfo size consistent across
the kernel.

Link: https://lkml.kernel.org/r/20251216132801.807260-1-pnina.feder@mobileye.com
Link: https://lkml.kernel.org/r/20251216132801.807260-2-pnina.feder@mobileye.com
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/vmcore_info.c~kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes
+++ a/kernel/vmcore_info.c
@@ -137,7 +137,9 @@ EXPORT_SYMBOL_GPL(hwerr_log_error_type);
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
+	int order;
+	order = get_order(VMCOREINFO_BYTES);
+	vmcoreinfo_data = (unsigned char *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!vmcoreinfo_data) {
 		pr_warn("Memory allocation for vmcoreinfo_data failed\n");
 		return -ENOMEM;
@@ -146,7 +148,7 @@ static int __init crash_save_vmcoreinfo_
 	vmcoreinfo_note = alloc_pages_exact(VMCOREINFO_NOTE_SIZE,
 						GFP_KERNEL | __GFP_ZERO);
 	if (!vmcoreinfo_note) {
-		free_page((unsigned long)vmcoreinfo_data);
+		free_pages((unsigned long)vmcoreinfo_data, order);
 		vmcoreinfo_data = NULL;
 		pr_warn("Memory allocation for vmcoreinfo_note failed\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are


