Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB78B3064A0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967380; cv=none; b=kYsetmA3yewSIzktShP9s4pzmPjbApajZYu6kOCWMiBSHa6aH5t90u/4ybAKuW5mgXdBxlaTSWP1fLTcsVFV6NW/uFMObeMWv24m27HTi8h69c++PjYFELeFOBbCttNIS3lM7FV/xmkwR3PSDWCQme3mQn8mXOC+rOzt0/QFZAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967380; c=relaxed/simple;
	bh=r4JedJ2LIT/TXa4sTwAX3VgHBL6rDBvK3MiBaPi3Bhs=;
	h=Date:To:From:Subject:Message-Id; b=JcZtXV0eQurOCOItfszLovC1aEnZQm6jzsweCOOZqXwcf/mDnWReE5/Iv89gK+Vx5MsQfMLdMXukVDpDfwLZspb7RxA9tcKaVSJbD0GiHDaOxwinev8QqiGtaQN9gvV8aQFBlVZtybKvOrK55YhhnzdqW5WFrgt/Zj5gnnpFJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tnMRALYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tnMRALYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692A3C16AAE;
	Wed, 21 Jan 2026 03:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967379;
	bh=r4JedJ2LIT/TXa4sTwAX3VgHBL6rDBvK3MiBaPi3Bhs=;
	h=Date:To:From:Subject:From;
	b=tnMRALYYFVn7Iv7A3ODMC+MrCH+Rj1qKrR5vkchXU1sMAYaejKp/XBfeipLCHgZkC
	 liBS8ybGnlXX8VTHjyrLUWAz/fgKnimcYyxpRY22ugeertAFc2fzRJHDk1Hr33h63J
	 7jeknegCRM2V3xDk/S3bemGICiNtUXlSWHJZwIeM=
Date: Tue, 20 Jan 2026 19:49:38 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jasonmiu@google.com,graf@amazon.com,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-abi-memfd-make-generated-documentation-more-coherent.patch removed from -mm tree
Message-Id: <20260121034939.692A3C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho/abi: memfd: make generated documentation more coherent
has been removed from the -mm tree.  Its filename was
     kho-abi-memfd-make-generated-documentation-more-coherent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho/abi: memfd: make generated documentation more coherent
Date: Mon, 5 Jan 2026 18:58:35 +0200

memfd preservation ABI description starts with "This header defines" which
is fine in the header but reads weird in the generated html documentation.

Update it to make the generated documentation coherent.

Link: https://lkml.kernel.org/r/20260105165839.285270-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
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

