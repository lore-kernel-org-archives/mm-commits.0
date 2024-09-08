Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B94B1B813;
	Sun,  8 Sep 2024 03:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725765523; cv=none; b=YebrlXxIGbIpwiXBINScDMlF+/8TZ606+TZiZWA8SJ9HjBGkSxJBnasjkITTC4pjZ3G93Z9dfkBWppkJLSOQCO20qwvOlXlMH7lPDXXIZjBxfdc19TheIDYLY6tAE6p2MdU65l4XvpPpiowW7VvmiBH6v/nS4HmSaC6bxEiVLT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725765523; c=relaxed/simple;
	bh=XtxiRcY0YMjvE90yCmNFDO60u926YgmNRJCegwvHAKg=;
	h=Date:To:From:Subject:Message-Id; b=T1rA5QZDByWVRdnXiy++ou8dLxM888KbPthcUFtU55DKL49cvc/z1s8cYiRN4SxM5R1RljYSLB4SZE3vMxhAGPnzVCwqrpvK/N/PKSxqcH5SlzuZ0E8LPDaCTtXYVdVc82HiyEI09Q80K7Xwtk9yN+3VOPMUrm+gg/Reb2aB6MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vp6IPwtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vp6IPwtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFB3C4CEC4;
	Sun,  8 Sep 2024 03:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725765522;
	bh=XtxiRcY0YMjvE90yCmNFDO60u926YgmNRJCegwvHAKg=;
	h=Date:To:From:Subject:From;
	b=Vp6IPwtV+M72DKzibo6UrFxQSKKdtMAyVrqwGeeIP1n9Z5j5gvhmJuYQZTJX0c18i
	 kcumJXBYickUnMPMwdDcH6hn68nFn5LwhideshN4fVxAguBH1FeNeB19j51FlVS3hX
	 lBfG2wYXVZE7eAfkxwWaAG1SaPgGfkA9Ai/NFvz0=
Date: Sat, 07 Sep 2024 20:18:41 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-add-pgalloc_tag_copy.patch added to mm-unstable branch
Message-Id: <20240908031842.7CFB3C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: add pgalloc_tag_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-add-pgalloc_tag_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-add-pgalloc_tag_copy.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/codetag: add pgalloc_tag_copy()
Date: Thu, 5 Sep 2024 22:21:08 -0600

Add pgalloc_tag_copy() to transfer the codetag from the old folio to the
new one during migration.  This makes original allocation sites persist
cross migration rather than lump into the get_new_folio callbacks passed
into migrate_pages(), e.g., compaction_alloc():

  # echo 1 >/proc/sys/vm/compact_memory
  # grep compaction_alloc /proc/allocinfo

Before this patch:
  132968448  32463  mm/compaction.c:1880 func:compaction_alloc

After this patch:
          0      0  mm/compaction.c:1880 func:compaction_alloc

Link: https://lkml.kernel.org/r/20240906042108.1150526-3-yuzhao@google.com
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   24 ++++++++++--------------
 include/linux/mm.h        |   27 +++++++++++++++++++++++++++
 mm/migrate.c              |    1 +
 3 files changed, 38 insertions(+), 14 deletions(-)

--- a/include/linux/alloc_tag.h~mm-codetag-add-pgalloc_tag_copy
+++ a/include/linux/alloc_tag.h
@@ -137,7 +137,16 @@ static inline void alloc_tag_sub_check(u
 /* Caller should verify both ref and tag to be valid */
 static inline void __alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *tag)
 {
+	alloc_tag_add_check(ref, tag);
+	if (!ref || !tag)
+		return;
+
 	ref->ct = &tag->ct;
+}
+
+static inline void alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *tag)
+{
+	__alloc_tag_ref_set(ref, tag);
 	/*
 	 * We need in increment the call counter every time we have a new
 	 * allocation or when we split a large allocation into smaller ones.
@@ -147,22 +156,9 @@ static inline void __alloc_tag_ref_set(u
 	this_cpu_inc(tag->counters->calls);
 }
 
-static inline void alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *tag)
-{
-	alloc_tag_add_check(ref, tag);
-	if (!ref || !tag)
-		return;
-
-	__alloc_tag_ref_set(ref, tag);
-}
-
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
 {
-	alloc_tag_add_check(ref, tag);
-	if (!ref || !tag)
-		return;
-
-	__alloc_tag_ref_set(ref, tag);
+	alloc_tag_ref_set(ref, tag);
 	this_cpu_add(tag->counters->bytes, bytes);
 }
 
--- a/include/linux/mm.h~mm-codetag-add-pgalloc_tag_copy
+++ a/include/linux/mm.h
@@ -4161,10 +4161,37 @@ static inline void pgalloc_tag_split(str
 		}
 	}
 }
+
+static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
+{
+	struct alloc_tag *tag;
+	union codetag_ref *ref;
+
+	tag = pgalloc_tag_get(&old->page);
+	if (!tag)
+		return;
+
+	ref = get_page_tag_ref(&new->page);
+	if (!ref)
+		return;
+
+	/* Clear the old ref to the original allocation tag. */
+	clear_page_tag_ref(&old->page);
+	/* Decrement the counters of the tag on get_new_folio. */
+	alloc_tag_sub(ref, folio_nr_pages(new));
+
+	__alloc_tag_ref_set(ref, tag);
+
+	put_page_tag_ref(ref);
+}
 #else /* !CONFIG_MEM_ALLOC_PROFILING */
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
 {
 }
+
+static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
+{
+}
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 #endif /* _LINUX_MM_H */
--- a/mm/migrate.c~mm-codetag-add-pgalloc_tag_copy
+++ a/mm/migrate.c
@@ -743,6 +743,7 @@ void folio_migrate_flags(struct folio *n
 		folio_set_readahead(newfolio);
 
 	folio_copy_owner(newfolio, folio);
+	pgalloc_tag_copy(newfolio, folio);
 
 	mem_cgroup_migrate(folio, newfolio);
 }
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch
mm-codetag-fix-a-typo.patch
mm-codetag-fix-pgalloc_tag_split.patch
mm-codetag-add-pgalloc_tag_copy.patch

