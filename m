Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAEB6BFB0
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423421; cv=none; b=J9nWLRrh0TJEYkwBJ9qx2+jrHorQieIpxrimHtHyfy4Qx1s8uzJx/bzOcHdvx4YTxBAEpG4PgMSfhZG3063HII6GnIC7eq933UOML6Gluzlf8PGlpvnlGHioRSvWt1YKUWiX0A0S8WfwTYcj1kbgGAWzn8BG4GcDQ3UpZC1+8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423421; c=relaxed/simple;
	bh=lIhBWnByxj0jEJPFWn9xPvIfdVg7Gm39jQxjjyCaU/A=;
	h=Date:To:From:Subject:Message-Id; b=exG63fQKsMYMw6R7YjAjzh6cyXo7dnF0fVSfSAF5IYqiSatV9LJiwWoxXhlGJg3Z3VJDX3n5P1rvkQtrp5Pq2XJaigvA6UJGkobcN1XBM2z265qbCQ01bU9mBzQn87BckdtB290TGx64ZPdP0i3Jt29bu9Wr4/2RNy8hSWR0Ae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OosHzrHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OosHzrHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B864C4CEC3;
	Wed,  4 Sep 2024 04:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423421;
	bh=lIhBWnByxj0jEJPFWn9xPvIfdVg7Gm39jQxjjyCaU/A=;
	h=Date:To:From:Subject:From;
	b=OosHzrHhcrF7JBp7UBhHnp2NjK2So8o+7pQ1Qz4r8uAseQqEDYxm7Dlg1MVpBEXwV
	 fp40hyzDam7KGiNGD9QaI8HRKr1G/ug+gGr26E5bDQu7jHDvl8rwX3mCBuKyE50tHt
	 smWo4PjYLHG4uyTsb/GbmXDw4FVvM8optu939tQw=
Date: Tue, 03 Sep 2024 21:17:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-loongson64-drop-have_arch_nodedata_extension.patch removed from -mm tree
Message-Id: <20240904041701.9B864C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MIPS: loongson64: drop HAVE_ARCH_NODEDATA_EXTENSION
has been removed from the -mm tree.  Its filename was
     mips-loongson64-drop-have_arch_nodedata_extension.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: loongson64: drop HAVE_ARCH_NODEDATA_EXTENSION
Date: Wed, 7 Aug 2024 09:40:50 +0300

Commit f8f9f21c7848 ("MIPS: Fix build error for loongson64 and sgi-ip27")
added HAVE_ARCH_NODEDATA_EXTENSION to loongson64 to silence a compilation
error that happened because loongson64 didn't define array of pg_data_t as
node_data like most other architectures did.

After rename of __node_data to node_data arch_alloc_nodedata() and
HAVE_ARCH_NODEDATA_EXTENSION can be dropped from loongson64.

Since it was the only user of HAVE_ARCH_NODEDATA_EXTENSION config option
also remove this option from arch/mips/Kconfig.

Link: https://lkml.kernel.org/r/20240807064110.1003856-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig           |    4 ----
 arch/mips/loongson64/numa.c |   10 ----------
 2 files changed, 14 deletions(-)

--- a/arch/mips/Kconfig~mips-loongson64-drop-have_arch_nodedata_extension
+++ a/arch/mips/Kconfig
@@ -502,7 +502,6 @@ config MACH_LOONGSON64
 	select USE_OF
 	select BUILTIN_DTB
 	select PCI_HOST_GENERIC
-	select HAVE_ARCH_NODEDATA_EXTENSION if NUMA
 	help
 	  This enables the support of Loongson-2/3 family of machines.
 
@@ -2612,9 +2611,6 @@ config NUMA
 config SYS_SUPPORTS_NUMA
 	bool
 
-config HAVE_ARCH_NODEDATA_EXTENSION
-	bool
-
 config RELOCATABLE
 	bool "Relocatable kernel"
 	depends on SYS_SUPPORTS_RELOCATABLE
--- a/arch/mips/loongson64/numa.c~mips-loongson64-drop-have_arch_nodedata_extension
+++ a/arch/mips/loongson64/numa.c
@@ -198,13 +198,3 @@ void __init prom_init_numa_memory(void)
 	pr_info("CP0_PageGrain: CP0 5.1 (0x%x)\n", read_c0_pagegrain());
 	prom_meminit();
 }
-
-pg_data_t * __init arch_alloc_nodedata(int nid)
-{
-	return memblock_alloc(sizeof(pg_data_t), SMP_CACHE_BYTES);
-}
-
-void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	node_data[nid] = pgdat;
-}
_

Patches currently in -mm which might be from rppt@kernel.org are


