Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72AE28B415
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995898; cv=none; b=jCwu+5RFClXuWHUWrEC8ndhksvHOJ5OAz8/AdER2sg6HkOG5cAWT/+uHT+gj/nlUIU94y4oAHQuie9icvuibtQl1cTO6T/xQBBy4Q2KQCqOzfU6mG1/BRrYEe3haP/XxY3lCt6XJhmOtXzNwxig+GkbeGQbmaehw8/EooupOAS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995898; c=relaxed/simple;
	bh=vw1gdx88nqmaRrD/wmG/oyrRvIQQa+oOgpUZJsWsrds=;
	h=Date:To:From:Subject:Message-Id; b=e1CSw+McsxbtlZkh+wSxsAyrKaequ7wg/V2rwUzb9r0xRw/VMTfqWL/U/acst39BVfJIQQN96NAtzZA7dEQN+Uo+fAM2+PCqQITwzV8cHpwtzMbQ2AXN693BfAGDe/HEl2rV3i+5ghDHLHC+Qm9J0Q7f1dGuP3gG+OCNiiFXaog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cz+IJth7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cz+IJth7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB16C4CEF5;
	Wed, 17 Dec 2025 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995897;
	bh=vw1gdx88nqmaRrD/wmG/oyrRvIQQa+oOgpUZJsWsrds=;
	h=Date:To:From:Subject:From;
	b=Cz+IJth7PuHrNLeR5XWBt43zRZDbiAJug0b0HcDDzp3Y1CMqhE9cCrhhxZ7iwoiPC
	 3rYMeFFQWHmvo74re+e1+baZJLQb5O3hh0wa8GuBcs9M8nZykWtawr9OEyzBhyW4TG
	 FiUZkT7TH+g3r0+78UtupJz/Pmb8o2Ei4NlTdQqo=
Date: Wed, 17 Dec 2025 10:24:56 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tsbogend@alpha.franken.de,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mattst88@gmail.com,linmag7@gmail.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,chenhuacai@kernel.org,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-mm-enable-mmu_gather_rcu_table_free.patch added to mm-new branch
Message-Id: <20251217182457.1AB16C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: um: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been added to the -mm mm-new branch.  Its filename is
     um-mm-enable-mmu_gather_rcu_table_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-mm-enable-mmu_gather_rcu_table_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:47 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/d8f1206ed75231c66a3269149dbefe68c2dc1ddc.1765963770.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/Kconfig~um-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/um/Kconfig
@@ -42,6 +42,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

