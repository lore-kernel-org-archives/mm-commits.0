Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E79823DE
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782613899; cv=none; b=C4zUhkJB7bn3LJdmgQuxKWVisM02qvBcubIxWQQghxJ2izvlrjqjw+1SaDpvnPmoVJwd9qTop8hmBeLGK6IMcazC0B4zHNivMM1O61z+s3qxc3CPMTdLNK6GcaqLEvbpeE7p46hNUjx+CV5NYLJKDihR/ftDCfIagXY7wwTk6Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782613899; c=relaxed/simple;
	bh=INrPBTTdBbORlJmErqbHFlDFDBhuv04nv8V876pol9Q=;
	h=Date:To:From:Subject:Message-Id; b=CVjIj3+Xo9KEAcooPcd5MZkkHFB437eXmR3E8A1O5DcR0VBaGR4a6DfqfK5ezZy4aKlzQcFMDq7OinqELLhwW7Ga30s2dqPwHMw7QxqARGyNyrDnLDrF3y5su46pS8go+yD+c4QoWDRAEVzQBoriW8xgU5ON20En52NUz36FnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hnF71RrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hnF71RrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0F11F000E9;
	Sun, 28 Jun 2026 02:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782613897;
	bh=cekAl8cVnveEYR7CxKhSB0u6133v9TFQ+Qjb8D71DVM=;
	h=Date:To:From:Subject;
	b=hnF71RrWuRvLbZMYOaMj1G61WQ/Xy1P3C52XEOhlqsJ2OdeHINJzzTXOQD5bno9Hn
	 Z+SEH5bG/Q/iyhAY7+ZvEFV/lWD78MWrg1alvA67gsK6S+XrFnJjY6BEbXFcL8/iDP
	 CQGwRG4JbAL41VLw2C5vgBF0tafiLiKmOrPf0p3Q=
Date: Sat, 27 Jun 2026 19:31:37 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch removed from -mm tree
Message-Id: <20260628023137.CD0F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Tue, 23 Jun 2026 14:52:30 +0800

The free_ts_nsec field is a free-event timestamp, but it was printed in
the allocation summary line alongside ts_nsec (allocation time).  Move it
to the free section where it logically belongs, together with free_pid and
free_tgid.  This also makes __dump_page_owner() consistent with
print_page_owner(), which only prints ts_nsec in the allocation summary.

The output now groups all free-related information (pid, tgid, timestamp,
stack trace) in one place.

No functional change except output formatting.

Link: https://lore.kernel.org/20260623065234.31866-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner
+++ a/mm/page_owner.c
@@ -660,10 +660,10 @@ void __dump_page_owner(const struct page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -675,8 +675,9 @@ void __dump_page_owner(const struct page
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
_

Patches currently in -mm which might be from ye.liu@linux.dev are

a.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

