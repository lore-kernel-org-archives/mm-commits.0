Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0859A237163
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441709; cv=none; b=SktZSgxEfyEO/eXB2yxTarjlAn+YirAZcpKe5UjO1aal6hSx6VlTck3c1CgPwRttDBWMXolO6IPlCKkpY5haJNcHAshuiOQnRy1vVpPDzc4SF7vv9CAIkje6JKBr/QGyHBtGFIpxiginlvM0a+l2FwlG2L8+EgD23em3BaDEiuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441709; c=relaxed/simple;
	bh=MQ2zM8y1a65uDxOrpdQGG1jIjzfenAKcgVrxwlyENHc=;
	h=Date:To:From:Subject:Message-Id; b=WiMSKMeGglxSoOCofIFwDg2/NT48Dv99KBygdlHaehRsBFufCEDpVergqy0+Tk7oIVVafKTZUy9MvyfEx4vVtjb2MgxdpaCoInc/of/9mt2y+307PNpQ52656Aio3SRENnPiNiV6QeFKFDKQI+w8jpFOZpZy6cl8xR2RndYPvT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POZOwoPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POZOwoPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376CC113D0;
	Sat, 29 Nov 2025 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441708;
	bh=MQ2zM8y1a65uDxOrpdQGG1jIjzfenAKcgVrxwlyENHc=;
	h=Date:To:From:Subject:From;
	b=POZOwoPKgUMQ6Da+S/+AuJ1owdqfrSiKSSM76YBAoFsppFPobOj1F/UtBuZRv104N
	 53ZNlYnNem9cmvgdMSKPQZWGPu0pi38thvNeZ64Ms8allVLDfVyRvP4kkTOwtvtgOQ
	 wGQu1qPJVsO/I2XVbhb/sDqypHAn7sONhOU53EWE=
Date: Sat, 29 Nov 2025 10:41:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,riel@surriel.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,ojeda@kernel.org,nphamcs@gmail.com,npache@redhat.com,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,matthew.brost@intel.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,gary@garyguo.net,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,bsegall@google.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch removed from -mm tree
Message-Id: <20251129184148.9376CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: eliminate dependency on vma->__vm_flags
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: eliminate dependency on vma->__vm_flags
Date: Tue, 25 Nov 2025 10:01:01 +0000

The userland VMA test code relied on an internal implementation detail -
the existence of vma->__vm_flags to directly access VMA flags.  There is
no need to do so when we have the vm_flags_*() helper functions available.

This is ugly, but also a subsequent commit will eliminate this field
altogether so this will shortly become broken.

This patch has us utilise the helper functions instead.

Link: https://lkml.kernel.org/r/6275c53a6bb20743edcbe92d3e130183b47d18d0.1764064557.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Alice Ryhl <aliceryhl@google.com>	[rust]
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/vma/vma.c~tools-testing-vma-eliminate-dependency-on-vma-__vm_flags
+++ a/tools/testing/vma/vma.c
@@ -69,18 +69,18 @@ static struct vm_area_struct *alloc_vma(
 					pgoff_t pgoff,
 					vm_flags_t vm_flags)
 {
-	struct vm_area_struct *ret = vm_area_alloc(mm);
+	struct vm_area_struct *vma = vm_area_alloc(mm);
 
-	if (ret == NULL)
+	if (vma == NULL)
 		return NULL;
 
-	ret->vm_start = start;
-	ret->vm_end = end;
-	ret->vm_pgoff = pgoff;
-	ret->__vm_flags = vm_flags;
-	vma_assert_detached(ret);
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	vm_flags_reset(vma, vm_flags);
+	vma_assert_detached(vma);
 
-	return ret;
+	return vma;
 }
 
 /* Helper function to allocate a VMA and link it to the tree. */
@@ -714,7 +714,7 @@ static bool test_vma_merge_special_flags
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_new(&vmg);
 		ASSERT_EQ(vma, NULL);
@@ -736,7 +736,7 @@ static bool test_vma_merge_special_flags
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_existing(&vmg);
 		ASSERT_EQ(vma, NULL);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


