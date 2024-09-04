Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2157CBB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423415; cv=none; b=ORjiJ5TPqaf+NM3nuU9oZRMHYomUTjS4XGPHzGUwYbKIC32a1Q7ojaB8ZnLfDzgcsVUHw6RSaaaiA2wK/yafTsqi9gigLkU+uWwCHeZXFenzqp86Rgp38UudWpye1MeXeA3HgGYWH9dvtcVtj9oPMv84S4lzmrWQeWxYsa8ARwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423415; c=relaxed/simple;
	bh=3KifPsaLm4LpwgbkrSWByEuozBa2p5Rf8r5ikLOfM80=;
	h=Date:To:From:Subject:Message-Id; b=kBCVsjF8CLcMSP8KS0m714CgGVc8f7ATpcEvt7ukMcrixrjE30v77CRAg/X5sf/O0MHSSY6RR3mV8nlLOkqPEtT3H0MoXuctJPw3J/2CMVIyTIt64Pzr5RCKBthxKUAwDDOMGv2JfiA0eHhTd75DlaYy/qE79W8acz8tSCFB/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VP6PgFIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VP6PgFIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0364C4CEC2;
	Wed,  4 Sep 2024 04:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423415;
	bh=3KifPsaLm4LpwgbkrSWByEuozBa2p5Rf8r5ikLOfM80=;
	h=Date:To:From:Subject:From;
	b=VP6PgFIQgeRxz29I8oM5mS1mj0fkezhd8Mo0zIn/Jk17t64k2ZktBPa/HCQwph0rU
	 w1fAfGBpttyMqVeeHGCiSM7cdopOs+8/SKR1bwLfVZekceFZJhcwznpRV7H4DzOPsI
	 x4IXP1kxz/CNIPXodoETukWdVYlwD1UjTOsr+w6s=
Date: Tue, 03 Sep 2024 21:16:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch removed from -mm tree
Message-Id: <20240904041654.F0364C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MIPS: sgi-ip27: make NODE_DATA() the same as on all other architectures
has been removed from the -mm tree.  Its filename was
     mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: sgi-ip27: make NODE_DATA() the same as on all other architectures
Date: Wed, 7 Aug 2024 09:40:46 +0300

sgi-ip27 is the only system that defines NODE_DATA() differently than the
rest of NUMA machines.

Add node_data array of struct pglist pointers that will point to
__node_data[node]->pglist and redefine NODE_DATA() to use node_data array.

This will allow pulling declaration of node_data to the generic mm code in
the next commit.

Link: https://lkml.kernel.org/r/20240807064110.1003856-3-rppt@kernel.org
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

 arch/mips/include/asm/mach-ip27/mmzone.h |    5 ++++-
 arch/mips/sgi-ip27/ip27-memory.c         |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/mach-ip27/mmzone.h~mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures
+++ a/arch/mips/include/asm/mach-ip27/mmzone.h
@@ -22,7 +22,10 @@ struct node_data {
 
 extern struct node_data *__node_data[];
 
-#define NODE_DATA(n)		(&__node_data[(n)]->pglist)
 #define hub_data(n)		(&__node_data[(n)]->hub)
 
+extern struct pglist_data *node_data[];
+
+#define NODE_DATA(nid)		(node_data[nid])
+
 #endif /* _ASM_MACH_MMZONE_H */
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -34,8 +34,10 @@
 #define SLOT_PFNSHIFT		(SLOT_SHIFT - PAGE_SHIFT)
 #define PFN_NASIDSHFT		(NASID_SHFT - PAGE_SHIFT)
 
-struct node_data *__node_data[MAX_NUMNODES];
+struct pglist_data *node_data[MAX_NUMNODES];
+EXPORT_SYMBOL(node_data);
 
+struct node_data *__node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(__node_data);
 
 static u64 gen_region_mask(void)
@@ -361,6 +363,7 @@ static void __init node_mem_init(nasid_t
 	 */
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
 	memset(__node_data[node], 0, PAGE_SIZE);
+	node_data[node] = &__node_data[node]->pglist;
 
 	NODE_DATA(node)->node_start_pfn = start_pfn;
 	NODE_DATA(node)->node_spanned_pages = end_pfn - start_pfn;
_

Patches currently in -mm which might be from rppt@kernel.org are


