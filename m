Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDD66F2F9
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423448; cv=none; b=QdwZRCm5zJWgTLcdiPaLBoOHjmEcevcvhMe1FROrVHOYuHg0xQv+tNe9eaw4XaTeBNpaH4xrcgST6CMityHVDd0RJcDQ4JtipvDj/RUYf7L7QE6rbnMhRzDdXIpnt9OR2LVSWg+9qEs6v5EO6/zpcDzPCqLcTMKwQCE14G7jG8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423448; c=relaxed/simple;
	bh=svSKHXsEnNdPpbSuyPozwOSM35sp5t6X9iKHHcKNwNk=;
	h=Date:To:From:Subject:Message-Id; b=Eu4PlbUN1L1sT9AO9AzQSgQQO+BTypd4csSMABgOJFIMkTOv4mH3U8l4UgMlrBQd3b3Ni03sE8Lci7zp7sE8X8Ao8ceYuZjulflbROw0Eo+EPC9efkRVW7IGmYydOjANJHS5obF05t1OrxCwxgm8Uhn0JrlznpIILxp7f4VldVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QKAkbPRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QKAkbPRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07F9C4CEC2;
	Wed,  4 Sep 2024 04:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423448;
	bh=svSKHXsEnNdPpbSuyPozwOSM35sp5t6X9iKHHcKNwNk=;
	h=Date:To:From:Subject:From;
	b=QKAkbPRjSgXWSxFZLZ4i7Iv10ytHPQUZUDTIaL+6ZMl32cX0rKnv3Uz9RmyVYQCd4
	 JnYhBWTxNOAjhJTvYPh7PAbQGJsAAOv2A9gw2VtDRUFOFax2hyG+8t0+wFas8Uxl1C
	 3PVweSSdblJJOScSmn9eMrxbN+nQYx5mrG7hK0qk=
Date: Tue, 03 Sep 2024 21:17:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch removed from -mm tree
Message-Id: <20240904041727.E07F9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_memblks: use memblock_{start,end}_of_DRAM() when sanitizing meminfo
has been removed from the -mm tree.  Its filename was
     mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: numa_memblks: use memblock_{start,end}_of_DRAM() when sanitizing meminfo
Date: Wed, 7 Aug 2024 09:41:06 +0300

numa_cleanup_meminfo() moves blocks outside system RAM to
numa_reserved_meminfo and it uses 0 and PFN_PHYS(max_pfn) to determine the
memory boundaries.

Replace the memory range boundaries with more portable
memblock_start_of_DRAM() and memblock_end_of_DRAM().

Link: https://lkml.kernel.org/r/20240807064110.1003856-23-rppt@kernel.org
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

 mm/numa_memblks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/numa_memblks.c~mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo
+++ a/mm/numa_memblks.c
@@ -212,8 +212,8 @@ int __init numa_add_memblk(int nid, u64
  */
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
-	const u64 low = 0;
-	const u64 high = PFN_PHYS(max_pfn);
+	const u64 low = memblock_start_of_DRAM();
+	const u64 high = memblock_end_of_DRAM();
 	int i, j, k;
 
 	/* first, trim all entries */
_

Patches currently in -mm which might be from rppt@kernel.org are


