Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3BA3563D6
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967378; cv=none; b=cWKmZqQ6Gr8nrMY++VesKB41W4yVEKiYG6iyc2iKPBQaWFujterjqDrrWOHnZCJxU1zczYmMwlNtXPK8cpqNLJtn9fhOKMd49cB5CUQuFg/XeRmJBHMHyn1nzaqYPpZKQkwySbCoIDKTWA1736pLpOSnl0Ax3CbbBe9qarnwE/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967378; c=relaxed/simple;
	bh=jrGrMd0WLxZ6Y+3F68QHDMsHUAxbxBV7zESwPc8sPGQ=;
	h=Date:To:From:Subject:Message-Id; b=oKY6dbb+DCnH43TwhjXN7mBeQ+AwknQo/5311g8Wi0I7xgfZbM28Jb+CW4lJfK8VmZxGwbCzD7HTTsYHQypoAONP4g73cjZoMGjot1ZmEMBWE7Hi5k6aMtld+XLOIhRCuyIRXKIKgJ5rhKAqttMXYr0Kll9mh+6hq/7I1XeNrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xqdW4yns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xqdW4yns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D93C16AAE;
	Wed, 21 Jan 2026 03:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967378;
	bh=jrGrMd0WLxZ6Y+3F68QHDMsHUAxbxBV7zESwPc8sPGQ=;
	h=Date:To:From:Subject:From;
	b=xqdW4ynsD9Htrbscy3UkEphNjonbLUlGqF6298fQNhpVUU7z/KzKCdcpF0E5YLw1n
	 riFyv6PrSCND8ZOChvlr4J//iVkIy753h2oPgTurPeK4MA6HraW2ZPbpnpSLqPH5n9
	 2BDo78AUhsd5IlYlPvCLvYnWBqS9OSGidpkh+mZo=
Date: Tue, 20 Jan 2026 19:49:37 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-abi-luo-make-generated-documentation-more-coherent.patch removed from -mm tree
Message-Id: <20260121034938.44D93C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho/abi: luo: make generated documentation more coherent
has been removed from the -mm tree.  Its filename was
     kho-abi-luo-make-generated-documentation-more-coherent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho/abi: luo: make generated documentation more coherent
Date: Mon, 5 Jan 2026 18:58:34 +0200

Patch series "kho: ABI headers and Documentation updates".

LUO started adding KHO ABI headers to include/linux/kho/abi, but the core
parts of KHO and memblock are still using the old way for descriptions on
their ABIs.

Let's consolidate all things KHO in include/linux/kho/abi.

And while on that, make some documentation updates to have more coherent
KHO docs.


This patch (of 6):

LUO ABI description starts with "This header defines" which is fine in the
header but reads weird in the generated html documentation.

Update it to make the generated documentation coherent.

Link: https://lkml.kernel.org/r/20260105165839.285270-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20260105165839.285270-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Miu <jasonmiu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/luo.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kho/abi/luo.h~kho-abi-luo-make-generated-documentation-more-coherent
+++ a/include/linux/kho/abi/luo.h
@@ -8,10 +8,10 @@
 /**
  * DOC: Live Update Orchestrator ABI
  *
- * This header defines the stable Application Binary Interface used by the
- * Live Update Orchestrator to pass state from a pre-update kernel to a
- * post-update kernel. The ABI is built upon the Kexec HandOver framework
- * and uses a Flattened Device Tree to describe the preserved data.
+ * Live Update Orchestrator uses the stable Application Binary Interface
+ * defined below to pass state from a pre-update kernel to a post-update
+ * kernel. The ABI is built upon the Kexec HandOver framework and uses a
+ * Flattened Device Tree to describe the preserved data.
  *
  * This interface is a contract. Any modification to the FDT structure, node
  * properties, compatible strings, or the layout of the `__packed` serialization
_

Patches currently in -mm which might be from rppt@kernel.org are

alpha-introduce-arch_zone_limits_init.patch
arc-introduce-arch_zone_limits_init.patch
arm-introduce-arch_zone_limits_init.patch
arm64-introduce-arch_zone_limits_init.patch
csky-introduce-arch_zone_limits_init.patch
hexagon-introduce-arch_zone_limits_init.patch
loongarch-introduce-arch_zone_limits_init.patch
m68k-introduce-arch_zone_limits_init.patch
microblaze-introduce-arch_zone_limits_init.patch
mips-introduce-arch_zone_limits_init.patch
nios2-introduce-arch_zone_limits_init.patch
openrisc-introduce-arch_zone_limits_init.patch
parisc-introduce-arch_zone_limits_init.patch
powerpc-introduce-arch_zone_limits_init.patch
riscv-introduce-arch_zone_limits_init.patch
s390-introduce-arch_zone_limits_init.patch
sh-introduce-arch_zone_limits_init.patch
sparc-introduce-arch_zone_limits_init.patch
um-introduce-arch_zone_limits_init.patch
x86-introduce-arch_zone_limits_init.patch
xtensa-introduce-arch_zone_limits_init.patch
arch-mm-consolidate-initialization-of-nodes-zones-and-memory-map.patch
arch-mm-consolidate-initialization-of-sparse-memory-model.patch
mips-drop-paging_init.patch
x86-dont-reserve-hugetlb-memory-in-setup_arch.patch
mm-arch-consolidate-hugetlb-cma-reservation.patch
mm-hugetlb-drop-hugetlb_cma_check.patch
revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch

