Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171441F872D
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782613898; cv=none; b=HV9BbaPxn7VDrLjSR0rJQhlksxyWCVzm4cp8/TG3ih1Cnow016cbKT+Vf59B1dOyRRy+Pa5Mxi8/qLHiSr9WOTEK6Gq0z2hMryxZlNHY5XK0bQL+xBSM3NtSqSJT8W2CxFbnFeu55xI/9h0mygB8Cr87+xBzJqO8IBevWC+xYFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782613898; c=relaxed/simple;
	bh=pDFX/sqPqvkGK/wODjx1BhF9DT/6VeVLYYlZlly55Uw=;
	h=Date:To:From:Subject:Message-Id; b=GcOHEKzHDpMy4qBFFoyXbQdzFY4OQEVUr4qE3+plqJ6BE2aYyIE6G7oSLl6d8JpP4HWvvPJ7Rmml9cqeDiNnUpcLgScU5/I2FcO1by2++X66Ffvk3ShpnkIpND50+y8q++8tk5AZHzZlos7K5Ap8PeFsGulqiKb4M1b/hktvbGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaYacdRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaYacdRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E3E1F00A3A;
	Sun, 28 Jun 2026 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782613896;
	bh=dssT47PGUlzspo8Blp0TPG0FbjnSElSdRvkZzj1jJwc=;
	h=Date:To:From:Subject;
	b=kaYacdRf+ostpPYktVLwmydpz9Ol9JXcTH3i5YU4oUaw4sbcpEG+YwRqhISRCTofg
	 ijvIjBBoSfNhB9cIUge1cvEoihhH3i5Q8ASqdqqi+19HG4Pux+0BYKDpJw71Zt42jo
	 8WTD6N6DG6uNqvBRxcxrqJAWLfbALfgDOqp3DqJg=
Date: Sat, 27 Jun 2026 19:31:36 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260628023136.A3E3E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Tue, 23 Jun 2026 14:52:29 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260623065234.31866-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -981,7 +981,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from ye.liu@linux.dev are

a.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

