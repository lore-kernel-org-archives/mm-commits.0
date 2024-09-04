Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5175BA37
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423418; cv=none; b=USelIneCxS2pM4KJZjPK4eOyX1NV9OP5NAlavl+dxetCj7QKjEFDieWjuMOQZVo3dw3SnnCmfil+WO1PHppu6jH/JVO7SMRB75ltPYjjpp3GJHppoGssKEqMPbABZAJL+eepjllfb21p1KOkTikNNfzp3oel7IJUff8CQ9sENRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423418; c=relaxed/simple;
	bh=jP0rCsy9OXnrwbyWaq5GcOgzYZKootUaFXLT9ap1GKU=;
	h=Date:To:From:Subject:Message-Id; b=fcAWF06CJcRxs9g6G1bBkvY4U6mztNOEbvz8+xydceoxsoFH9sLkFf8WNpABwgv0bQjec342HXmVylvhqdZ+QWAH0UWv4VpfLWY11OcKIe6hXrwphnOS3tDa2kknj8Q66GbDfXZ5X3Z0Nv+YbjzXrt83+5JrpSw++uen6uw7N3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nb/6TDu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nb/6TDu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4231DC4CEC3;
	Wed,  4 Sep 2024 04:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423418;
	bh=jP0rCsy9OXnrwbyWaq5GcOgzYZKootUaFXLT9ap1GKU=;
	h=Date:To:From:Subject:From;
	b=Nb/6TDu1QU3OA/mev2Bg2CeLvd8Er6IlwgkSvcEFO6hgD3v3d27/9PNI5Zxk04gbI
	 d0Vozfy9kEt3hD6YJnf9YNk/8U1HJltrR4UefWw1p5OUh7RFm0VIhe2ZUt3FN9/wuR
	 8OXzSksaZyA7ttgzMjCStqlZMpQQY+Io4zvSpAWI=
Date: Tue, 03 Sep 2024 21:16:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-sgi-ip27-drop-have_arch_nodedata_extension.patch removed from -mm tree
Message-Id: <20240904041658.4231DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MIPS: sgi-ip27: drop HAVE_ARCH_NODEDATA_EXTENSION
has been removed from the -mm tree.  Its filename was
     mips-sgi-ip27-drop-have_arch_nodedata_extension.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: sgi-ip27: drop HAVE_ARCH_NODEDATA_EXTENSION
Date: Wed, 7 Aug 2024 09:40:48 +0300

Commit f8f9f21c7848 ("MIPS: Fix build error for loongson64 and sgi-ip27")
added HAVE_ARCH_NODEDATA_EXTENSION to sgi-ip27 to silence a compilation
error that happened because sgi-ip27 didn't define array of pg_data_t as
node_data like most other architectures did.

After addition of node_data array that matches other architectures and
after ensuring that offline nodes do not appear on node_possible_map, it
is safe to drop arch_alloc_nodedata() and HAVE_ARCH_NODEDATA_EXTENSION
from sgi-ip27.

Link: https://lkml.kernel.org/r/20240807064110.1003856-5-rppt@kernel.org
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

 arch/mips/Kconfig                |    1 -
 arch/mips/sgi-ip27/ip27-memory.c |   10 ----------
 2 files changed, 11 deletions(-)

--- a/arch/mips/Kconfig~mips-sgi-ip27-drop-have_arch_nodedata_extension
+++ a/arch/mips/Kconfig
@@ -735,7 +735,6 @@ config SGI_IP27
 	select WAR_R10000_LLSC
 	select MIPS_L1_CACHE_SHIFT_7
 	select NUMA
-	select HAVE_ARCH_NODEDATA_EXTENSION
 	help
 	  This are the SGI Origin 200, Origin 2000 and Onyx 2 Graphics
 	  workstations.  To compile a Linux kernel that runs on these, say Y
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-sgi-ip27-drop-have_arch_nodedata_extension
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -426,13 +426,3 @@ void __init mem_init(void)
 	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
 }
-
-pg_data_t * __init arch_alloc_nodedata(int nid)
-{
-	return memblock_alloc(sizeof(pg_data_t), SMP_CACHE_BYTES);
-}
-
-void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	__node_data[nid] = (struct node_data *)pgdat;
-}
_

Patches currently in -mm which might be from rppt@kernel.org are


