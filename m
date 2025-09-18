Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E222D7A1
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758228065; cv=none; b=dLAMeZiGTL+hYEhnrLvHoPswrBtTXtrSqkOe10uAf2bmHMvZSgGtVq2korTymQHQS+kbzkI0MUDVJX89/iKtA5wF9gjc8469qQQY1uzT5s+WOEB6c5YjzV5SGJ/xm9rB0peUD3AKD27vSxehoiuQkOo6NKSakmLo8JxZVMbPY9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758228065; c=relaxed/simple;
	bh=dmSm1yb5Hx315GsJC27seUYSe/JINQUnHfR+NxCxhas=;
	h=Date:To:From:Subject:Message-Id; b=UKq7FP2Vagaf2oFXQJIB/udHVpEVS4lQ1E4XQJG/xPsV5nq5d4P+Buixn+r77hQzca/4A30+GbTdGLuYrwafvD67QDjXdgH8vN8ZNMWdZrMOx6mD3geswMvS8aAXelF7URGhz5M6JPQP82PDrEvOZNx0ZL6nuoOSoZamya+cNXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Y6ARNlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Y6ARNlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED29C4CEE7;
	Thu, 18 Sep 2025 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758228064;
	bh=dmSm1yb5Hx315GsJC27seUYSe/JINQUnHfR+NxCxhas=;
	h=Date:To:From:Subject:From;
	b=1Y6ARNlXBpN3HfV1YLQdy0CX5LhaJwoK2kejoHiVQL93cJOrkAeGFE15znUbeFBfz
	 t66LECBpMkQusKayqQWJH3xIO8Kdn8agEdxQyTflx2SecsxJWjNC0KwbpRdPuYV+Kf
	 MlQg8kMxgodTd6xbDzB0anNuCdmo4S3IPnjS6o2Q=
Date: Thu, 18 Sep 2025 13:41:04 -0700
To: mm-commits@vger.kernel.org,stable@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-only-fill-kimage-if-kho-is-finalized.patch added to mm-nonmm-unstable branch
Message-Id: <20250918204104.AED29C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: only fill kimage if KHO is finalized
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-only-fill-kimage-if-kho-is-finalized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-only-fill-kimage-if-kho-is-finalized.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: only fill kimage if KHO is finalized
Date: Thu, 18 Sep 2025 19:06:15 +0200

kho_fill_kimage() only checks for KHO being enabled before filling in the
FDT to the image.  KHO being enabled does not mean that the kernel has
data to hand over.  That happens when KHO is finalized.

When a kexec is done with KHO enabled but not finalized, the FDT page is
allocated but not initialized.  FDT initialization happens after finalize.
This means the KHO segment is filled in but the FDT contains garbage
data.

This leads to the below error messages in the next kernel:

    [    0.000000] KHO: setup: handover FDT (0x10116b000) is invalid: -9
    [    0.000000] KHO: disabling KHO revival: -22

There is no problem in practice, and the next kernel boots and works fine.
But this still leads to misleading error messages and garbage being
handed over.

Only fill in KHO segment when KHO is finalized.  When KHO is not enabled,
the debugfs interface is not created and there is no way to finalize it
anyway.  So the check for kho_enable is not needed, and kho_out.finalize
alone is enough.

Link: https://lkml.kernel.org/r/20250918170617.91413-1-pratyush@kernel.org
Fixes: 3bdecc3c93f9f ("kexec: add KHO support to kexec file loads")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kho-only-fill-kimage-if-kho-is-finalized
+++ a/kernel/kexec_handover.c
@@ -1527,7 +1527,7 @@ int kho_fill_kimage(struct kimage *image
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_out.finalized)
 		return 0;
 
 	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-move-sanity-checks-to-kho_restore_page.patch
kho-make-sure-page-being-restored-is-actually-from-kho.patch
kho-only-fill-kimage-if-kho-is-finalized.patch

