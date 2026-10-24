Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832364;
	b=CuibCbHh1F6aYHt0PgjQA/m0uX9vnv1Hel46sHurqqIi1jYvVbWTxvHw2ez5FX75bOht
	 28qZRJZoUHeX6g06za/nW7dCJctmudGnIAxcBAybCDsC8d2ZY/FgZHfCZVR9ggYfHVUa2
	 ndJNb1T9uyGF8oMJNhPMLL9Djix8lY8A3oZ6ugkK+24+7jlnDCHD9aNi6D9A5mP/bCIK8
	 hGtmr/tr5V0bohSiW87MZ2DgViIQKHU3EDcvpap/TihXRV9bZA8H8bEctFDFESXQ+4xrs
	 8e4o/9PUsyHPAtjfqNN7K4+e8EYXP30OkcQb0wbMO2/c+K++pqLN988AO8qSsD55jTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832364;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wGyF/4Ukd/Gnqejc4Tf6f+g9X5l7SE/TGFyoJMahrts=;
	b=sZypa/fz2qWE+/xseIP6+K4vxzwBAqs7nAxkqh6NYRVI9AG2SDGpBHNAn9zaUsOL1n1E
	 KuUruUTmpHPWut2ZqI8ALJ/37ijdUjdJit9fnXLAo6ochhX/ivDtSk2eXWv8dBgyyuPSD
	 VHMueIw3AwldzlrfaaIBQchd+/QKrqdyR7YoOHOyICgRYpzha8T22ECXYLlyDCLL27lBf
	 bnimttT3tmDp7zBAgJflSuX9L2WFPHq/NvTy0MafRVds+06FGotA1DrTJGkk/zUESN/mU
	 YjNMHHdwdVn76u2eglTacXAdc4PLyB9zKaNoXdX2VN8lrXpaIH7efeA2lE/kAE7Ho4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QkWpgPDX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ABE606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QkWpgPDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B1A1F01825;
	Sat, 24 Oct 2026 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832363;
	bh=wGyF/4Ukd/Gnqejc4Tf6f+g9X5l7SE/TGFyoJMahrts=;
	h=Date:To:From:Subject;
	b=QkWpgPDX9SrL59qvtIGpeVx6VB0cnOda7oLDu+FZIOKGorsvzhuL3JlnHyPwj0a5j
	 aX3TotpRK5yDdDqQSVBRBOaDlkrlcOGEnf4Q7KFtTxTQMghLFzZETXG7CVYkrmwaDQ
	 kpPA/vZJOpmUvedMCKPj9VoA9SDNgb/l0YKuzoU0=
Date: Sat, 24 Oct 2026 01:59:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,youngjun.park@lge.com,ying.huang@linux.alibaba.com,xu.xin@linux.dev,willy@infradead.org,will@kernel.org,weixugc@google.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,vbabka@kernel.org,usama.arif@linux.dev,tzimmermann@suse.de,tiwai@suse.com,tglx@kernel.org,surenb@google.com,stephen.smalley.work@gmail.com,sre@kernel.org,spasswolf@web.de,simona@ffwll.ch,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pjw@kernel.org,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,perex@perex.cz,paul@paul-moore.com,palmer@dabbelt.com,oupton@kernel.org,osalvador@suse.de,oleg@redhat.com,npiggin@gmail.com,nphamcs@gmail.com,nico.pache@linux.dev,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mkp@kernel.org,mingo@redhat.com,miklos@szeredi.hu,mhocko@suse.com,mhocko@kernel.org,mhiramat@kernel.org,memxor@gmail.com,maz@kernel.org,ma
 tthew.brost@intel.com,mark.rutland@arm.com,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.bottomley@hansenpartnership.com,jack@suse.cz,imbrenda@linux.ibm.com,ihor.solodrai@linux.dev,hca@linux.ibm.com,harry@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,eddyz87@gmail.com,dgilbert@interlog.com,dev.jain@arm.com,dennis.dalessandro@cornelisnetworks.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,daniel@iogearbox.net,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,byungchul@sk.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com
 ,ast@kernel.org,arnd@arndb.de,apopple@nvidia.com,aou@eecs.berkeley.edu,anup@brainfault.org,aneesh.kumar@kernel.org,andrii@kernel.org,andreas@gaisler.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-tidy-up-map-kernel-pages-enum-values.patch removed from -mm tree
Message-Id: <20261024085923.60B1A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: tidy up map kernel pages enum values
has been removed from the -mm tree.  Its filename was
     mm-vma-tidy-up-map-kernel-pages-enum-values.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: tidy up map kernel pages enum values
Date: Tue, 13 Oct 2026 16:04:46 +0100

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Link: https://lore.kernel.org/20261013-b4-mmap-prepare-vma-flag-sanify-v6-6-1aa3c9b139f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Bert Karwatzki <spasswolf@web.de>
---

 include/linux/mm.h              |    2 +-
 include/linux/mm_types.h        |    8 ++++----
 mm/util.c                       |    8 ++++----
 tools/testing/vma/include/dup.h |    8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-vma-tidy-up-map-kernel-pages-enum-values
+++ a/include/linux/mm.h
@@ -4630,7 +4630,7 @@ static inline void mmap_action_map_kerne
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
--- a/include/linux/mm_types.h~mm-vma-tidy-up-map-kernel-pages-enum-values
+++ a/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
--- a/mm/util.c~mm-vma-tidy-up-map-kernel-pages-enum-values
+++ a/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_d
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_d
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
--- a/tools/testing/vma/include/dup.h~mm-vma-tidy-up-map-kernel-pages-enum-values
+++ a/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_em
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

