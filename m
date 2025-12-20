Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3223EA99
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271277; cv=none; b=KHmFOWsjF7vyuFQYp6gdM7TEL3YuAw10WfVmVE2lyP5FIYHCQNJUa6HV6RDJRv+EOyR078e1mRx77wA9vwVE3huSUAc28Qs4Tm2DWvWOdf5CHwe+KbIrS1XzKWs7AMO/hyYdYrfH+1p4+TxTJy+2LS0AvPyQsTKbW+YrvLV/OXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271277; c=relaxed/simple;
	bh=w2IV+rFkKm5WBjevA4NsAcYY07/Aystqt6t1slTXYX4=;
	h=Date:To:From:Subject:Message-Id; b=MfANazss4SIjsLoy+1l6YosLLGRinDELD0Ov6bNIOp1ZTTSKFYzNUf7EB2E5YSLb2ojfxCgkq4+Kmo2pbmLZtNbK8poOaUZOKHz59NsgXuqDZPK0inqNvB6fO7yp8sZB+Sy/h/tDN0rxIq8SKKTZgMSoCRw3NrdueDB3cRETK0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2E/NbrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2E/NbrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9021C4CEF5;
	Sat, 20 Dec 2025 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271276;
	bh=w2IV+rFkKm5WBjevA4NsAcYY07/Aystqt6t1slTXYX4=;
	h=Date:To:From:Subject:From;
	b=J2E/NbrZ4VY94MlETyZShTq2hNpItVWfem4G7eVSqiadD0wiDnww2TBJnyH5xk6gP
	 HKL2lOq67jV4WWNPeXhEcOOQgNNE5rOlLOEhz0k9uG7P78F6K7slvVB1quDDVd4UT6
	 TX8QamoCdCGJu39+z/xBRPUXWHOJiCXtLyFyZtM4=
Date: Sat, 20 Dec 2025 14:54:36 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch added to mm-nonmm-unstable branch
Message-Id: <20251220225436.C9021C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: kexec: adjust the debug print of kexec_image_info
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: arm64: kexec: adjust the debug print of kexec_image_info
Date: Fri, 19 Dec 2025 17:31:34 +0800

In the previous patch, we move start/head of kimage to the generic code,
so, we remove them to avoid duplicate printing.

Link: https://lkml.kernel.org/r/20251219093134.2268620-5-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/machine_kexec.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/kernel/machine_kexec.c~arm64-kexec-adjust-the-debug-print-of-kexec_image_info
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -34,8 +34,6 @@ static void _kexec_image_info(const char
 {
 	kexec_dprintk("%s:%d:\n", func, line);
 	kexec_dprintk("  kexec kimage info:\n");
-	kexec_dprintk("    type:        %d\n", kimage->type);
-	kexec_dprintk("    head:        %lx\n", kimage->head);
 	kexec_dprintk("    kern_reloc: %pa\n", &kimage->arch.kern_reloc);
 	kexec_dprintk("    el2_vectors: %pa\n", &kimage->arch.el2_vectors);
 }
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-replace-the-goto-out_unlock-with-out.patch
kexec-add-kexec-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

