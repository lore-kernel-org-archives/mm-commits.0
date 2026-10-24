Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832365;
	b=m3xjdWc+6h36NRMSAqRjdV0SAqrXEWnA91ClxmttrOeXgykJdClBTpmpie4S4PRTY3gu
	 c2QMhrCgyqe0/mlDI/+ov7J+kIdvx1qs6aYQpxeK9zC6ehR+f8M1yXSRy+HPi0K7kP95P
	 IMhYSCFLcUqGUaz6ZzH7GfDR4xhE7OO5xzrmrTayJEooqfheqwprY6NZoKcdSTkDCmveq
	 uYCovAs2o9Pg8Ln5utM0sKozZa+XYijkQXpvaeJPvCBo/Cg/qhXN0t3ad314JeM4DVje3
	 ll0vZQLoc1NJ66KGa2y5C/91x/wLr/hykHFOvq90/4DK60LYADoA6/SaSBR0wakXZ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832365;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xGZecKGamjeK5AWzZpBA3/EokaVURG4bNhqpfG5n0Do=;
	b=ww9GKiZy32UfXb6Q3KvNbecT1aLX7+HDOqd4fhnuJfHOpU2vIHeUU4EnIqCVXLClDWbn
	 kTsJ7ahUuXy1jgjFmkZR/cW2sHWtDQZQqqioa9dXtUa3U4jnFqUS5TnynH/saG9OglLHs
	 r1wM2M8gJenrSPGMkLug4o1MC9SWq+Cfk3J6xdylEujJXQBWW8k5KE9j2T6XyEGHpH6fd
	 DHqCQGrqp0kvX23k5IHCpCYlLUQd1vEIW20y0EXCaOhAtcY2bTeTabS0eO/dSmc++Ni1R
	 3vHr8J/C5lI4MCJgiq4G/EGxxO/ENysN1uDRprjCEq7yG/Ts559gFwRkTohb/hA+MVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tNqugzrO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6C606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tNqugzrO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B8C1F01825;
	Sat, 24 Oct 2026 08:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832365;
	bh=xGZecKGamjeK5AWzZpBA3/EokaVURG4bNhqpfG5n0Do=;
	h=Date:To:From:Subject;
	b=tNqugzrOVqdDME4EMBJIEiG8xePTTcUhJTCg9Rm3aNRESK3r36VnBn+TiDwD0iUB9
	 d/NyYQqZZYm/jjxrP50lIQt5d+MEjIOk8OBhkLQOKTVgfdHhSV1dCS1XiB9sO184hW
	 wwNo2oHXrlxMAdsxCDk+PZW+LiwuzaJDxIjmimbI=
Date: Sat, 24 Oct 2026 01:59:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,youngjun.park@lge.com,ying.huang@linux.alibaba.com,xu.xin@linux.dev,willy@infradead.org,will@kernel.org,weixugc@google.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,vbabka@kernel.org,usama.arif@linux.dev,tzimmermann@suse.de,tiwai@suse.com,tglx@kernel.org,surenb@google.com,stephen.smalley.work@gmail.com,sre@kernel.org,spasswolf@web.de,simona@ffwll.ch,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pjw@kernel.org,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,perex@perex.cz,paul@paul-moore.com,palmer@dabbelt.com,oupton@kernel.org,osalvador@suse.de,oleg@redhat.com,npiggin@gmail.com,nphamcs@gmail.com,nico.pache@linux.dev,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mkp@kernel.org,mingo@redhat.com,miklos@szeredi.hu,mhocko@suse.com,mhocko@kernel.org,mhiramat@kernel.org,memxor@gmail.com,maz@kernel.org,ma
 tthew.brost@intel.com,mark.rutland@arm.com,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.bottomley@hansenpartnership.com,jack@suse.cz,imbrenda@linux.ibm.com,ihor.solodrai@linux.dev,hca@linux.ibm.com,harry@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,eddyz87@gmail.com,dgilbert@interlog.com,dev.jain@arm.com,dennis.dalessandro@cornelisnetworks.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,daniel@iogearbox.net,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,byungchul@sk.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com
 ,ast@kernel.org,arnd@arndb.de,apopple@nvidia.com,aou@eecs.berkeley.edu,anup@brainfault.org,aneesh.kumar@kernel.org,andrii@kernel.org,andreas@gaisler.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-assert-mmap-lock-held-use-new-flags-api-in-vm_insert_page.patch removed from -mm tree
Message-Id: <20261024085925.14B8C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: assert mmap lock held, use new flags API in vm_insert_page[s]
has been removed from the -mm tree.  Its filename was
     mm-assert-mmap-lock-held-use-new-flags-api-in-vm_insert_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: assert mmap lock held, use new flags API in vm_insert_page[s]
Date: Tue, 13 Oct 2026 16:04:47 +0100

The existing logic asserts that an mmap write lock is held, bizarrely, by
asserting that an mmap_read_trylock() fails (which is not the same thing).

Assert the mmap write lock here and switch to using the new VMA flags API
while here.

Note that the vma_start_write() is explicitly broken out from
vm_flags_set() here in order to use vma_set_flags() safely.

Link: https://lore.kernel.org/20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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
Cc: Zi Yan <ziy@nvidia.com>
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

 mm/memory.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-assert-mmap-lock-held-use-new-flags-api-in-vm_insert_page
+++ a/mm/memory.c
@@ -2599,10 +2599,11 @@ int vm_insert_pages(struct vm_area_struc
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
@@ -2675,10 +2676,11 @@ int vm_insert_page(struct vm_area_struct
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

