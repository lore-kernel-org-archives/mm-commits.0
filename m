Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832356;
	b=Uf8ErexgWYB2wVcqAQqy/6zYWJaVs8NY3fcFlDNPKWiw+76LstByaeH4tvg5Qr4lFchs
	 4eqqpK/CaSQEWNzdsJ6P4bo3nnn09ppDVvyHiT4sOTAFYJxkuBFlU0L70ccQDH64iMeTq
	 62VMqq9NNfV2Bnm/LzQ+p9+86ACc18g6vuh6nC6lWSJRqoMK89Gcspj+R2+Q52ekdeBIQ
	 VB+uuKP/hQ1bkHevMWwi7AyN1S1euK1lSTJz+SZd+O6CowKSjZTbci9vNUTQRj93piN3U
	 /rRUbOIAnSLyzlb0uAKOxqRw/EuE2TFcOGI+pTUknomRXnRrZscDKRtQBHPiAwj+A1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832356;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RHcWfQVcIg9jdHjOM03cJqKm4vcK7L4qKPTP9EbuPlg=;
	b=KeLABlISomTcinoGls8UWon3WDMx5NqT1y79otH7Xx4O7pEe/IRiM783Wy18IL4CIvAy
	 YfIA2gJO4G47LTYVc6ZG8TtVXglrs+lKSHrPow8We2Fmx61SMvFzRE+Ai7Lcu3Pu2XWdF
	 pa63ZNKGg7WJRmCU4JLcM5WRj5pQxij7tq1TdFmJrPbWZpFrfCXKwI0Ki2S+4mX7SNsR4
	 TXM2DRN5rXHcnsTYMAXz7O4hYg5UlfevyBUFoIG1pUKo0vDrUF5iNe74K9n98Jb/Z/djS
	 4CnXNcuTG92ckQ1W2114LM+L8WPpKYF3skMRkxWJyu8q8YP7zujdbRFRmrO4JYzoYUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uyljA5EP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FC6606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uyljA5EP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4201F01825;
	Sat, 24 Oct 2026 08:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832355;
	bh=RHcWfQVcIg9jdHjOM03cJqKm4vcK7L4qKPTP9EbuPlg=;
	h=Date:To:From:Subject;
	b=uyljA5EPg8JUvCeYcOI2/96Rr6aVwq/NuDu5u2U5OtiAWe4B1wuTDQ6abaB9xpp+u
	 AEjMu82Z2jb3+e74hy/sw006oFz12q7bH2bLb5yWZQr1SuiEhXu5UjnlWe28a5sp4c
	 aqPxSAJC+WGTKFA24SYeEzmIJ7NS01b5p8UGOllA=
Date: Sat, 24 Oct 2026 01:59:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,youngjun.park@lge.com,ying.huang@linux.alibaba.com,xu.xin@linux.dev,willy@infradead.org,will@kernel.org,weixugc@google.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,vbabka@kernel.org,usama.arif@linux.dev,tzimmermann@suse.de,tiwai@suse.com,tglx@kernel.org,surenb@google.com,stephen.smalley.work@gmail.com,sre@kernel.org,spasswolf@web.de,simona@ffwll.ch,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pjw@kernel.org,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,perex@perex.cz,paul@paul-moore.com,palmer@dabbelt.com,oupton@kernel.org,osalvador@suse.de,oleg@redhat.com,npiggin@gmail.com,nphamcs@gmail.com,nico.pache@linux.dev,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mkp@kernel.org,mingo@redhat.com,miklos@szeredi.hu,mhocko@suse.com,mhocko@kernel.org,mhiramat@kernel.org,memxor@gmail.com,maz@kernel.org,ma
 tthew.brost@intel.com,mark.rutland@arm.com,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.bottomley@hansenpartnership.com,jack@suse.cz,imbrenda@linux.ibm.com,ihor.solodrai@linux.dev,hca@linux.ibm.com,harry@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,eddyz87@gmail.com,dgilbert@interlog.com,dev.jain@arm.com,dennis.dalessandro@cornelisnetworks.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,daniel@iogearbox.net,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,byungchul@sk.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com
 ,ast@kernel.org,arnd@arndb.de,apopple@nvidia.com,aou@eecs.berkeley.edu,anup@brainfault.org,aneesh.kumar@kernel.org,andrii@kernel.org,andreas@gaisler.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-introduce-and-use-vma_can_merge.patch removed from -mm tree
Message-Id: <20261024085915.1C4201F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: introduce and use vma_[flags_]can_merge()
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-and-use-vma_can_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: introduce and use vma_[flags_]can_merge()
Date: Tue, 13 Oct 2026 16:04:42 +0100

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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

 include/linux/mm.h              |   21 +++++++++++++++++++++
 mm/vma.c                        |   19 +++++++++++--------
 tools/testing/vma/include/dup.h |    5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-vma-introduce-and-use-vma_can_merge
+++ a/include/linux/mm.h
@@ -1614,6 +1614,27 @@ static inline bool vma_is_shared_maywrit
 }
 
 /**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
+/**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
  *
--- a/mm/vma.c~mm-vma-introduce-and-use-vma_can_merge
+++ a/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struc
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_ran
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
--- a/tools/testing/vma/include/dup.h~mm-vma-introduce-and-use-vma_can_merge
+++ a/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(cons
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

