Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A02283FEF
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995884; cv=none; b=QYgtFK2A/vuoWiYQ0g8OJtPTjoklRPDg+R4QEG7MI/zTmqXrMAukxGNf9jCiMZ5jinxvnMIdPVKt6onMQXfdx3oPFoMvaIfa66i1OLmH84SFm6OS+jgAp8UvubqGOrcilQinbSizxV108lmSAGDewJC/qbh5AydyFIKmUfwlnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995884; c=relaxed/simple;
	bh=NRs5+M1Aawr0KMRRjoWXyw0L6Ix59SfQkUXrn/vJrps=;
	h=Date:To:From:Subject:Message-Id; b=O5VQzvjPRA2onVVJOaCFRHioq6SgGQGl1hkQq92Y+MNvrt3EyBktCxvIrt8WDSC8bn3qxtCcTVES2CLhHxXNuQGePBz7hsia1c4CVnwUhc6kaX3waWj7YNudMmftXaw0jw8fwC8K41JxdS7k32uMS3XPrKx06shlXvk78nlGX6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtU4lI7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtU4lI7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38757C4CEFB;
	Wed, 17 Dec 2025 18:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995884;
	bh=NRs5+M1Aawr0KMRRjoWXyw0L6Ix59SfQkUXrn/vJrps=;
	h=Date:To:From:Subject:From;
	b=rtU4lI7i2MLJHlpI0WRMBLtIAzBGLUbU62yhhe+I2caP5WPuC5VgHQ4AL4VXKHJuT
	 RXxfGvcagv9fq3Wbg9+zPJ3uMm40TfzcBOfueRdlup0K/Dwd+RViFkXZWAhqV9t4Xl
	 oY56T4Q5GfLqVJK69fbeNYg1h+kN+2f3ceOlBsjs=
Date: Wed, 17 Dec 2025 10:24:43 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tsbogend@alpha.franken.de,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mattst88@gmail.com,linmag7@gmail.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,chenhuacai@kernel.org,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch added to mm-new branch
Message-Id: <20251217182444.38757C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
has been added to the -mm mm-new branch.  Its filename is
     mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch

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
Subject: mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
Date: Wed, 17 Dec 2025 17:45:42 +0800

Patch series "enable PT_RECLAIM on all 64-bit architectures", v3.

This series aims to enable PT_RECLAIM on all 64-bit architectures.

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem, we
need to enable PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.

Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all
64-bit architectures, and finally makes PT_RECLAIM depend on
MMU_GATHER_RCU_TABLE_FREE.  This way, PT_RECLAIM can be enabled by default
on all 64-bit architectures.

Of course, this will also be enabled on some 32-bit architectures that
already support MMU_GATHER_RCU_TABLE_FREE.  That's fine, PT_RECLAIM works
well on all 32-bit architectures as well.  Although the benefit isn't
significant, there's still memory that can be reclaimed.  Perhaps
PT_RECLAIM can be enabled on all 32-bit architectures in the future.


This patch (of 7):

Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h.  This is a
preparation for enabling CONFIG_PT_RECLAIM on other architectures, such as
alpha.

Link: https://lkml.kernel.org/r/cover.1765963770.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/67a0725081c82cdc2debce6cbdb9273412039553.1765963770.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pt_reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pt_reclaim.c~mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh
+++ a/mm/pt_reclaim.c
@@ -2,7 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/pgalloc.h>
 
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

