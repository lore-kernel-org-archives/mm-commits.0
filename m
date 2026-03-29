Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44975288D0
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744743; cv=none; b=ebJPrDNQD5mjMC0njUmpUlQxptnxLwTA9oR0AOpD08nHK8pNys8c8GJDBskCfihFUpPGxvHvY4I9PuVfFi1YH48sy5CZ5Yr0MG1BNXsSi85Rz3n6jr1iwTIfjUqLV1HzAOXPtlcgf2WI+1vJ4ZNWHja7d3U3BmR7Lj0q0VYM4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744743; c=relaxed/simple;
	bh=s0L4wBftaY0swwzzSj4L75E8Dn2HFMJ4tZghb4/lT3o=;
	h=Date:To:From:Subject:Message-Id; b=WGBvWbdJ9scjpPoDhCGYlEOIBJB6ddSEd+1seKJzGWMjNTk0+tSUcwi9QKSPVEfVtdyb+Ffc2HM5oFBjusg5xn3H/5IOCdEjD5KsfLyMwWdRc7zZou1VhZ2v6JLJtWGFzZ1ZxgT48453GW3Um+t5xU+7B0qiMKCts5ahuYHZH6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=So9ZLY5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="So9ZLY5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA80AC4CEF7;
	Sun, 29 Mar 2026 00:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744742;
	bh=s0L4wBftaY0swwzzSj4L75E8Dn2HFMJ4tZghb4/lT3o=;
	h=Date:To:From:Subject:From;
	b=So9ZLY5W/+xEESXHWBk/nsTdXyir4Ij+SUy28OgCxfueEPg3zwftveLwNSk/gLtwz
	 mnHTZQ4HDChnt1WruoMXTeyFt/WUQGDGb+QDXnDaOwB5hWz51HgIBw+IPmEXOoESwB
	 GkhBJ7dhvdI5MVTng0oyb/fP7OOgb8KSA/EQN/Ag=
Date: Sat, 28 Mar 2026 17:39:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch removed from -mm tree
Message-Id: <20260329003902.BA80AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: inline unmap_mapping_range_vma() into unmap_mapping_range_tree()
has been removed from the -mm tree.  Its filename was
     mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: inline unmap_mapping_range_vma() into unmap_mapping_range_tree()
Date: Fri, 27 Feb 2026 21:08:34 +0100

Let's remove the number of unmap-related functions that cause confusion by
inlining unmap_mapping_range_vma() into its single caller.  The end result
looks pretty readable.

Link: https://lkml.kernel.org/r/20260227200848.114019-4-david@kernel.org
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

 mm/memory.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/mm/memory.c~mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree
+++ a/mm/memory.c
@@ -4221,18 +4221,6 @@ static vm_fault_t do_wp_page(struct vm_f
 	return wp_page_copy(vmf);
 }
 
-static void unmap_mapping_range_vma(struct vm_area_struct *vma,
-		unsigned long start_addr, unsigned long end_addr,
-		struct zap_details *details)
-{
-	struct mmu_gather tlb;
-
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, start_addr,
-				      end_addr - start_addr, details);
-	tlb_finish_mmu(&tlb);
-}
-
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 					    pgoff_t first_index,
 					    pgoff_t last_index,
@@ -4240,17 +4228,20 @@ static inline void unmap_mapping_range_t
 {
 	struct vm_area_struct *vma;
 	pgoff_t vba, vea, zba, zea;
+	unsigned long start, size;
+	struct mmu_gather tlb;
 
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
 		vba = vma->vm_pgoff;
 		vea = vba + vma_pages(vma) - 1;
 		zba = max(first_index, vba);
 		zea = min(last_index, vea);
+		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
+		size = (zea - zba + 1) << PAGE_SHIFT;
 
-		unmap_mapping_range_vma(vma,
-			((zba - vba) << PAGE_SHIFT) + vma->vm_start,
-			((zea - vba + 1) << PAGE_SHIFT) + vma->vm_start,
-				details);
+		tlb_gather_mmu(&tlb, vma->vm_mm);
+		zap_page_range_single_batched(&tlb, vma, start, size, details);
+		tlb_finish_mmu(&tlb);
 	}
 }
 
_

Patches currently in -mm which might be from david@kernel.org are


