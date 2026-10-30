Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793321549;
	b=DPgxiAhdbkfaODbTIFuoCrZwR4FdqTmbSpN0OB5UrGB3nqhei1knPHNXNAu/i3zWJ/R8
	 0hqRtJR53qXgU2alHVIVT4b6M2TR+XDg7YsCVT2idC1tlgnKD3SL3aTHDMAsjNt5zK/Kd
	 7XXngchlN6JYSoxGxSvUKU+YIMk94zdOllBxSJ1KRtvhWQtyOPyvcjC9rcTrINOf/agdI
	 wqqyl3tMi7KxclsQB1dzq+U8BrwPAVGBDo4bB1WRdbM397/h57Dir9q2AfoEDE73IwT3Y
	 boN+QlkOOnsxa5Ob9lCSpLreP+vWeBm7MZ3bNQn8iiIfQB6pD2kYdYLPFJVHPdOKjDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793321549;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4WiMWkVhlI+JIrlwzR5vjZvfebUBYubqh2G7WBMtViQ=;
	b=tccyoWtelepQXl+5Lzl8VGbfeGn5ninYwohyAcnHmJlgdIlWFtFGtsgC34bqwJxg2fpD
	 faDCmFrv5Yz6L7mQaaRNpiV1Jagm0wJJ1egt5fAWjL2FBtiE+FR2Q6hIR6Z5atgmHO1Lj
	 Nqnm56v0ZEd2bcL/SslSohk0BURAgmNK0+rrpAmm18OKIQpg8kdwgsa5NwWce/btqnDfp
	 Z91KNN3l4wrCfs1iO9Z3zsQdQDoSAz3ukR2q/T+wga1Xpnrbz4aFsRT9iSmhnpxmdtSoQ
	 1HH/htsDocW4GAehz7hH4vpNHQSASoxRUeqcy+NB1XUNd8ea1ZLeR0FS+WSM+ampXvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2A+vtokA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CB8606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 00:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2A+vtokA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0741F000C1;
	Fri, 30 Oct 2026 00:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793321548;
	bh=4WiMWkVhlI+JIrlwzR5vjZvfebUBYubqh2G7WBMtViQ=;
	h=Date:To:From:Subject;
	b=2A+vtokAIvh07u11nCwTAlXBjzRHovsnd4TIr3EXbgAuonkXDGXGc3MujdUK/OOXo
	 /ZoVZ46+EvIdFnxpYKnVc91KcM3qNi2CMMGwYLI02nH5YOWlOk3CRer2cfKfiIEDs8
	 MA9U3IxddNXOAcCq2FTRY56PwX6egNf8GmFu8+BE=
Date: Thu, 29 Oct 2026 17:52:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sshegde@linux.ibm.com,skhan@linuxfoundation.org,rppt@kernel.org,
	ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,
	osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,
	maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch added to mm-new branch
Message-Id: <20261030005228.3A0741F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/sparse-vmemmap: map shared vmemmap tail pages as read-only
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: map shared vmemmap tail pages as read-only
Date: Mon, 19 Oct 2026 17:08:27 +0800

Patch series "mm: Enforce read-only shared vmemmap tail mappings", v1.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: mapping shared vmemmap tail pages read-only
at population time.

After the previous HugeTLB and device DAX conversions, both can install
optimized shared-tail mappings during vmemmap population. These mappings
should be read-only because each shared tail vmemmap page backs metadata
for many tail pages. HugeTLB applies this protection in a later,
subsystem-specific pass, but device DAX currently lacks it.

This series moves the protection into the generic sparse-vmemmap and
powerpc radix population paths. This protects device DAX mappings and
makes the HugeTLB-specific vmemmap_wrprotect_hvo() pass redundant. With
that pass gone, the bootmem-only optimization wrapper has no distinct
work and is removed as well.

This is intended to be the fifth smaller step toward the broader HVO
generalization. The remaining HVO naming and enablement consolidation is
left for follow-up series.


This patch (of 4):

Both early HugeTLB HVO and device DAX use the common vmemmap population
path for shared tail mappings. Map these pages read-only so that illegal
writes fault instead of corrupting metadata shared by multiple tail
pages.

For early HugeTLB, this moves existing write protection into initial
population without changing the final mapping. Device DAX gains the same
protection.

Link: https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/ [1]
Link: https://lore.kernel.org/20261019090830.1917657-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261019090830.1917657-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 Documentation/mm/vmemmap_dedup.rst |    3 +--
 mm/sparse-vmemmap.c                |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/mm/vmemmap_dedup.rst~mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -204,5 +204,4 @@ There's no remapping of vmemmap given th
 System RAM ranges initialized at boot. Thus the tail page deduplication
 happens at a later stage when we populate the sections.
 
-Deduplicated tail pages are not mapped read-only. The mapping layout is the same
-as HugeTLB.
+The mapping layout is the same as HugeTLB.
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only
+++ a/mm/sparse-vmemmap.c
@@ -295,6 +295,9 @@ static pte_t * __meminit vmemmap_pte_pop
 			return NULL;
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
+		/* Map the shared tail page as read-only to catch illegal writes. */
+		if (vmemmap_optimizable_pfn(pfn))
+			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch

