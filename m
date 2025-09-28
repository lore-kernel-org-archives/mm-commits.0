Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B872608;
	Sun, 28 Sep 2025 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084628; cv=none; b=Iu353D5Xl7r3dXLrszejlQB0IVVsGoHpM+NLxfSsgpgAW1OUj3SP5mDZrY3FDQb/iJVINRJDKyeXRGc5qAsmO2w/uJNyx2TRY0F7/V7o7QJ9vAJQ7GOppIp4NzpuX23v9310ojujN4sNeG2SGx2fhn+BqBXcUnaAGtKygmy/lpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084628; c=relaxed/simple;
	bh=OooM5TxxX9na1EIqd/T6L4MkaZeSuPj33Oxf4uiOtkk=;
	h=Date:To:From:Subject:Message-Id; b=dQyaWwco67WqRVkWIJF6Y8P0RxF2Jg62ifSprgdy07sVfanrP57nBeLfxXa10up8c1GDJGLpRUTirKGtGtpX9zm/XHYP0ws3r/RK+3N3n6M1m8QKHirYOYCQK4T5ebjfn73iqo4s4nsj9jdZfPXozH1Cd8dr3L+kWgRrpGm6bO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FCL4d0zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FCL4d0zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED97CC4CEF0;
	Sun, 28 Sep 2025 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084628;
	bh=OooM5TxxX9na1EIqd/T6L4MkaZeSuPj33Oxf4uiOtkk=;
	h=Date:To:From:Subject:From;
	b=FCL4d0ztLma4Bzp4ksAIlCdh88cWkQIC5GjC/vJ3LynrirAswyadscm+Dmm0jxSyJ
	 dtV5DNciNwL7y/NwzLn8RmbdwUsKM1vXhN8yH0QT1k3kepnjb63OBFpyAGLdBeVctl
	 EVMl/pLsLo0lFLoH95F4+UnjYgbUH+/Rw/UfvVno=
Date: Sun, 28 Sep 2025 11:37:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-only-fill-kimage-if-kho-is-finalized.patch removed from -mm tree
Message-Id: <20250928183707.ED97CC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: only fill kimage if KHO is finalized
has been removed from the -mm tree.  Its filename was
     kho-only-fill-kimage-if-kho-is-finalized.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kho-only-fill-kimage-if-kho-is-finalized
+++ a/kernel/kexec_handover.c
@@ -1253,7 +1253,7 @@ int kho_fill_kimage(struct kimage *image
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_out.finalized)
 		return 0;
 
 	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-add-support-for-preserving-vmalloc-allocations-fix.patch

