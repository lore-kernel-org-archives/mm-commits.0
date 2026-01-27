Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8DE31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486651; cv=none; b=i2QthbLpYcRc/ew05uafYcENY6N/MK9+7rPU6uZfrzIQM5mY/1b1MMvCldavLKsBu+60UuZfu3w8ely3zbUJkQY0CZUrIvsxh8+ftZF642uk8HjU/6GEb3HM6W99Haj3W2zHX9AyIx2wfo2WDmdtt6Nt7Ilt3FxGZd4Bgii2meE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486651; c=relaxed/simple;
	bh=nWrvEEVmzESj/zk3y9B15xMXN85aRztmsLRqyb5ugtU=;
	h=Date:To:From:Subject:Message-Id; b=j+ogDZHsgSxANSZZUqksa1/7cLyIc2QoYRpqJLVLLHuCAQ2WT3UQzrjKgSDD4FTs3Bz1ugUK4RCMO5RfAl3IyyxsJgopjnD+W3M9ya/uA+1bGtzcynaTabi6v/xmnpV1Jzw0bKI/EtauuukryuxTAgt5lhSRL1p50EdbyptUhFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LHdFdsji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LHdFdsji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB6C116C6;
	Tue, 27 Jan 2026 04:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486651;
	bh=nWrvEEVmzESj/zk3y9B15xMXN85aRztmsLRqyb5ugtU=;
	h=Date:To:From:Subject:From;
	b=LHdFdsjiu7s7bkwJl3K2qoziPwv0ceg48ulcnBl+I3rX6kj3EnsCcJbhCWCba6XIQ
	 N2QT2jx3ycO8ppzg00GM1ByJaBm3MSC9Trn8UWT89Qc38v/9girkqRfPpgzIApl9o1
	 l+tUYLK6/vnvt3Jd+t2jcDlWJUSDpzn0y/laxQ+8=
Date: Mon, 26 Jan 2026 20:04:10 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,shorne@gmail.com,ritesh.list@gmail.com,richard@nod.at,pratyush@kernel.org,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,liam.howlett@oracle.com,klarasmodin@gmail.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,alexs@kernel.org,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch removed from -mm tree
Message-Id: <20260127040411.4EDB6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
has been removed from the -mm tree.  Its filename was
     revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
Date: Sun, 11 Jan 2026 10:21:03 +0200

This reverts commit d58b2498200724e4f8c12d71a5953da03c8c8bdf.

hugetlb_bootmem_alloc() is called only once, no need to check if it was
called already at its entry.

Other checks performed during HVO initialization are also no longer
necessary because sparse_init() that calls hugetlb_vmemmap_init_early()
and hugetlb_vmemmap_init_late() is always called after
hugetlb_bootmem_alloc().

Link: https://lkml.kernel.org/r/20260111082105.290734-30-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ------
 mm/hugetlb.c            |   12 ------------
 mm/hugetlb_vmemmap.c    |   11 -----------
 3 files changed, 29 deletions(-)

--- a/include/linux/hugetlb.h~revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/include/linux/hugetlb.h
@@ -176,7 +176,6 @@ extern int sysctl_hugetlb_shm_group __re
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
-bool hugetlb_bootmem_allocated(void);
 extern nodemask_t hugetlb_bootmem_nodes;
 void hugetlb_bootmem_set_nodes(void);
 
@@ -1306,11 +1305,6 @@ static inline bool hugetlbfs_pagecache_p
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
-
-static inline bool hugetlb_bootmem_allocated(void)
-{
-	return false;
-}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -4486,21 +4486,11 @@ void __init hugetlb_bootmem_set_nodes(vo
 	}
 }
 
-static bool __hugetlb_bootmem_allocated __initdata;
-
-bool __init hugetlb_bootmem_allocated(void)
-{
-	return __hugetlb_bootmem_allocated;
-}
-
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
 	int i;
 
-	if (__hugetlb_bootmem_allocated)
-		return;
-
 	hugetlb_bootmem_set_nodes();
 
 	for (i = 0; i < MAX_NUMNODES; i++)
@@ -4514,8 +4504,6 @@ void __init hugetlb_bootmem_alloc(void)
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
-
-	__hugetlb_bootmem_allocated = true;
 }
 
 /*
--- a/mm/hugetlb_vmemmap.c~revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb_vmemmap.c
@@ -794,14 +794,6 @@ void __init hugetlb_vmemmap_init_early(i
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
-	/*
-	 * Noting to do if bootmem pages were not allocated
-	 * early in boot, or if HVO wasn't enabled in the
-	 * first place.
-	 */
-	if (!hugetlb_bootmem_allocated())
-		return;
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
@@ -847,9 +839,6 @@ void __init hugetlb_vmemmap_init_late(in
 	struct hstate *h;
 	void *map;
 
-	if (!hugetlb_bootmem_allocated())
-		return;
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-cleanup-error-handling-in-kho_populate.patch

