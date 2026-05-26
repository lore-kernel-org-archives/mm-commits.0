Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3488D4219FE
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779820660; cv=none; b=R9IkNCagjJJSI8tMMRdv2vRrW2brREz7M/J3HQ/JwSC6S8CRh6i+W66UJ/LQtapeIe8XROkdztDBTq8QQTOjcukvGdOfrNHe2FJWZ2WBlRZGV9dMPn2F50i5CIFblHvKr8/NB3ZoR98xrgv8kJ1kB+PRCJMrDWxIC89s8yCumus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779820660; c=relaxed/simple;
	bh=8Q649AwKICe900SEmK6t4EH+llO8Mzl6M81eRP+XDyU=;
	h=Date:To:From:Subject:Message-Id; b=hzQAGgthLmwwJ6cnSkxuX7R1bA83Ml+p8rGEGLwQgX5Fa1LB9ZKSZG526gpyH0kpXF66/JOHjcPackP0lIN5+fg7ic103K7dRa6UnEGVuEMxMkESNbY9DHZECHu7ZaHAYlqiUgEVcIIA8F8Rh9EkgMkW+MQ+bQxxpd0uueP+8wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8rWrgg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8rWrgg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A651F000E9;
	Tue, 26 May 2026 18:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779820658;
	bh=MSvfrCorQRRJwk9yz83eixlNvFRNK87PwmPebS1R5Ks=;
	h=Date:To:From:Subject;
	b=B8rWrgg2l4dIonrltNWfmJVluc13H0V1cqyi/3IKVARf03IRve47d/c29XEeFCCfA
	 mptFBIw4A4FtmezBVZHnX3OstMAWGSSw8ZJHbfUFdJ6PL7vt1ARn+cksDK6KuKvZrJ
	 hVWe7pQ7yk/CsDjfIa0nJHVija2k/RDZx8Z46OM8=
Date: Tue, 26 May 2026 11:37:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch added to mm-unstable branch
Message-Id: <20260526183738.D4A651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
Date: Tue, 26 May 2026 11:28:36 +0000

Vlastimil pointed out that the VM_BUG_ON()s have fallen out of favour, so
remove them.

Link: https://lore.kernel.org/20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/4074a816-9e75-45a6-8141-25459bcc106b@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers
+++ a/mm/page_alloc.c
@@ -653,13 +653,8 @@ static inline unsigned int order_to_pind
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(!is_pmd_order(order));
-
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			return NR_LOWORDER_PCP_LISTS + movable;
-		}
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
@@ -672,8 +667,6 @@ static inline int pindex_to_order(unsign
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return order;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

