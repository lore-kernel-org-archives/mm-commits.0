Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832524;
	b=kJ/Btm0YpPivWJsEQw3/qhGKTWvTzQKHswbwUCEYZhGrSigP9vU90f9002Jlj/9Y+V60
	 LkIK51kY9GkaEJGra6buDTGSdCNKjpraagOQqzvgF4gmVIOxNzeM4cVtVmMoHdVl4u2zg
	 8Tk2AexdcKe5kwRIlNe5qYGZcNblLQhsP+j1XmOt5XtIBa3AbvlcHC2ykDJpgA0tZ5RVG
	 d7sKUErQqKjFzrZsiRoWMAIFgEcShcz4EdJritwMKpRIa2a61wKBDOKnewgrDSpbA+Lnn
	 lknViPCXebb0d+OLPUbp4EPQy78zv8syzxetZY58vi3i4E0QfzTI7KdUhqDzS4sZqzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832524;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SFvAXxcSF1Q85gFAmHMLpIMTLkpfJVjn6yHq4hs+cms=;
	b=D9v1/Ncj3YTgKUx4e0BcgRJ+qq3KLpgK2qVhG9g6EozYJ+GZF2yXBd36JT1Shkg6KZeM
	 I1K9zWDbvrqNVlwO1RBg1KN77vnyzkhnTBzy98I9nCZ998QCjuK2KietcYehf5eXtIO+9
	 nx6cxVdfMPINllReU+Sz2T8gnWPKU6nal6EwHfrZZ+vtGSr0BuUBbdI7EDXAahikuMvMS
	 wW+ABac4nB2r65X1mzY/GEvif99BW3j8thZcodYfixdyf642Rv6pE9dVOEb/pjqlGW2X1
	 irrh6TclIS27QhBqWsvoibPt7g/PZFlbXOa6F9LO8J5p0Fb0LsBojcZvDGHbiM1BG4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=URI5CbAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A73606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=URI5CbAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEACB1F01825;
	Sat, 24 Oct 2026 09:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832523;
	bh=SFvAXxcSF1Q85gFAmHMLpIMTLkpfJVjn6yHq4hs+cms=;
	h=Date:To:From:Subject;
	b=URI5CbAlkEHkdYEgHoq8YPfFNfSZ40q23JHxoXpeaxPnCN/rSqUarUibAPnSiPWB3
	 rKjOZf7ofz456CrqGheIWGa1rWq708DkJVWnZcNHsGRXZV4LBIZBGJ+q3eCdwFX5Fk
	 /AcmudLL2IerIplJ8Z/SuJkAn/fODt9gsvz5myKk=
Date: Sat, 24 Oct 2026 02:02:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-add-zone-mismatch-warning-during-page-init.patch removed from -mm tree
Message-Id: <20261024090203.AEACB1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mm_init: add zone mismatch warning during page init
has been removed from the -mm tree.  Its filename was
     mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 15:57:55 +0800

For vmemmap-optimized sections, tail struct pages may be backed by shared
vmemmap pages.  Those shared pages must carry the same page zone ID as the
struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

[muchun.song@linux.dev: document ordering of shared and retained struct page initialization]
  Link: https://lore.kernel.org/20261010115523.4005071-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261010075755.83339-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 mm/mm_init.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init
+++ a/mm/mm_init.c
@@ -593,6 +593,15 @@ out:
 	node_states[N_MEMORY] = saved_node_state;
 }
 
+static inline void vmemmap_optimization_verify_zone(struct page *page)
+{
+	const unsigned int order = pfn_to_section_compound_order(page_to_pfn(page));
+
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(order) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
+}
+
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
@@ -609,6 +618,11 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	/*
+	 * Shared tail struct pages are initialized during vmemmap population,
+	 * before retained struct pages reach here.
+	 */
+	vmemmap_optimization_verify_zone(page);
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

