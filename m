Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AD6313550
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421712; cv=none; b=E68XjlKOXXFweHqkfkhcOvfanvfxT+CCN85FTn9HEEyhLcoxqiCok8yuHbBvxI37NqGrlZAwXIengOCMMhegNfaXUupASRKY5V62MtXdfGKf3/dcMAlQ+k5jxR5XawdIzYU4EB7VZCMtk88LGjJCAVaiL3wMychemKisZytgbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421712; c=relaxed/simple;
	bh=6P/gT4NIu4E3M6I1avwVcvs2guF+Ftnbcc+D3GkWkng=;
	h=Date:To:From:Subject:Message-Id; b=Yc2KH8+//uk7ztiyXL0p+8D/Z+puKZOz2gckHkmfAMPverEAS1OVnfDJ0pqLwzN982xZwXqhm2x15QENe+3/UBHFXoW6CcA5HcIrOksthXoHZvsCBZT2ud+v14+n2oulVCJ7Uk5mhyIxi57z0vFg1WID4zBQLRWHKPJSZyrtQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbIJw32B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbIJw32B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBC4C116C6;
	Fri,  6 Feb 2026 23:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421711;
	bh=6P/gT4NIu4E3M6I1avwVcvs2guF+Ftnbcc+D3GkWkng=;
	h=Date:To:From:Subject:From;
	b=kbIJw32BALg21CyAuKt4Q2COT74oL1udN5PcwId8pG5vfwABYwYcSqPMFLhwmSFgk
	 QjuC7lv1nUkUbyXw8z0/qL2gdTjLVkAlrv+AB3bIQci9ueQENlACraQTBpmc6BUhkL
	 NluIvI9Z0GkPf3leXH3sxwDOG4FyG9cL7kvZvf4o=
Date: Fri, 06 Feb 2026 15:48:31 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@kernel.org,surenb@google.com,rppt@kernel.org,richard.weiyang@gmail.com,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linmag7@gmail.com,Liam.Howlett@oracle.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,hpa@zytor.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,bp@alien8.de,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch removed from -mm tree
Message-Id: <20260206234831.BEBC4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:13:01 +0800

The PT_RECLAIM can work on all architectures that support
MMU_GATHER_RCU_TABLE_FREE, except for those that have selected
HAVE_ARCH_TLB_REMOVE_TABLE,so make PT_RECLAIM depends on
MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE.

BTW, change PT_RECLAIM to be enabled by default, since nobody should want
to turn it off.

Link: https://lkml.kernel.org/r/83b034810935a9ff18e425b085e065bb0acb28f3.1769515122.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 mm/Kconfig       |    9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/x86/Kconfig~mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free
+++ a/arch/x86/Kconfig
@@ -331,7 +331,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
--- a/mm/Kconfig~mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free
+++ a/mm/Kconfig
@@ -1451,14 +1451,9 @@ config ARCH_HAS_USER_SHADOW_STACK
 config HAVE_ARCH_TLB_REMOVE_TABLE
 	def_bool n
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
-	bool "reclaim empty user page table pages"
-	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
-	select MMU_GATHER_RCU_TABLE_FREE
+	def_bool y
+	depends on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


