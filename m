Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D951A9F9F
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744745; cv=none; b=cZ8D8vNVSiG2RMyTi8UvfQZX8qGGRydvQdGUltlvrK5/iEFkn7NF6g1MG60BHQpBalB6GvJZwIdX6dFZ3qYZihxW7dVZiMazAQxH3x0SOMZ6Kv+E2o5htBlA5qEX1peBN31Vs/FngmOIsg6CGHxq1uph6CEyVOl6O26GVZieWRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744745; c=relaxed/simple;
	bh=Bg+7aYxYj+7y3+pkvpdXOI/Yv7ZvSERP+6lhTu1lIbg=;
	h=Date:To:From:Subject:Message-Id; b=f2eYQe97EzeLnNCfEfotUGY0xZwxo6gag+5o1gTKrgPkRWujRpeTY9rITjUSgn/KDqMYg0ldLKxYyxhnP9r5AVXJ/RyMgKwU+OXLPKS12SVFzrkmbifUqeVLS/I0aDuhOjI5ZWz57k6+QehPJ8bQ3EOhs7oNsXceFBZbSNSgq88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=db3kaZTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="db3kaZTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AA5C4CEF7;
	Sun, 29 Mar 2026 00:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744744;
	bh=Bg+7aYxYj+7y3+pkvpdXOI/Yv7ZvSERP+6lhTu1lIbg=;
	h=Date:To:From:Subject:From;
	b=db3kaZTsdI8q7R8Z9jYhNUHNlwIV+z9cIjoZqQljWEwC/Ug7rDmjga0Q/0zoHT0Rk
	 VyuB5c9Y5zQiJh1Wzcx60SiUWA6gk4ppuWYQsr7NmUAAHvVZTk0Yxd2PdEhTIBI8I6
	 Ap3a7W3slaxhkuIO7z9Vfn8kYic7QtinOeM3ojlE=
Date: Sat, 28 Mar 2026 17:39:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch removed from -mm tree
Message-Id: <20260329003904.B7AA5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: simplify calculation in unmap_mapping_range_tree()
has been removed from the -mm tree.  Its filename was
     mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: simplify calculation in unmap_mapping_range_tree()
Date: Fri, 27 Feb 2026 21:08:35 +0100

Let's simplify the calculation a bit further to make it easier to get,
reusing vma_last_pgoff() which we move from interval_tree.c to mm.h.

Link: https://lkml.kernel.org/r/20260227200848.114019-5-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 mm/interval_tree.c |    5 -----
 mm/memory.c        |   12 +++++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-memory-simplify-calculation-in-unmap_mapping_range_tree
+++ a/include/linux/mm.h
@@ -3969,6 +3969,11 @@ static inline unsigned long vma_pages(co
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff + vma_pages(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
--- a/mm/interval_tree.c~mm-memory-simplify-calculation-in-unmap_mapping_range_tree
+++ a/mm/interval_tree.c
@@ -15,11 +15,6 @@ static inline unsigned long vma_start_pg
 	return v->vm_pgoff;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff + vma_pages(v) - 1;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
--- a/mm/memory.c~mm-memory-simplify-calculation-in-unmap_mapping_range_tree
+++ a/mm/memory.c
@@ -4227,17 +4227,15 @@ static inline void unmap_mapping_range_t
 					    struct zap_details *details)
 {
 	struct vm_area_struct *vma;
-	pgoff_t vba, vea, zba, zea;
 	unsigned long start, size;
 	struct mmu_gather tlb;
 
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
-		vba = vma->vm_pgoff;
-		vea = vba + vma_pages(vma) - 1;
-		zba = max(first_index, vba);
-		zea = min(last_index, vea);
-		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
-		size = (zea - zba + 1) << PAGE_SHIFT;
+		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
+		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;
+
+		start = vma->vm_start + ((start_idx - vma->vm_pgoff) << PAGE_SHIFT);
+		size = (end_idx - start_idx) << PAGE_SHIFT;
 
 		tlb_gather_mmu(&tlb, vma->vm_mm);
 		zap_page_range_single_batched(&tlb, vma, start, size, details);
_

Patches currently in -mm which might be from david@kernel.org are


