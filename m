Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506BE1A7AF6
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727983719; cv=none; b=kfirpz2RAltLOqgHcm7GeM1zRPVgEK0ku09J3luqSrM2p9xdG94iNgRaCf4rRDHSMOtxwZOm4J13CsQhS0p3i391uF1VBYWRkg/ZLc2pNT+XvqWSa7ARnSrktZHOBW55jM9bp7pPJqvGU+RoN8WqFUHXCKXFQCtk9e6OhfwIU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727983719; c=relaxed/simple;
	bh=zBQEYAcIGUCif6vrKbvrIly8C1PeBNwv7GryL7auwEU=;
	h=Date:To:From:Subject:Message-Id; b=H2bJsDJvfmT/YU/Qmx31UiYiXpMju0/BAyB7SKGnFs2dCAcWAd8tVlbiPkog18jlUMECtRwkvo6yal1heW+Gm0ndr7oVzy6RjmBIdFxwAZHvDesrGBItQa8yxM6a8moATphMXhJQw4OJBejSVmrC3cvPNgi+q8SERexYPxyKN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1igF6vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1igF6vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790ABC4CEC5;
	Thu,  3 Oct 2024 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727983718;
	bh=zBQEYAcIGUCif6vrKbvrIly8C1PeBNwv7GryL7auwEU=;
	h=Date:To:From:Subject:From;
	b=Z1igF6vD07t6Ay0GHW/g8/LzQcBvnptYotzhCSa2fQk96Vvj8agoIukbXWdwOVJ2R
	 fatPGi33rIn4XUQ5YsNy2agwZKVScFNO/x3r3SRFqHv3aKi7o7IopPJSEgpVtAlQLC
	 TyPm+pHprgZMIhjhQwkkr4O3DqnZfO+fFMHJ0lN0=
Date: Thu, 03 Oct 2024 12:28:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch removed from -mm tree
Message-Id: <20241003192838.790ABC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: percpu: fix typo to pcpu_alloc_noprof() description
has been removed from the -mm tree.  Its filename was
     mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm: percpu: fix typo to pcpu_alloc_noprof() description
Date: Wed, 25 Sep 2024 00:24:12 +0900

In the previous commit, the function name was changed from pcpu_alloc to
pcpu_alloc_noprof , but the function description was not changed
accordingly.  The function name should be changed to pcpu_alloc_noprof in
the description as well.

Link: https://lkml.kernel.org/r/20240924152412.118487-1-aha310510@gmail.com
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-fix-typo-to-pcpu_alloc_noprof-description
+++ a/mm/percpu.c
@@ -1726,7 +1726,7 @@ static void pcpu_alloc_tag_free_hook(str
 #endif
 
 /**
- * pcpu_alloc - the percpu allocator
+ * pcpu_alloc_noprof - the percpu allocator
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  * @reserved: allocate from the reserved chunk if available
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-shmem-fix-data-race-in-shmem_getattr.patch

