Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B496F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423446; cv=none; b=Ub3ClqFgaroUjy5lZOcru0G87Y09R7zHyE1NOeHTz6oUeJweAuv1l+PrmrLcKJvQ1h+cORlfdcte3SchGzc5Dxdw1gDHEoHC2svGJpIx8pnnLllBvf3Qahc4wHzjdJtrX1kN2FCBXhTLwm9/85run1+lJTrqlcRaf/SoP07h6sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423446; c=relaxed/simple;
	bh=cB2vbw5ez2HIZKR+cZFlF+eAfhBqc9bXCKMhcAY7rog=;
	h=Date:To:From:Subject:Message-Id; b=p27d4E6+s7cCz6ipWHVjD1z+G1w2roITadG6SeGXgw8lVAZOwnO0w86L8SEKboTiFTbbqsZN3ACc0Q31vI9UVvjXxPhTgzhdCyjkZz++T27eun9pjssnHuFa/nZEKXdrTHyaKNQI/ak/gWQGr6106w1WCbs2zVpXcDfEK47QQ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hiSca4Xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hiSca4Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417BBC4CEC2;
	Wed,  4 Sep 2024 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423446;
	bh=cB2vbw5ez2HIZKR+cZFlF+eAfhBqc9bXCKMhcAY7rog=;
	h=Date:To:From:Subject:From;
	b=hiSca4Xep9LZwVulUlOrkO2mZKSSxI2DBssn4FhlF80y/y1qs2NvA9eprf0LfwK/k
	 4XcvQfFHEcnIxCGb3w/jH5vAxtMNmvQr7sz6OgyhRVbuy7yGFcZFomhlzCfw9MJTdZ
	 8swdvp5DDxjBn4OkH/VjYTfMCrDOwxS94FK4d/Pc=
Date: Tue, 03 Sep 2024 21:17:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-numa_memblks-make-several-functions-and-variables-static.patch removed from -mm tree
Message-Id: <20240904041726.417BBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_memblks: make several functions and variables static
has been removed from the -mm tree.  Its filename was
     mm-numa_memblks-make-several-functions-and-variables-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: numa_memblks: make several functions and variables static
Date: Wed, 7 Aug 2024 09:41:05 +0300

Make functions and variables that are exclusively used by numa_memblks
static.

Move numa_nodemask_from_meminfo() before its callers to avoid forward
declaration.

Link: https://lkml.kernel.org/r/20240807064110.1003856-22-rppt@kernel.org
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

 include/linux/numa_memblks.h |    8 -------
 mm/numa_memblks.c            |   36 ++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 26 deletions(-)

--- a/include/linux/numa_memblks.h~mm-numa_memblks-make-several-functions-and-variables-static
+++ a/include/linux/numa_memblks.h
@@ -7,7 +7,6 @@
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES * 2)
 
-extern int numa_distance_cnt;
 void __init numa_set_distance(int from, int to, int distance);
 void __init numa_reset_distance(void);
 
@@ -22,17 +21,10 @@ struct numa_meminfo {
 	struct numa_memblk	blk[NR_NODE_MEMBLKS];
 };
 
-extern struct numa_meminfo numa_meminfo __initdata_or_meminfo;
-extern struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
-
 int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
-int __init numa_register_meminfo(struct numa_meminfo *mi);
-
-void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-				       const struct numa_meminfo *mi);
 
 int __init numa_memblks_init(int (*init_func)(void),
 			     bool memblock_force_top_down);
--- a/mm/numa_memblks.c~mm-numa_memblks-make-several-functions-and-variables-static
+++ a/mm/numa_memblks.c
@@ -7,13 +7,27 @@
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
 
-int numa_distance_cnt;
+static int numa_distance_cnt;
 static u8 *numa_distance;
 
 nodemask_t numa_nodes_parsed __initdata;
 
-struct numa_meminfo numa_meminfo __initdata_or_meminfo;
-struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
+static struct numa_meminfo numa_meminfo __initdata_or_meminfo;
+static struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
+
+/*
+ * Set nodes, which have memory in @mi, in *@nodemask.
+ */
+static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
+					      const struct numa_meminfo *mi)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
+		if (mi->blk[i].start != mi->blk[i].end &&
+		    mi->blk[i].nid != NUMA_NO_NODE)
+			node_set(mi->blk[i].nid, *nodemask);
+}
 
 /**
  * numa_reset_distance - Reset NUMA distance table
@@ -291,20 +305,6 @@ int __init numa_cleanup_meminfo(struct n
 }
 
 /*
- * Set nodes, which have memory in @mi, in *@nodemask.
- */
-void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-				       const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
-		if (mi->blk[i].start != mi->blk[i].end &&
-		    mi->blk[i].nid != NUMA_NO_NODE)
-			node_set(mi->blk[i].nid, *nodemask);
-}
-
-/*
  * Mark all currently memblock-reserved physical memory (which covers the
  * kernel's own memory ranges) as hot-unswappable.
  */
@@ -371,7 +371,7 @@ static void __init numa_clear_kernel_nod
 	}
 }
 
-int __init numa_register_meminfo(struct numa_meminfo *mi)
+static int __init numa_register_meminfo(struct numa_meminfo *mi)
 {
 	int i;
 
_

Patches currently in -mm which might be from rppt@kernel.org are


