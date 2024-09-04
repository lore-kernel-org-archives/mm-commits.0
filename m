Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD25D5FBBA
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423428; cv=none; b=anKzYEE5HYDxd4noFX2vSJe5NZzw9TD+H5bFuGse4ftbMRkAFe/nbzYlXYwJlNC0nRJL1WjrIb3fp/6VFcrBxVxphGqK4FyUpEwQbnB6f10O0U6ibfmlYdpboYrgJiJnzLDEQshF1cWQcp6Sbub9JhcanrfK7znEUYbe4knYRkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423428; c=relaxed/simple;
	bh=vPdfus5SLnmCB3XSFsO5Q+LvOFuUwlctC0EvFc6isA4=;
	h=Date:To:From:Subject:Message-Id; b=eM3PnpZY8zlpBcIWmASCkmdWUVB2EqzpLPqomTaa/BOFu7lLQHa90e4COYKXpIT0XdrgierOUHE0Amn4SidqeI3hSgLa3XKa+g37vdqXrXuALGbo/lQ1DzkSbLkQp8JyCAmUjxW65Xj/baHrbnD9pSRVLiHOZ/gCTQtsRbP6geg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0u3P73EU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0u3P73EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A44FC4CEC2;
	Wed,  4 Sep 2024 04:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423428;
	bh=vPdfus5SLnmCB3XSFsO5Q+LvOFuUwlctC0EvFc6isA4=;
	h=Date:To:From:Subject:From;
	b=0u3P73EUgwwVikw/3LThFXb75yzAFlaNDRAe8OZ3XNAB1W+/xAb6gDPCwbNFV2hE0
	 NY2t445/1RZSaecMAdyv6fSCWjuRGm0FVqzhpa9zX8iEcZUC7VO/cdMO9z8OgISaUb
	 OIdHo/36aLGx2s4AfgJn44ZsXGET49SHnDrlG9co=
Date: Tue, 03 Sep 2024 21:17:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-numa-simplify-numa_distance-allocation.patch removed from -mm tree
Message-Id: <20240904041708.2A44FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/numa: simplify numa_distance allocation
has been removed from the -mm tree.  Its filename was
     x86-numa-simplify-numa_distance-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/numa: simplify numa_distance allocation
Date: Wed, 7 Aug 2024 09:40:54 +0300

Allocation of numa_distance uses memblock_phys_alloc_range() to limit
allocation to be below the last mapped page.

But NUMA initializaition runs after the direct map is populated and there
is also code in setup_arch() that adjusts memblock limit to reflect how
much memory is already mapped in the direct map.

Simplify the allocation of numa_distance and use plain memblock_alloc().

Link: https://lkml.kernel.org/r/20240807064110.1003856-11-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/numa.c~x86-numa-simplify-numa_distance-allocation
+++ a/arch/x86/mm/numa.c
@@ -331,7 +331,6 @@ static int __init numa_alloc_distance(vo
 	nodemask_t nodes_parsed;
 	size_t size;
 	int i, j, cnt = 0;
-	u64 phys;
 
 	/* size the new table and allocate it */
 	nodes_parsed = numa_nodes_parsed;
@@ -342,16 +341,14 @@ static int __init numa_alloc_distance(vo
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);
 
-	phys = memblock_phys_alloc_range(size, PAGE_SIZE, 0,
-					 PFN_PHYS(max_pfn_mapped));
-	if (!phys) {
+	numa_distance = memblock_alloc(size, PAGE_SIZE);
+	if (!numa_distance) {
 		pr_warn("Warning: can't allocate distance table!\n");
 		/* don't retry until explicitly reset */
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
 
-	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
 
 	/* fill with the default distances */
_

Patches currently in -mm which might be from rppt@kernel.org are


