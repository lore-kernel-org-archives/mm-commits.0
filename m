Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A793F4DC3
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545933; cv=none; b=ojnUYDHqY9mqCGEBNLom9yjB1owZFJ7vBjdf+YnA68szqzkaN+zRPKXQ0lcdx8ZmZWvh0eOni77Mwh9SuSDSUObxUhrGO38T5cQsxJWfzzcyqXL7GbTCuQqL0pNG0utYH7liqx3kjie+gt8s/0yoSxxg/GmnRJrcNJEqjDUQsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545933; c=relaxed/simple;
	bh=fm0D3ZF4W0geZj/f2+sF5UwjDe7hCfw0ePKOX4BwcUk=;
	h=Date:To:From:Subject:Message-Id; b=oTYE7zN4pMPSGRJF6/+Ygx1/cG71zi1u0smY9Wy2Va47MsBaZVV+nDjL9I8VnUflLZXCqpzJQYMPSk4BBjGp0Tyb49YqSU/7Z/dkTZT5WgGFrKLIG3r0r3o+XCCXGahh2E5pjsL0XUwdNdcJ4zZM63XfV4zuO9erDwERSh5doVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vS/iwDfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vS/iwDfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCEF1F00A3A;
	Wed,  8 Jul 2026 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545931;
	bh=JKfH6Mdb7o+6ixWaaV0m4khC41M208/zD7HeAASwDfs=;
	h=Date:To:From:Subject;
	b=vS/iwDfWvGHTQbS9Gxurr0uWNAaiJyXqHx3UXlZHyYLtoYNkqIAJy3eEigWp55Pgn
	 PtBTk73IaMkwTU8jWinSTeiBTaQrDHTXwnKKpQoXizyZpcToPUW/aW4JMKdflMxxDS
	 JikxKNGUB/lomXD1qr38glPgt5VhfaCIONcxTpBc=
Date: Wed, 08 Jul 2026 14:25:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch added to mm-new branch
Message-Id: <20260708212531.CDCEF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
Date: Wed, 08 Jul 2026 16:10:59 +0200

As preparation for further changes, let's temporarily allow freeing pages
that were not previously registered.

This will allow freeing unregistered vmemmap pages allocated during boot
through free_bootmem_page() from hugetlb code, until we fully rip all of
that out.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-4-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/bootmem_info.h~mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type
+++ a/include/linux/bootmem_info.h
@@ -44,12 +44,12 @@ static inline void free_bootmem_page(str
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
+	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
 		put_page_bootmem(page);
-	else
-		VM_BUG_ON_PAGE(1, page);
+	} else {
+		free_reserved_page(page);
+	}
 }
 #else
 static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch

