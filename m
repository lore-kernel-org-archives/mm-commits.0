Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540521FBEA8
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346836; cv=none; b=ataIdAal6r4jfIKjbhEedi9+TjsFiS3dUoVq0Pq2BgHqOGXKrBC4OVRfuf2Hv72Tp8aaRzcdLggRHSI7mOaA5Xeef7bPi2TPjEBYFPy0fm35daNKeY5cPMM0kgqQYXAROdEZDnEYA3xevu+r5esIjeAItsTsdkwV042awOk2PlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346836; c=relaxed/simple;
	bh=voXOdJ8eg5z23zkc95TiQfZKswALt9UU25+DPJE/XUY=;
	h=Date:To:From:Subject:Message-Id; b=WoSM+iCX05V43KtDy3ax8M3inmZrldjF+lPW36Iv2mEIn0jGCUFFsbkVA7keUJZU0aZbaxZMmlPJX2k5fHfYXseoavUMNabIyOehxAwZQ0zrtTXPWsc8opsG0xATEFV2z9nYNS1hUh+RY6qC3u0hziCSfIrY0AoDSfB6sZRwkJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxCIFJ+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxCIFJ+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B451F000E9;
	Thu, 25 Jun 2026 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782346835;
	bh=cy0kjfHZ2L/EAc3mZuM2WBGADpwd/WH8l8Yb3jUrNiY=;
	h=Date:To:From:Subject;
	b=uxCIFJ+I0FnN2JXdytDncrcWB4Xti6pE3irHpucau1uEIP3zHpGYYFrZz4D41PwOz
	 G+00IzflXEHBr/qQDDAF0Jf18NEKYJC+T0O2qERvWMcy8HgCvV59K6lbbiav8pn3Q3
	 boX/MZXeV5gRtji4/i7bfGmh6yB75gDJ23Pg/TRU=
Date: Wed, 24 Jun 2026 17:20:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625002035.20B451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for last_migrate_reason
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for last_migrate_reason
Date: Tue, 23 Jun 2026 14:52:27 +0800

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences with a
local MIGRATE_REASON_NONE define so the intent is explicit and the magic
number is eliminated.

No functional change.

Link: https://lore.kernel.org/20260623065234.31866-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason
+++ a/mm/page_owner.c
@@ -21,6 +21,13 @@
  */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
+/*
+ * Used to indicate that a page has never been migrated, as the valid
+ * migrate_reason values are non-negative enum members (MR_* in
+ * include/linux/migrate_mode.h).
+ */
+#define MIGRATE_REASON_NONE (-1)
+
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
@@ -339,7 +346,7 @@ noinline void __set_page_owner(struct pa
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +674,7 @@ void __dump_page_owner(const struct page
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zo
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MIGRATE_REASON_NONE, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

