Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD63367F3C
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876974; cv=none; b=dxPa48UaD+OIwxEid3tflyRMaYQcdkQ4ceQvsyxMN27D6YV1zkVb6AzzOM5G6oEv/179o9f8FxEwtIy/0NJzF587JMbU6YD6Zhilf+VGO5xBGye5K0dT7RzOpOIUh/BJtslo8wCwEnoanAbEnbEk7iI6wAn382YOwBXS6ZF+tAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876974; c=relaxed/simple;
	bh=1W0cK4PPzvxSo4iJCuFYq1lf03LNmRd1fwUDwdbaoWQ=;
	h=Date:To:From:Subject:Message-Id; b=YhuqqRAtCG2LsvGYwP2J4j6d5zvcNF4wRJb1M3MTjrVhdn/frPODD7/WRBKf2QKAP0/Ymc8thLaKeSFnu2qma84Ym22tU2CP+BBnaK7mDxvxDuUwoGy5zMZ535O7nCPFh1RLimjSs2ubWZfxS91c+HzoUmcCGOpwktaGLjh4A+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAl1J5Fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAl1J5Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137FA1F000E9;
	Wed,  1 Jul 2026 03:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876973;
	bh=gw++nkPl0Ag2NThw8m1yiTn5jFehjPrSwQGYI5jiYpA=;
	h=Date:To:From:Subject;
	b=OAl1J5Fgto1O+nLzPJDdDTtI6LIWo1DUnlry6QFY1CT40EFcQ/flSdD/WDdxP8Ynh
	 JR1V2ifR6K8NPeGM9aUqFXDf0SPCqC2TEzHm6XXADdtixpLoT3qI77wf1USeqT3JuT
	 +62izO4vkkS6g9aYdIOeanO06DtrNtDOvFN1nw5I=
Date: Tue, 30 Jun 2026 20:36:12 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260701033613.137FA1F000E9@smtp.kernel.org>
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
Date: Tue, 30 Jun 2026 09:53:22 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260630015331.147174-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void
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

