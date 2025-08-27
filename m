Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B1A30F94E
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 23:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756337287; cv=none; b=luT1u9bZy64oGjecT731I7sTaeXmCTqlo1RIROf/d1dIsd8cwMmAN8jMAgoRCZNrdDHJwnPgX1YtAihmNL7WEPks4u/fqGXrkV8tvifxeH5GrgqGMHpMJWBdQ7dpUkTMEV4cWIlCQuTPS23ajHYqaTk2LaFVwUSG6ctzUIS17l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756337287; c=relaxed/simple;
	bh=RuEnuSL7Iz1NO7vmvIZe/X2ndSqwmsL/h5pcB7Hwcu8=;
	h=Date:To:From:Subject:Message-Id; b=H6Af5ASrIfg9XI7RNw+origoRuiAd5L8cYIlfnWMrAqXmwB6JqaZltdYeY5AzuBvKdfuX2TdNZPksTuh2IXGBaT6XSpAJP453aHk9kxug5IeuSCzfNtoFmLVoMIf/RJ0poIvr9tjJTzUP17svrTFoPWcqkQvZidnApa5hHgi6EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lryWcYOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lryWcYOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B207C4CEEB;
	Wed, 27 Aug 2025 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756337286;
	bh=RuEnuSL7Iz1NO7vmvIZe/X2ndSqwmsL/h5pcB7Hwcu8=;
	h=Date:To:From:Subject:From;
	b=lryWcYOGsr1KwVDY0fIQ89ez4Pxvz4uDTpxrSMbUfvHPsHntiwmIzIpq+DKxumupi
	 g/QzTS8X2Q4Easx4cdHFAQDKnUwJztVpWudstzR6lkE4K6oQVe29BSDHzvkzfuW4uM
	 Lq2xoNbNbcy4QlWK6adkFgBvhCkOsssWXy5Fby7w=
Date: Wed, 27 Aug 2025 16:28:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,lorenzo.stoakes@oracle.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch added to mm-new branch
Message-Id: <20250827232806.4B207C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: use xxx_pageblock_isolate() for better reading
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: use xxx_pageblock_isolate() for better reading
Date: Wed, 27 Aug 2025 07:01:04 +0000

Patch series "mm/pageblock: improve readability of some pageblock
handling", v3.

During code reading, found two possible points to improve the readability
of pageblock handling.

Patch 1: isolate bit is standalone and there are dedicated helpers. 
Instead of check the bit directly, we could use the helper to do it.

Patch 2: remove PB_migratetype_bits and PB_migrate_end to reduce magical
computation.


This patch (of 2):

Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
standalone bit"), it provides dedicated helper to handle isolation.

Change to use these helpers to be better reading.

No functional change intended.

Link: https://lkml.kernel.org/r/20250827070105.16864-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250827070105.16864-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading
+++ a/mm/page_alloc.c
@@ -538,8 +538,7 @@ static void set_pageblock_migratetype(st
 			"Use set_pageblock_isolate() for pageblock isolation");
 		return;
 	}
-	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
-				      PB_migrate_isolate),
+	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
 	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
@@ -2058,9 +2057,9 @@ static unsigned long find_large_buddy(un
 static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
 {
 	if (isolate)
-		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		set_pageblock_isolate(page);
 	else
-		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		clear_pageblock_isolate(page);
 }
 
 /**
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch

