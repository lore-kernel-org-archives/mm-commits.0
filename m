Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C31F356755
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876970; cv=none; b=aSGEu9LkYt9WJFeJ/dd5q0C+V0s9gveScVGeuW7CmqaT0VEoOiWo9l5qhUoJj73fdB9humMzbjD81SGzGuRT2+FpCwsXAEQ5T730OgYIwQEXCv08srMXBknn5E7sP3woa7uuDZGbERKpndEsgYfK+XkaUAVDBm8NDmAuP1skYEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876970; c=relaxed/simple;
	bh=LodM4gMHH5APeGC8tHRU6sX/bvT1hJSOJUQ23spXIao=;
	h=Date:To:From:Subject:Message-Id; b=ZgleNXD2QNZA3d4ojrgb495QKjQJJi3O7GrhrdcnhaFWICcYaG+IsoywbPPmTG8rxR2/7XaE+wg5uONNGE9eKFNkVxxw/yyvQrPIN2aXKqxjSwUbchgG6LKF/ANbvByGggMtgNXhun6oRV8g3F4Y0xf1VJG3ORgF7vhRaq2a4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=quzAzfh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quzAzfh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A47D1F00A3A;
	Wed,  1 Jul 2026 03:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876969;
	bh=/PHoO9iYr60nPCIicD3GQc2LooqB06hgfC15togYJkw=;
	h=Date:To:From:Subject;
	b=quzAzfh3caeFmtLHwRWUa6JScwgMrAUmnm+ThMh1F90uho3pCYu4Ql+6P3eYXpALy
	 qI28B1NX4WRfdOJOHDXbTo33SfF8QrMy5183pvvZ8dlVDs3rhewqCZulJ1o1nT/uwO
	 q72R3mBV6yeprPcEn6zXaomZ4KL9tGszfo8EAzH0=
Date: Tue, 30 Jun 2026 20:36:08 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch removed from -mm tree
Message-Id: <20260701033609.2A47D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch

This patch was dropped because an updated version will be issued

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

a.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

