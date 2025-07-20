Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE0B10E9
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978257; cv=none; b=iurtQKlZCAOBet7WkmF4y/Wx8k48HJJPdeDcXJkcDlNljX++efPW/hT3xW81o6arLySEQADPfXyZmaKArdaokk+o8lUsCqXTUBdh7wMjEF/MeqCFqyY58FrNPwLyILztQnfc5VdHkbSlAGV3s2R1RtlMGqLnr7NaZCJBBoF8Z9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978257; c=relaxed/simple;
	bh=Jd5o2jq+arx+gCvW9GAzyX6LaLrneO8GWKkxLtmUDF8=;
	h=Date:To:From:Subject:Message-Id; b=ZJKyiDhmcQSV9pdajOITAM3uiliW0IuQoZp9ID4J+gQ19U0DskXdRCw2bOXT4RprDGV48MEc6h+oz4epT0I6Z2GW01RH4SttMvzoIm6uydw78xedWk2arbz0KYWx9IIAOvHM7J6IASXBuUAM6iLfQMwda4OwRmZEzUle5GNYqKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tQ01Ek/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tQ01Ek/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22567C4CEF4;
	Sun, 20 Jul 2025 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978257;
	bh=Jd5o2jq+arx+gCvW9GAzyX6LaLrneO8GWKkxLtmUDF8=;
	h=Date:To:From:Subject:From;
	b=tQ01Ek/5bkf5yt0lt9e4BKACzSYOUTZjWKbV8QZAAWPTdU8Li4ESiLPQ6FYY+j9Kk
	 R71O8LvM8DO8Jk/rIiK19JkolsYBoN3f6O80X1eARgJ3DIlkGpfimC3oexDrKzV4SR
	 U2KfWGCMmg51ppZqNTDOMQaxvIfUkUA0ZC1mxeeQ=
Date: Sat, 19 Jul 2025 19:24:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch removed from -mm tree
Message-Id: <20250720022417.22567C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch

This patch was dropped because it was folded into mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
Date: Fri, 11 Jul 2025 16:55:45 +0800

add comment to unmap_poisoned_folio()

Link: https://lkml.kernel.org/r/69fd4e00-1b13-d5f7-1c82-705c7d977ea4@huawei.com
Fixes: 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reported-by: syzbot+3b220254df55d8ca8a61@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68412d57.050a0220.2461cf.000e.GAE@google.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory-failure.c~mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4
+++ a/mm/memory-failure.c
@@ -1561,6 +1561,10 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+/*
+ * The caller must guarantee the folio isn't large folio, except hugetlb.
+ * try_to_unmap() can't handle it.
+ */
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch
mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

