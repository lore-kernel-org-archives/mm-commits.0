Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721F132144A
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282385; cv=none; b=rIGBxntGq2uU8ukh9+7M67x7SfxvgEpJ7POJHEnGnESSIlp2Q3b2VcyOQpPyIRrVLuf5TzE1kKGFSUxlnFJ91elFuqtT+EBYiF/urZy61ojrU15KCBb3VssqcyAW6MA1Zbvt4oDad4rgXE0iKnVBUfD+awXLo+HjkCiQYIqjCrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282385; c=relaxed/simple;
	bh=LRocVk35H8Zon9wGuRAoKAOCJkqemRfKDVqu+2D9auM=;
	h=Date:To:From:Subject:Message-Id; b=CFFarbjmJeQ1Zflzl1zV94ynEqNcCwrQzpKELPrrM6J/G37oTl4Twk1dSedg17GnSRjkC+Xs07MxM9muHtmNIeWcYJeRHswnXwyavOHcGiyTENEsGqCqW8UylPJp44WwGt36scpP6L5s1Lg52+sy4CnY3Hg0ddPMpnUKH5m9xIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pL+z8Yiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pL+z8Yiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0790FC4CEF8;
	Thu, 27 Nov 2025 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282385;
	bh=LRocVk35H8Zon9wGuRAoKAOCJkqemRfKDVqu+2D9auM=;
	h=Date:To:From:Subject:From;
	b=pL+z8YiwqGijBrs1+B3jsYVtUIowPDjC0Bk9R+2uEeUdReVvvlLI36MULyrQoP7+W
	 g86IkXC0xsKPxZVMKLhkYQBTxo27yKjwPKRu9c2R6vQTC6DzO0s+Fvb4SEzTAcNsSq
	 LpppXPYT2nspZIitywf/uO5BMCyTRs9GXVifVX+w=
Date: Thu, 27 Nov 2025 14:26:24 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-allow-kexec-load-before-kho-finalization.patch removed from -mm tree
Message-Id: <20251127222625.0790FC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: allow kexec load before KHO finalization
has been removed from the -mm tree.  Its filename was
     kho-allow-kexec-load-before-kho-finalization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: allow kexec load before KHO finalization
Date: Fri, 14 Nov 2025 14:00:00 -0500

Currently, kho_fill_kimage() checks kho_out.finalized and returns early if
KHO is not yet finalized.  This enforces a strict ordering where userspace
must finalize KHO *before* loading the kexec image.

This is restrictive, as standard workflows often involve loading the
target kernel early in the lifecycle and finalizing the state (FDT) only
immediately before the reboot.

Since the KHO FDT resides at a physical address allocated during boot
(kho_init), its location is stable.  We can attach this stable address to
the kimage regardless of whether the content has been finalized yet.

Relax the check to only require kho_enable, allowing kexec_file_load to
proceed at any time.

Link: https://lkml.kernel.org/r/20251114190002.3311679-12-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-allow-kexec-load-before-kho-finalization
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_out.finalized)
+	if (!kho_enable)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

