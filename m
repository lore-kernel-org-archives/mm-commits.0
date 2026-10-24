Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832421;
	b=FKARecYDXnR28O3QkzhGA/InLWWXwB5GE/s97wYq+R5aABrVyTeDO9Adtv9Xo4NxpIal
	 4oGqfg5mcr2awcFmkFyUUlsN69Y1p9J6sj9/iF0GP8oO/X1zSa1CQ55RY8usFknWHqRBd
	 SX3jPQGyt+2eUm7VZcd/xVgpg9bSinX91u0o+uFIEv9q+d/MnAuoVn8GbF91wC27JKHhb
	 LvetNlwSwW2JaQYishn4/KtMG4zndovHVQ3PcW31JR+7jUcCJMeYr9jtl0Hgsd7j2TJ6+
	 99ZgEcsyGdOnrnWypyHvG6VPhVJxmT3ng1WrgxE3gbHrLkr9FTvNnQOh2KqNOeiYbvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832421;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cpbFq3b9jku/qAWJol/AMksSIe3p6E4/TfUvs6M/r0k=;
	b=OwZe4XLiJVO6ovAjQYUgi2MlVPDZQ1u4TP3WgQo4NQBqgTXy8IdE2LV4oBMmkGrM7R4L
	 Jszos6u7iSnv9iqkbY6TlLhqsPhwg8o3EGg62nYNJop3kR2wsSBOdUw9iNNiAoZn4mkZ/
	 xmLvsxXk0m7+hhXCVodbs0nhQjWnCSpqA8tTCal0R5znD7zAIMb/P75F/uGbmg+iJ+9s6
	 oKK0mig9AKTAOmd42yXNqPZv/thlEuW5VeIcokWxCQluq6mn+oNdJEsbdTGaKoYqi+/U4
	 w1xwHN2HFzhotFTtVR0/6bDt3Kwc/hv6+tWmIy0fCkhcy03XdqSI7ogsZjE+oKAiCcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FwaxG6tj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C51606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FwaxG6tj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8078C1F01825;
	Sat, 24 Oct 2026 09:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832420;
	bh=cpbFq3b9jku/qAWJol/AMksSIe3p6E4/TfUvs6M/r0k=;
	h=Date:To:From:Subject;
	b=FwaxG6tj/q5YrcPeACipzMigWXuIyYuiXS4FsXh7DRMcst6M/UnZW1JbJFr9O0voO
	 07sTnWj9VdVfQm4YLzBZeQv/269+RE52V2Dm2fdyCIMGBRm2HTtaLRDJV6luKPEFfR
	 kltzVnXAhufGfU8e0sGEoqSn7rXvh3tOwjJFPoSQ=
Date: Sat, 24 Oct 2026 02:00:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,youngjun.park@lge.com,ying.huang@linux.alibaba.com,xu.xin@linux.dev,willy@infradead.org,will@kernel.org,weixugc@google.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,vbabka@kernel.org,usama.arif@linux.dev,tzimmermann@suse.de,tiwai@suse.com,tglx@kernel.org,surenb@google.com,stephen.smalley.work@gmail.com,sre@kernel.org,spasswolf@web.de,simona@ffwll.ch,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pjw@kernel.org,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,perex@perex.cz,paul@paul-moore.com,palmer@dabbelt.com,oupton@kernel.org,osalvador@suse.de,oleg@redhat.com,npiggin@gmail.com,nphamcs@gmail.com,nico.pache@linux.dev,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mkp@kernel.org,mingo@redhat.com,miklos@szeredi.hu,mhocko@suse.com,mhocko@kernel.org,mhiramat@kernel.org,memxor@gmail.com,maz@kernel.org,ma
 tthew.brost@intel.com,mark.rutland@arm.com,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.bottomley@hansenpartnership.com,jack@suse.cz,imbrenda@linux.ibm.com,ihor.solodrai@linux.dev,hca@linux.ibm.com,harry@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,eddyz87@gmail.com,dgilbert@interlog.com,dev.jain@arm.com,dennis.dalessandro@cornelisnetworks.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,daniel@iogearbox.net,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,byungchul@sk.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com
 ,ast@kernel.org,arnd@arndb.de,apopple@nvidia.com,aou@eecs.berkeley.edu,anup@brainfault.org,aneesh.kumar@kernel.org,andrii@kernel.org,andreas@gaisler.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-predicates-for-madvise-madv_dofork.patch removed from -mm tree
Message-Id: <20261024090020.8078C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/madvise: use predicates for madvise(..., MADV_DOFORK)
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-predicates-for-madvise-madv_dofork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: use predicates for madvise(..., MADV_DOFORK)
Date: Tue, 13 Oct 2026 16:05:13 +0100

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
and VMA_IO_BIT.

Now the invariant is established that mm-managed mappings may not set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a fixed or non-mm-managed mapping,
i.e. a mapping which is not mm-backed, or hugetlb, which is specifically
excluded.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing using the predicates - only mm-backed mappings may
have their copy-on-fork behaviour changed, retaining the eternal exception
to all rules, hugetlb.

No functional change intended.

Link: https://lore.kernel.org/20261013-b4-mmap-prepare-vma-flag-sanify-v6-33-1aa3c9b139f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
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
Cc: Gregory Price <gourry@gourry.net>
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

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-predicates-for-madvise-madv_dofork
+++ a/mm/madvise.c
@@ -1402,7 +1402,7 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

