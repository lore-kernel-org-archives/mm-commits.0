Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255186E61B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423450; cv=none; b=cPYy0lQdcgztWRL1EIq8ju7z02pJhbNrnpHvHwaBpLcoN+FRRkye+I9hVFElQPUN+xv0fkaeBP70VxNku/EhKOYYsQBGC6BgA/zFZe6xP3J39+GjH3JjZ4tpcSoBPBDshJOUC5nb163igRWAJXBplIM8p1EDzDPVn1kwotrFlPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423450; c=relaxed/simple;
	bh=8BwCNUY5KghFDoc/CGUDpMinT5sOG3CeP3cuRjEUpSA=;
	h=Date:To:From:Subject:Message-Id; b=aZDlCpUCUuRNoq2fehwQsxDQhoXNRmcYKrXWAutqILqHt0grFBAWw0AAMePuWwrusecPvqJYl+daYzikpmf5Ex/HruZxdClpca0oKEwmYrdHaa+Q887uI+eok0ubjFig9YectN0nwxxd+rb3aRLoPxtvFB8gOzMPJ9rpst6amuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pz34FOKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pz34FOKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EF3C4CEC2;
	Wed,  4 Sep 2024 04:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423449;
	bh=8BwCNUY5KghFDoc/CGUDpMinT5sOG3CeP3cuRjEUpSA=;
	h=Date:To:From:Subject:From;
	b=pz34FOKLXJz3rgzVduVneYLVgHwUjPcE6CuIi56BhmZulRLN3hnJN+Pillx3Y8DdE
	 pWkeV5J8/tNTJAlpbGHMNb2iu8I4FePIjoSrEhQnw9k7+ati9gOlqIBnFjE74kGCAR
	 DN+1KqvU30WOQ13E4ru27nRENTwsxgwjhNrXZ6OY=
Date: Tue, 03 Sep 2024 21:17:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] of-numa-return-einval-when-no-numa-node-id-is-found.patch removed from -mm tree
Message-Id: <20240904041729.89EF3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: of, numa: return -EINVAL when no numa-node-id is found
has been removed from the -mm tree.  Its filename was
     of-numa-return-einval-when-no-numa-node-id-is-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: of, numa: return -EINVAL when no numa-node-id is found
Date: Wed, 7 Aug 2024 09:41:07 +0300

Currently of_numa_parse_memory_nodes() returns 0 if no "memory" node in
device tree contains "numa-node-id" property.  This makes of_numa_init()
to return "success" despite no NUMA nodes were actually parsed and set up.

arch_numa workarounds this by returning an error if numa_nodes_parsed is
empty.

numa_memblks however would WARN() in such case and since it will be used
by arch_numa shortly, such warning is not desirable.

Make sure of_numa_init() returns -EINVAL when no NUMA node information was
found in the device tree.

Link: https://lkml.kernel.org/r/20240807064110.1003856-24-rppt@kernel.org
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

 drivers/of/of_numa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_numa.c~of-numa-return-einval-when-no-numa-node-id-is-found
+++ a/drivers/of/of_numa.c
@@ -45,7 +45,7 @@ static int __init of_numa_parse_memory_n
 	struct device_node *np = NULL;
 	struct resource rsrc;
 	u32 nid;
-	int i, r;
+	int i, r = -EINVAL;
 
 	for_each_node_by_type(np, "memory") {
 		r = of_property_read_u32(np, "numa-node-id", &nid);
@@ -72,7 +72,7 @@ static int __init of_numa_parse_memory_n
 		}
 	}
 
-	return 0;
+	return r;
 }
 
 static int __init of_numa_parse_distance_map_v1(struct device_node *map)
_

Patches currently in -mm which might be from rppt@kernel.org are


