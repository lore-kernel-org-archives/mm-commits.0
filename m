Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1171F37D3
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744754; cv=none; b=JsPEmuw8VWr1vPjSq66VUhwQ+RHRBCR4DtcWNQsNgMLjTnGkbvW0ZAHLuqVV8gb0Ip6C3BaTiCOEBDRO7G7o4deNG9fNlb66of0P690jE9VY9KvId7NXHNEUH+lIwmn7Mi20BDh4VjGuXLLlvJECrpAptrdCi9RJnhf4meFIACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744754; c=relaxed/simple;
	bh=SRlhmeG8MJWHNZHGJK6i2NPrg7JiJnKcIXeL5yEnusM=;
	h=Date:To:From:Subject:Message-Id; b=h+6t3pJkdGSUDQ03JiD47+YpfpX1BOIoD+qDR3cj7Y5186ZpjT4L9Pkm6iyAuxCA1VJkx6zizowBG23Y5Jjw6Tvu494PX+1r0e1YeXpFjG7eTkmF7zp/ZDAf7kB1YSpQoQL7RpH2TbqKPPULtkPKkUWpQUDR4JXBQ8p6kE7A4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m0qMkEuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m0qMkEuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621CFC4CEF7;
	Sun, 29 Mar 2026 00:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744754;
	bh=SRlhmeG8MJWHNZHGJK6i2NPrg7JiJnKcIXeL5yEnusM=;
	h=Date:To:From:Subject:From;
	b=m0qMkEuV6thKCUIGbTgLxCNgAVRLj8RR/SlJvu4yXZrp4lS64ucGGqeHChQm73D/v
	 kWL4fcUKnFQDmsAuGd5+DHALsQUBsuVhhT1pTy+e7YF43QH9sy6WIw9xD5BVF7/tQk
	 eu4MrPuFrSQaDTa1fYJBTsrCLu9XqIuPEeMQ3E4s=
Date: Sat, 28 Mar 2026 17:39:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-details-even_cows-into-details-skip_cows.patch removed from -mm tree
Message-Id: <20260329003914.621CFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: convert details->even_cows into details->skip_cows
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-details-even_cows-into-details-skip_cows.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: convert details->even_cows into details->skip_cows
Date: Fri, 27 Feb 2026 21:08:40 +0100

The current semantics are confusing: simply because someone specifies an
empty zap_detail struct suddenly makes should_zap_cows() behave
differently.  The default should be to also zap CoW'ed anonymous pages.

Really only unmap_mapping_pages() and friends want to skip zapping of
these anon folios.

So let's invert the meaning; turn the confusing "reclaim_pt" check that
overrides other properties in should_zap_cows() into a safety check.

Note that the only caller that sets reclaim_pt=true is
madvise_dontneed_single_vma(), which wants to zap any pages.

Link: https://lkml.kernel.org/r/20260227200848.114019-10-david@kernel.org
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

 include/linux/mm.h |    2 +-
 mm/madvise.c       |    1 -
 mm/memory.c        |   12 ++++++------
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-memory-convert-details-even_cows-into-details-skip_cows
+++ a/include/linux/mm.h
@@ -2767,7 +2767,7 @@ extern void pagefault_out_of_memory(void
  */
 struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
+	bool skip_cows;			/* Do not zap COWed private pages */
 	bool reclaim_pt;		/* Need reclaim page tables? */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
--- a/mm/madvise.c~mm-memory-convert-details-even_cows-into-details-skip_cows
+++ a/mm/madvise.c
@@ -853,7 +853,6 @@ static long madvise_dontneed_single_vma(
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct zap_details details = {
 		.reclaim_pt = true,
-		.even_cows = true,
 	};
 
 	zap_page_range_single_batched(
--- a/mm/memory.c~mm-memory-convert-details-even_cows-into-details-skip_cows
+++ a/mm/memory.c
@@ -1554,11 +1554,13 @@ copy_page_range(struct vm_area_struct *d
 static inline bool should_zap_cows(struct zap_details *details)
 {
 	/* By default, zap all pages */
-	if (!details || details->reclaim_pt)
+	if (!details)
 		return true;
 
+	VM_WARN_ON_ONCE(details->skip_cows && details->reclaim_pt);
+
 	/* Or, we zap COWed pages only if the caller wants to */
-	return details->even_cows;
+	return !details->skip_cows;
 }
 
 /* Decides whether we should zap this folio with the folio pointer specified */
@@ -2149,8 +2151,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 	struct mmu_notifier_range range;
 	struct zap_details details = {
 		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
-		/* Careful - we need to zap private pages too! */
-		.even_cows = true,
 	};
 
 	vma = unmap->first;
@@ -4282,7 +4282,7 @@ void unmap_mapping_folio(struct folio *f
 	first_index = folio->index;
 	last_index = folio_next_index(folio) - 1;
 
-	details.even_cows = false;
+	details.skip_cows = true;
 	details.single_folio = folio;
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
@@ -4312,7 +4312,7 @@ void unmap_mapping_pages(struct address_
 	pgoff_t	first_index = start;
 	pgoff_t	last_index = start + nr - 1;
 
-	details.even_cows = even_cows;
+	details.skip_cows = !even_cows;
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
_

Patches currently in -mm which might be from david@kernel.org are


