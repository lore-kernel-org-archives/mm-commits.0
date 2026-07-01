Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02760367B81
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876976; cv=none; b=V8wZOd3SwOYDDWWefOgwhuIHm0PxayWxGsB5M7rhyhaV1BlQ2pH2HBDgzHtpPX2nHk1nlFjE6M6XN6S1J6QN+Uahg1tbNibdFh1VQ+BEUczbCUZfx0nszHJ7Sa6VXzXhnSRFfoGdYezW37oUx7ckQUOXscrB8Cveq1r7QZW3PyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876976; c=relaxed/simple;
	bh=92dQhIQ3KMmvsfuoO6oc7hYOR3UIE+HNB84sV28mppg=;
	h=Date:To:From:Subject:Message-Id; b=Wihuy7E8Bt4iG49UYaDMAfTruD4PvWLrvb+0teA6xHAMS5nQwfRYFJv0ZYzMKATIHmAJVO0ZwKI9AQA5seGaDv5m9bgjjPzwydRHMVtB8noc8zdtqKmq0dDv41EMwXzuz8v8nu6miqkJ48mx6zBNPM42PcKkUQejcVnflQtntpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJ2Nsk1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJ2Nsk1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A6D1F000E9;
	Wed,  1 Jul 2026 03:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876974;
	bh=QdXSgvZlBETIW1OTKocDYskHziJ9NdI8pRSSbO4j7KI=;
	h=Date:To:From:Subject;
	b=SJ2Nsk1nP8yyh/LJcG8Lk7+YBQ8KddAZVHHcEVaAZRs+yrK8Oc9RMuDRIIcOSm+66
	 Chn2vwbsjfc1gC8lYk5swBXyjNqdvhT/LGe9k4TJfTJq1axtY9QoaET8YNLwSc53sO
	 MiNB12Q5wLMFqql5j4YOJCDUJb4gFPAESctEgWlw=
Date: Tue, 30 Jun 2026 20:36:14 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch removed from -mm tree
Message-Id: <20260701033614.93A6D1F000E9@smtp.kernel.org>
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
Date: Tue, 30 Jun 2026 09:53:23 +0800

The free_ts_nsec field is a free-event timestamp, but it was printed in
the allocation summary line alongside ts_nsec (allocation time).  Move it
to the free section where it logically belongs, together with free_pid and
free_tgid.  This also makes __dump_page_owner() consistent with
print_page_owner(), which only prints ts_nsec in the allocation summary.

The output now groups all free-related information (pid, tgid, timestamp,
stack trace) in one place.

No functional change except output formatting.

Link: https://lore.kernel.org/20260630015331.147174-7-ye.liu@linux.dev
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

a.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

