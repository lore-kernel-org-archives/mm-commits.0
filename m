Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6754C38F91
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423430; cv=none; b=Yl2Sm8r0q7c7JR5yTRt/Q8ViuO43fLRdq3vLDTS+G0Jv/gerstJua1I9sFuaaJzxfyoWxKZjqGT7pZOjlhGUZ9nJbrYoc1WUe6C/6Qqff/hdcS8HiH+ECOQ18V0MYTT+nfbz9KvVUCuIbysTlVmt02SCyR4cUJO0XMbo1HPQhjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423430; c=relaxed/simple;
	bh=0unXby4I7YlDR82IhnuSYWfuZYyfl6mBjZ34EugK+dk=;
	h=Date:To:From:Subject:Message-Id; b=mOFbkASj9eyP0q9F1gfxsw+svesWXrWUcQ/qmkxQBBkIDmhqCEolPvQBS+vdQ0/1/gWJYR6NgQrnIxrcyT5N1il/rWEYE08cQbm0xQ68yCmMNt8fb+D1vvSDYg8r//3QmzKsUAz1TAzB8qPH4cXFHp9JABUZ0MLz/BrkWjsQv1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qa3lCxu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qa3lCxu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57D2C4CEC2;
	Wed,  4 Sep 2024 04:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423429;
	bh=0unXby4I7YlDR82IhnuSYWfuZYyfl6mBjZ34EugK+dk=;
	h=Date:To:From:Subject:From;
	b=qa3lCxu8tMVfVd/5HbUpFeAOCJUsrJfQk6rFM30LN47Tk6hjtrg4L4yOYVRKPRsdg
	 zF0DOb8+kGbDQ5bEhu7p7xRNVscmh8/inGOKzURmW3mqKhVmjVa89x1xIaiQ1xv4j2
	 MbOXCHDFZlmGAZMGmmXfSBD/4tA6EIyAswxBvFu0=
Date: Tue, 03 Sep 2024 21:17:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch removed from -mm tree
Message-Id: <20240904041709.C57D2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/numa: use get_pfn_range_for_nid to verify that node spans memory
has been removed from the -mm tree.  Its filename was
     x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/numa: use get_pfn_range_for_nid to verify that node spans memory
Date: Wed, 7 Aug 2024 09:40:55 +0300

Instead of looping over numa_meminfo array to detect node's start and
end addresses use get_pfn_range_for_init().

This is shorter and make it easier to lift numa_memblks to generic code.

Link: https://lkml.kernel.org/r/20240807064110.1003856-12-rppt@kernel.org
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

 arch/x86/mm/numa.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/numa.c~x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory
+++ a/arch/x86/mm/numa.c
@@ -521,17 +521,14 @@ static int __init numa_register_memblks(
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
-		u64 start = PFN_PHYS(max_pfn);
-		u64 end = 0;
+		unsigned long start_pfn, end_pfn;
 
-		for (i = 0; i < mi->nr_blks; i++) {
-			if (nid != mi->blk[i].nid)
-				continue;
-			start = min(mi->blk[i].start, start);
-			end = max(mi->blk[i].end, end);
-		}
-
-		if (start >= end)
+		/*
+		 * Note, get_pfn_range_for_nid() depends on
+		 * memblock_set_node() having already happened
+		 */
+		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+		if (start_pfn >= end_pfn)
 			continue;
 
 		alloc_node_data(nid);
_

Patches currently in -mm which might be from rppt@kernel.org are


