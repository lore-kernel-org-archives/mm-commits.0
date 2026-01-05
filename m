Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91211F4168
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648252; cv=none; b=kvPRmJj9skvWRZ/ul/uKZ6ldBt9zrsiQ4FvwO+1wKZi8UhegAKGDgKa5pQdVdly1de5Sjuwfodhe5OhB+1r487Tq490XeQ+VmDPGFuzF7kHXgG0RKw8o89gNYtCn+lD9aWBPatK628S/QJJT8Qsk4HDMstyH7OnMjEktJokkQVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648252; c=relaxed/simple;
	bh=lRadaCDsEasN+yxUnumyLMDCwL+zIe/hLRDcQcOPuPg=;
	h=Date:To:From:Subject:Message-Id; b=IY9T1UoIzgIsSCsaT+UTTwdJrJ9o+JDPsuLm0LPxbZ5gvwPQxvfpSZFSqG12mQ7z0EJCKb0wxKvD+57g6YoigVCFZI/czJByw/fowIY6TXWVuOumjpIHW5RYoISMrMTgDVrh3yZ3mBYS9VhdYYp0n6I2i5ybWXNlkzq6kPU4qNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fZP8QANW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fZP8QANW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348DC116D0;
	Mon,  5 Jan 2026 21:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767648252;
	bh=lRadaCDsEasN+yxUnumyLMDCwL+zIe/hLRDcQcOPuPg=;
	h=Date:To:From:Subject:From;
	b=fZP8QANWntXLeGLgSAXQUMp7k2UWIr4xGBFsZX+YCkx8PwF5/bZWw9Gf2DXvS4hu4
	 NN6hieXqPkR/w9nvjM9aXHXDJmoCo/RrNngrlOYadJA8iaLQe0WCPvXJVa7wNZYdi/
	 HmYauIN5yDx/4ibsmjcYU+AcSWEvRKimfMroitcQ=
Date: Mon, 05 Jan 2026 13:24:11 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-abi-memfd-make-generated-documentation-more-coherent.patch added to mm-nonmm-unstable branch
Message-Id: <20260105212412.2348DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho/abi: memfd: make generated documentation more coherent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-abi-memfd-make-generated-documentation-more-coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-abi-memfd-make-generated-documentation-more-coherent.patch

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
Subject: kho/abi: memfd: make generated documentation more coherent
Date: Mon, 5 Jan 2026 18:58:35 +0200

memfd preservation ABI description starts with "This header defines" which
is fine in the header but reads weird in the generated html documentation.

Update it to make the generated documentation coherent.

Link: https://lkml.kernel.org/r/20260105165839.285270-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/memfd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kho/abi/memfd.h~kho-abi-memfd-make-generated-documentation-more-coherent
+++ a/include/linux/kho/abi/memfd.h
@@ -17,8 +17,8 @@
 /**
  * DOC: memfd Live Update ABI
  *
- * This header defines the ABI for preserving the state of a memfd across a
- * kexec reboot using the LUO.
+ * memfd uses the ABI defined below for preserving its state across a kexec
+ * reboot using the LUO.
  *
  * The state is serialized into a packed structure `struct memfd_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
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

