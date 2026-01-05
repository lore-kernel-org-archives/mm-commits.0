Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFEA221FCA
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648250; cv=none; b=m6fs/9rygWsg81HluwecYbYGy7WQ6tGN6K2cSrOMvkctPRsXUZF95YJ3CDE4/fy+Qlp7oKGgVXsBdfNhYJxSdISP1jogFi6832bBGFwfNUktsIIamj7cTDIJ1Vo3xjvMSH0WLVWwNaqGTNKYBp08L6H40hsex3XzII63mWt8ADo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648250; c=relaxed/simple;
	bh=1SXk9cIZdADuo1462yM0aX8SerYNYh9gaAGNnMYOaXo=;
	h=Date:To:From:Subject:Message-Id; b=n7UpUVtqn5mNh4JVtKu4vtS3L1gTrrnWNIkTk5Mqch/PU3Yj2woUWq8sKVh9FcyrwnsijrNRpI1vhu4Dsiq9n8ZPp0wY1rRvtmeqii3FwWmcxY/jIFiKuAlJMn5tDz3YSrCYsX7wadwGPwnBiroQoogf7YJdX6jqwCV8wDnqJVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dmtq0/w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dmtq0/w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B8C116D0;
	Mon,  5 Jan 2026 21:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767648250;
	bh=1SXk9cIZdADuo1462yM0aX8SerYNYh9gaAGNnMYOaXo=;
	h=Date:To:From:Subject:From;
	b=Dmtq0/w6yiK2Bk3mt8Nb4tpQW1dmwlTRrTyQVZPrdguwy+5Xcffpp8InEY1GXFwPF
	 vZ8zIK4zCaN5zBeMI2MZ13GiNFfDh4ddSirHszL7PmfuYLk+QAqwdBwvAuSO8S6alR
	 DgXvOZ+5pC99lP2ZaqzrQnvmnYrXV6ejMpV9GydI=
Date: Mon, 05 Jan 2026 13:24:09 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-abi-luo-make-generated-documentation-more-coherent.patch added to mm-nonmm-unstable branch
Message-Id: <20260105212410.093B8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho/abi: luo: make generated documentation more coherent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-abi-luo-make-generated-documentation-more-coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-abi-luo-make-generated-documentation-more-coherent.patch

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
Cc: Alexander Graf <graf@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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

mips-fix-highmem-initialization.patch
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
kho-abi-luo-make-generated-documentation-more-coherent.patch
kho-abi-memfd-make-generated-documentation-more-coherent.patch
kho-docs-combine-concepts-and-fdt-documentation.patch
kho-abi-add-memblock-abi-header.patch

