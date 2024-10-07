Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3A9320F
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327670; cv=none; b=oYtAQitkAgk5RkrvpplyvF9LC7dzr7QcSH4mzYCDCkmqdTVRku/L1Pl6sR+6g1fS1C1569AGhg0d35dIpB+7FMRyHtg+gPGILVRMP2s/e1Mao6CvAYmuKb7NVOXVSBTMhkiTjRdoKE0VeEdDBkaU040vSd/MyEk5t3IV70rh3ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327670; c=relaxed/simple;
	bh=jvgUcVBazRoG5WuieUM8zQy5FAZ8ZbnJCl1h3Fi8Hq8=;
	h=Date:To:From:Subject:Message-Id; b=RSusACAU4jsR410JivQesy2MX4mVcce33BY8fXjlYZdN4srEPGUMbvdsWuDkO/Zs45SBPTbpwSW03GIylKhP8GFsIzopIPHdHONiOdx2UeKn2Vbiz2FOnxiFoAsh2PfzphbZkMd2NwQ7hF+tUV8VcAX07DzbRWbP+WgGUGfPoEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yuecog7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yuecog7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E49C4CEC6;
	Mon,  7 Oct 2024 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728327670;
	bh=jvgUcVBazRoG5WuieUM8zQy5FAZ8ZbnJCl1h3Fi8Hq8=;
	h=Date:To:From:Subject:From;
	b=Yuecog7YSN16zC8omU/VaWYcIt+AsMP0WZe8+DlraCcstklTj60kV6ZGSHOr2NhEe
	 BXtsO25t8dDcaMaCMcMdDv5aWfQQ1yJKarnsYvyWogERDtBeT4groY5F0kmnsytB5z
	 IDOllPh9eEdn/Bfrt9pBeR6XdySoVtK+Y5tlFtw8=
Date: Mon, 07 Oct 2024 12:01:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch added to mm-unstable branch
Message-Id: <20241007190110.35E49C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove misleading 'unlikely' hint in vms_gather_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch

This patch will later appear in the mm-unstable branch at
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
From: Breno Leitao <leitao@debian.org>
Subject: mm: remove misleading 'unlikely' hint in vms_gather_munmap_vmas()
Date: Fri, 4 Oct 2024 09:48:31 -0700

Performance analysis using branch annotation on a fleet of 200 hosts
running web servers revealed that the 'unlikely' hint in
vms_gather_munmap_vmas() was 100% consistently incorrect.  In all observed
cases, the branch behavior contradicted the hint.

Remove the 'unlikely' qualifier from the condition checking 'vms->uf'.  By
doing so, we allow the compiler to make optimization decisions based on
its own heuristics and profiling data, rather than relying on a static
hint that has proven to be inaccurate in real-world scenarios.

Link: https://lkml.kernel.org/r/20241004164832.218681-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas
+++ a/mm/vma.c
@@ -1250,7 +1250,7 @@ int vms_gather_munmap_vmas(struct vma_mu
 		else if (is_data_mapping(next->vm_flags))
 			vms->data_vm += nrpages;
 
-		if (unlikely(vms->uf)) {
+		if (vms->uf) {
 			/*
 			 * If userfaultfd_unmap_prep returns an error the vmas
 			 * will remain split, but userland will get a
_

Patches currently in -mm which might be from leitao@debian.org are

mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch
scripts-decode_stacktracesh-remove-trailing-space.patch

