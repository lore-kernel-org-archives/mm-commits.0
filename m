Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF8D282F5
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545406; cv=none; b=AIdxcvWU/A53S0wimnP4vqrvdOya5fJf4UaEBMIksTafN/SeSCXns1+efwZGkS3Z/5AoVg7R/4yf8oi5kMlT9eIvAYzfEh9ieNJY2Khg6SKuJ5siD1H6bsEBpSDfMD70CB8fvm1wKqptZoDCwCgvIeb8FLiWBep3yLnhVzdXy5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545406; c=relaxed/simple;
	bh=JQpXavJTS814EsV+tZPYprokD7dqYndtXDu2onl7L4s=;
	h=Date:To:From:Subject:Message-Id; b=P2TdjP+0XTWwsO6+tkbvl8UDwmP0syErzvDv1HfBSilH0oM54KdLzWNnAI6StHlpwGwCSfoy9LVPdi+BYqVvUcmSB27r3iRXdXTf6KYMa5DfNgKt2mQ9r1E2L985BHVJK1QHS4wm41zMpuZcj/5+iGw+aaYXhMJvpTtQAPFiEdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GqzEc+gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GqzEc+gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A51CC4CEEB;
	Wed, 10 Sep 2025 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757545406;
	bh=JQpXavJTS814EsV+tZPYprokD7dqYndtXDu2onl7L4s=;
	h=Date:To:From:Subject:From;
	b=GqzEc+gV/gpgq/AblrScbGW2fx7ULdCHdlBQwTMyRRXT4LwvuazPhGco6jexu4IRv
	 GfNne+EkFKa2acK+Q7L5F+ym6+iv5ThYTEdFqQLIfQg6gCs/eTPIknlRHYrw1xHUK3
	 qmnTFFoKKNjdEmYCedRfHrvLtFDfJiWVjd9HgFqU=
Date: Wed, 10 Sep 2025 16:03:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-test-in-validate_page_before_insert.patch added to mm-new branch
Message-Id: <20250910230326.3A51CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove redundant test in validate_page_before_insert()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-redundant-test-in-validate_page_before_insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-test-in-validate_page_before_insert.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove redundant test in validate_page_before_insert()
Date: Wed, 10 Sep 2025 15:29:18 +0100

The page_has_type() call would have included slab since commit
46df8e73a4a3 and now we don't even get that far because slab pages have a
zero refcount since commit 9aec2fb0fd5e.

Link: https://lkml.kernel.org/r/20250910142923.2465470-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory.c~mm-remove-redundant-test-in-validate_page_before_insert
+++ a/mm/memory.c
@@ -2268,8 +2268,7 @@ static int validate_page_before_insert(s
 			return -EINVAL;
 		return 0;
 	}
-	if (folio_test_anon(folio) || folio_test_slab(folio) ||
-	    page_has_type(page))
+	if (folio_test_anon(folio) || page_has_type(page))
 		return -EINVAL;
 	flush_dcache_folio(folio);
 	return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch
mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch
mm-constify-compound_order-and-page_size.patch
mm-remove-redundant-test-in-validate_page_before_insert.patch
mm-remove-page-order.patch

