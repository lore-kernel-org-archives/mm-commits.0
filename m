Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F73C6A21
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774393975; cv=none; b=TpQY7DvOALNjXtt7HB0aj9QtN1QssoTF6hAP8webLEYYEB2DYrZfuUucBTlBZpuHsYE1rTIzrcLTO/31cgDo7QMO9q/dMPQsi3OsGZEsctub8gCkf4MyQ5ECu+RcOPbXoSUOOjpS/S0jadP2Jaw14inDJjiiLCGX3wSSlZhcRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774393975; c=relaxed/simple;
	bh=v4OE18pbS6JJ9HfQhwpNiYdvk89espNS5x2GFuABz4U=;
	h=Date:To:From:Subject:Message-Id; b=I8wmAPUuPkzWIX+cas1KFTV8WfJei/fvTh0QNSc2lbFLJikbNVNFXDjvOuQWyv0tlY5D199gLx9Ki0Na5r3RyDPwxRx/aTEk4Xk1+gT9vip4sANEDNS9EAy/DOBlWLSAd1bswwt9SHyMpUJCDj6JCW6Ui9B9B1xuf+zIpoYgHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aUtijY7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aUtijY7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A44AC19424;
	Tue, 24 Mar 2026 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774393975;
	bh=v4OE18pbS6JJ9HfQhwpNiYdvk89espNS5x2GFuABz4U=;
	h=Date:To:From:Subject:From;
	b=aUtijY7RlzXcNFe4knSP3QZSR91UejaSQiMjRsoL9fer2eI0DVUFYFdrgAndaiZk8
	 Mv/aHBUpc7IPBhWVLKOVIUE5K5fH5d16chnkzDIU6rh4ivEFyFpgXaSC7qeMT01K0S
	 uSrxuCabxfH3/frKv4GOOjz2T1KV26rT854cTHag=
Date: Tue, 24 Mar 2026 16:12:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch removed from -mm tree
Message-Id: <20260324231255.1A44AC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/memory: remove zap_details parameter from zap_page_range_single()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch

This patch was dropped because it was folded into mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: fixup: mm/memory: remove zap_details parameter from zap_page_range_single()
Date: Mon, 2 Mar 2026 09:17:19 +0100

format on a single line

Link: https://lkml.kernel.org/r/8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 rust/kernel/mm/virt.rs |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/rust/kernel/mm/virt.rs~mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix
+++ a/rust/kernel/mm/virt.rs
@@ -123,9 +123,7 @@ impl VmaRef {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size)
-        };
+        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-fix-pmd-pud-checks-in-follow_pfnmap_start.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch
mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch
mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch
mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch
mm-memory_hotplug-simplify-check_pfn_span.patch
mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch
mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch
mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch
mm-sparse-remove-sparse_decode_mem_map.patch
mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch
mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch
mm-sparse-drop-set_section_nid-from-sparse_add_section.patch
mm-sparse-move-sparse_init_one_section-to-internalh.patch
mm-sparse-move-sparse_init_one_section-to-internalh-fix.patch
mm-sparse-move-__section_mark_present-to-internalh.patch
mm-sparse-move-memory-hotplug-bits-to-sparse-vmemmapc.patch
mm-remove-config_arch_enable_memory_hotremove.patch
mm-introduce-config_numa_migration-and-simplify-config_migration.patch

