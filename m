Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4133B3A3E76
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782950252; cv=none; b=Q9v6tNtgis1ICew2NZUj6bVJhM8gj9gIp8prHh8XwblpJj+leQkUinaq7kOBRVR6bCp6k9Iq3QRbbTeZS1A7XrGkos5Eq5NpWBoGKJH4DwS6hXlxncrtwAk5uPp1k07olFXUvZGA782rqw5RrmkXg6IDyV03MicDba2heX6R7Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782950252; c=relaxed/simple;
	bh=AGXkKcWL/8K6fdhzhIeH9htW3JQGg/Ypv/gvGY31HFM=;
	h=Date:To:From:Subject:Message-Id; b=DyhFaCuP5CdeNUuX2firSUC3WeX3XNjrdS5xiJLHiQM1j+PQ5P4Mql02LXIZyPgd4ENBz+rCNiqqNK2MDCe8Lghm9HkUFKVnrjN2P41dhoO//No6mFvvKBHNr9s9SEtVFpSa0os6u0Vi4Ew96KPMOP0H01HhyMM4NYUhxl/t+uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SpOuy32i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpOuy32i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92291F00A3A;
	Wed,  1 Jul 2026 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782950250;
	bh=8jzzSo3XYPO8wz/ZzMO/DJpAdNLD21G9iMopv8eLZ+8=;
	h=Date:To:From:Subject;
	b=SpOuy32iUqnxDXwOoOIimge/Qd4V3cSXGCrXIIJER4IllvMrqy0t1FNp2NTREBR27
	 dXvJF7eqejYGkwnJzQMtVgR4MNtFr4L5+y5RCjLZARn2MC+OqkSvSbofr2CzsSIdpW
	 CLn9bhv3JVMIBOofXIW1/hzu3vGjnWVoPIrcdOsw=
Date: Wed, 01 Jul 2026 16:57:30 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch removed from -mm tree
Message-Id: <20260701235730.C92291F00A3A@smtp.kernel.org>
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

mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

