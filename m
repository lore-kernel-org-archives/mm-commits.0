Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84E18E34F;
	Mon,  9 Sep 2024 23:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925329; cv=none; b=rpDnU3+TYFFkT0jdTqTm6hrjWXcbNTEuLhRJS2dCUfn27vS38EhS9fLhyrG2subcYBGHb8v21iBDLSiSEJXRsl+8rE8loNGQgKn0Xv4j5KojUbywIR7X4oyEIirYT2fc2KGqeiL4tgIHrtEvKSf+rwZUz1LwIRtLhvVwyzksInk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925329; c=relaxed/simple;
	bh=CQrI3RHAah/cNOdGisSORru2up/rIvgnuidztkldzaQ=;
	h=Date:To:From:Subject:Message-Id; b=fYUXcQloR8WQbkhlIGNSH4odBwYY1AEwm2It2S7QoZ4Qy8c4tR/i74WbtZhhOq+R8L6DEQ3FC8ivLw4pknvudCmyMnXY0mNiUn4kMvmOoOkkELFYALytPsyYwSv4NmCILDnGy/bCu/+xlqRi9XOh4FRauqZc9ey5xlu0appZhFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yNxkm/4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yNxkm/4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA2EC4CEC5;
	Mon,  9 Sep 2024 23:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925329;
	bh=CQrI3RHAah/cNOdGisSORru2up/rIvgnuidztkldzaQ=;
	h=Date:To:From:Subject:From;
	b=yNxkm/4DFDM/lA9pYQTUpQjrXkB+0s0IXfxmgXke/Yi0po4QkkXWWiyxQ45Jl54MD
	 Ggyauc+syV3VYofPmWyUM05kL+RQK7h1Ya5rl2GLdoQ+TnwMJS9nUNEyiQea37puAf
	 Z+ag6fAlfdRtf60APt9J4TaXiIXJbpepXoQCdDOU=
Date: Mon, 09 Sep 2024 16:42:09 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-codetag-add-pgalloc_tag_copy.patch removed from -mm tree
Message-Id: <20240909234209.9FA2EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: add pgalloc_tag_copy()
has been removed from the -mm tree.  Its filename was
     mm-codetag-add-pgalloc_tag_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
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
@@ -4108,10 +4108,37 @@ static inline void pgalloc_tag_split(str
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


