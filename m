Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A513655CC
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 02:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782786547; cv=none; b=mMYQ+DA3OQOCHxX2jcMZ3/n0csN0BybufBdKECXDNvt+85jS4unR+y15UMzdDsTHX7s7fo3xLY3gxKDVI/LrEpTgvuFz7BsLOEwa6X6J9fXZMAC4iM7jzyZzMdm62tQOpEYYeUPNdlGFpsBzc8sx177go1pkLdVBNSqvELLUfPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782786547; c=relaxed/simple;
	bh=qdPxZP9C/TaNmVLil7NRJzIG21r9nAp7jomcHvq9pv8=;
	h=Date:To:From:Subject:Message-Id; b=U/kh1ax5BrSFfWXa1xSpZpUeJeA7LIo7OVvjcKZHO3g7Jtk47Q+zAefpA4U6/PtDeRJK5pIeD8GE44BMv5VnhnIM/+jTkq60BqKZWiD/6qST+cz9G3QkPeoHyk/x+CgB8m0s260iI+ehq4TP8VsJnI4KXg7c5ixcw0qnhOIdt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHiXKmOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHiXKmOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CD71F000E9;
	Tue, 30 Jun 2026 02:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782786546;
	bh=746yT+EsJgRU6zRnUJ7mtJREahhX3SUJX+KmUfPkaiY=;
	h=Date:To:From:Subject;
	b=eHiXKmOZSZNOZKpymOk/7QSuymRHR2sFd0/nrHPkTPpj96zXGypDV1U4jz/jd4Rsc
	 0WU+NxD4g206AJ0QYtZFk27R7YJDBo+UD7UDE+o0hxfOOK07f8CYdT7W88nQ3mSqlY
	 Ch8WW8IIgAG7WpBJeafnyCqcFJfdCLTkITy8lnXw=
Date: Mon, 29 Jun 2026 19:29:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch added to mm-unstable branch
Message-Id: <20260630022906.50CD71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch

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
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Tue, 30 Jun 2026 09:53:19 +0800

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences by adding a
proper MR_NEVER member to enum migrate_reason, defining a corresponding
"never_migrated" string in the MIGRATE_REASON trace macro, and removing
the local MIGRATE_REASON_NONE define.

No functional change.

Link: https://lore.kernel.org/20260630015331.147174-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate_mode.h   |    1 +
 include/trace/events/migrate.h |    3 ++-
 mm/page_owner.c                |    8 ++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/linux/migrate_mode.h~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/include/linux/migrate_mode.h
@@ -25,6 +25,7 @@ enum migrate_reason {
 	MR_LONGTERM_PIN,
 	MR_DEMOTION,
 	MR_DAMON,
+	MR_NEVER,		/* page has never been migrated */
 	MR_TYPES
 };
 
--- a/include/trace/events/migrate.h~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/include/trace/events/migrate.h
@@ -23,7 +23,8 @@
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
 	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
 	EM( MR_DEMOTION,	"demotion")			\
-	EMe(MR_DAMON,		"damon")
+	EM( MR_DAMON,		"damon")			\
+	EMe(MR_NEVER,		"never_migrated")
 
 /*
  * First define the enums in the above macros to be exported to userspace
--- a/mm/page_owner.c~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/mm/page_owner.c
@@ -339,7 +339,7 @@ noinline void __set_page_owner(struct pa
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MR_NEVER,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +596,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MR_NEVER) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +667,7 @@ void __dump_page_owner(const struct page
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MR_NEVER)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +826,7 @@ static void init_pages_in_zone(struct zo
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MR_NEVER, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

