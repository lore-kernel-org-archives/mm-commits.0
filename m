Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F68368D5B
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782877326; cv=none; b=JFZE4FqZVthJGfGg2qDGXxYm/GgZbIQ/Ok0o/Abu4Lebdo49u2mT0fQaGI32tIPeJafZFRC986yxdgkq5RM376gHt8w2dm68dwuB2Vnyu9csaHLbqW6DDgleVs/wSUK1ID0ZVTUUx2FFXL33Af5eedmi/2q/yVXHVYTA4q2DdwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782877326; c=relaxed/simple;
	bh=x5ty+KOgseN03T/7M6dAGanKhrV/lEvxRV7FSuj8PIA=;
	h=Date:To:From:Subject:Message-Id; b=hu7yIPyBzHQzEpOp7M1XftfoNJxTVLZrhuGSeAl0LQJzGdhBrpk/+JlckCaUooVBoWmnrILpI9chUAPZixjqXzjW46qzGQ7QFS3lseBPKMv7sFnVskP5mclWwsRUGYkJ5FEhbTK0Dd4pY5Gw2WprTFwA7bD5GVptfKDYgWl3X18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hn5/6uxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hn5/6uxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91691F000E9;
	Wed,  1 Jul 2026 03:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782877324;
	bh=3e+bAnPCpj0Z4h/WbxRNFGhusePBVftrBdfGc862TfQ=;
	h=Date:To:From:Subject;
	b=Hn5/6uxR6thNVkh9I3qfLZYxeDS2P2Kqy0zMfHcQjcOEZUv9HSmMr9qDQXk7+GAm3
	 6BPF2IvjHjZBmlpVUWMRslPbpAF/mEQWxlObeIgtJuiBeNiUKD3bERIhjTvo2mnKI+
	 iaApoC2T1ZNOZ5JnP2LIa+EhxYtfZJgGIDHeBA9I=
Date: Tue, 30 Jun 2026 20:42:04 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch added to mm-unstable branch
Message-Id: <20260701034204.C91691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch

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
Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Wed, 1 Jul 2026 09:22:32 +0800

The free_ts_nsec field is a free-event timestamp, but it was printed in
the allocation summary line alongside ts_nsec (allocation time).  Move it
to the free section where it logically belongs, together with free_pid and
free_tgid.  This also makes __dump_page_owner() consistent with
print_page_owner(), which only prints ts_nsec in the allocation summary.

The output now groups all free-related information (pid, tgid, timestamp,
stack trace) in one place.

No functional change except output formatting.

Link: https://lore.kernel.org/20260701012239.315262-7-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner
+++ a/mm/page_owner.c
@@ -653,10 +653,10 @@ void __dump_page_owner(const struct page
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
@@ -668,8 +668,9 @@ void __dump_page_owner(const struct page
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

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

