Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A516B175A60
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782613895; cv=none; b=k5wf0KxNvtbqLfwOs42Xt+YSSHh5y7h1aozX3Hb3QNzRwMrgArncu0UBfrHpAr1ibhTpQrS4PRMQAJlm3LIf9BcJ41XfT8FsoyAlxOHrCrk4Q17NNxRsnsnIXCmsfWrUBTPXaix4HgYcJMFf4ZKyY0kJqWoMnURFq5TVFl6GN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782613895; c=relaxed/simple;
	bh=pDQXHehYbPlc92LVjWB8uP7HD7FdzFVMTDDEGKREQNo=;
	h=Date:To:From:Subject:Message-Id; b=i2jJ/xZHcfR0bQsZPmhjw0VJRsA1g1b+QnuVUmEPjBWVW4HEeqL347tXX/mzVDEPABbAcPUy4CdLBg5PVwlqdvbvqbPJzoyfzKPrbuFESMLZIX7pSa6aC1B51weK2T1HWXVxCbqU0IuGHRao6Dbdy1qr3oulTO+pyIm0jARes/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2t0/TOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2t0/TOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B7E1F00A3A;
	Sun, 28 Jun 2026 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782613894;
	bh=hB6QUFdj0oic1KEARctP87YndTQz9Y+t20+b4d48Im4=;
	h=Date:To:From:Subject;
	b=T2t0/TOutrLc9qfEuPxnjEdZ2yAlrn86DsnwT9Hym68KW/xudr0JgtUvgFr2jdayd
	 eHhJwHvVyHmZCoyp708jedp51Mt6wl+++5wyv6rP61XszC9R7Hl6y+G+M80qgK8Dl5
	 VKO7GClBMMbKUQhBoaLnoeMkVK7ODVXFGUf3qVoQ=
Date: Sat, 27 Jun 2026 19:31:33 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch removed from -mm tree
Message-Id: <20260628023134.50B7E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for last_migrate_reason
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch

This patch was dropped because an updated version will be issued

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

a.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

