Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45864BA37
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423418; cv=none; b=jykQVcJay8lZ96LpBOKgtM7MCSzJY2g6EtoHaUXFUhLGz2FPXpkCCjyQ0Er1Dg4rHwJCthtRxe/FmE/9yLKoKIQ3tVjp/w9u7uygDq5xXEjnz/1FT8ZPZWc/aA01rPCL+CSGcqSdW7HSujo0qz1oBleMNBu1myc456XBCH0y05w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423418; c=relaxed/simple;
	bh=44zCbhOdmpPXR0CnPazYI7JP1i0Y9LmjAb8atzAsfQ8=;
	h=Date:To:From:Subject:Message-Id; b=H5kOlg4WWNZMci9kwKB3+p3x3yTIX+tQ2pyFgLWRQ0bcnhHGD/Xz1kFXnwbUErKU0k+w3Pd/Khkntk+D5m6ogcRgOzKMWXPAitLoSzQ1n5qMK4jW1arvBM8jNO/YdVVat8QZkD50Wd4PueHe3EQrv9IBbrh/Px3scfUlrID4FaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCt3ifvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCt3ifvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1C3C4CEC2;
	Wed,  4 Sep 2024 04:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423416;
	bh=44zCbhOdmpPXR0CnPazYI7JP1i0Y9LmjAb8atzAsfQ8=;
	h=Date:To:From:Subject:From;
	b=WCt3ifvWQNS+LxguFFCCjNVYedfM59TM11EiSA0gUyp9/6sWH56/pnnqeyTmcxR4D
	 DID8MLai9bO76qD/fP0vNlIr2d3zsnk2ci7HIWIELTgaIFwHSXNf2x3SwRj1e8uzBx
	 jR/gsA/nQmtjoTvyu9I4xKUezPj0pp+m3t8aq2rM=
Date: Tue, 03 Sep 2024 21:16:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch removed from -mm tree
Message-Id: <20240904041656.9D1C3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MIPS: sgi-ip27: ensure node_possible_map only contains valid nodes
has been removed from the -mm tree.  Its filename was
     mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: sgi-ip27: ensure node_possible_map only contains valid nodes
Date: Wed, 7 Aug 2024 09:40:47 +0300

For SGI IP27 machines node_possible_map is statically set to NODE_MASK_ALL
and it is not updated during NUMA initialization.

Ensure that it only contains nodes present in the system.

Link: https://lkml.kernel.org/r/20240807064110.1003856-4-rppt@kernel.org
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

 arch/mips/sgi-ip27/ip27-smp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/sgi-ip27/ip27-smp.c~mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes
+++ a/arch/mips/sgi-ip27/ip27-smp.c
@@ -70,11 +70,13 @@ void cpu_node_probe(void)
 	gda_t *gdap = GDA;
 
 	nodes_clear(node_online_map);
+	nodes_clear(node_possible_map);
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		nasid_t nasid = gdap->g_nasidtable[i];
 		if (nasid == INVALID_NASID)
 			break;
 		node_set_online(nasid);
+		node_set(nasid, node_possible_map);
 		highest = node_scan_cpus(nasid, highest);
 	}
 
_

Patches currently in -mm which might be from rppt@kernel.org are


