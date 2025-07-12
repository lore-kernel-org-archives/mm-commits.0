Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A252A231849
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752364481; cv=none; b=u6a8cN7XpF9n/5ocv5CL7N9cFu7hXa0H/8gbvXCg0dXpuDQZrNx8ttXHJA0rMwsavL0cwKiC7zPYSuUIhGIE/PG/Q7X58EqnRSXPBIbdh2whd6xA2Put7p7QPFMfnXZvHuBlnDo5/9ds+c1k/CSfgdizmVeFZvqmgu2zfGeC1ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752364481; c=relaxed/simple;
	bh=ZK6J4lnMS2UF9CnyeM7EX9KGdM7mGmKZvYRRWKhO53Y=;
	h=Date:To:From:Subject:Message-Id; b=LIzog39CxpiiwFaEPU2XGOFSZq2u6wdSg+BnM2TvwiodMPEpU3up2wbVAZI66l6KYXCFYG+A45uZfru6eia4aHzRImgvH50XpD3McKzqGiYGs7GJpUy6i3mu6O9ycjPAbbKqWbBfBN4Xxhc8hziOcD3PvOgiXj94Afbq20DF7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgBDoWaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgBDoWaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6355AC4CEEF;
	Sat, 12 Jul 2025 23:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752364481;
	bh=ZK6J4lnMS2UF9CnyeM7EX9KGdM7mGmKZvYRRWKhO53Y=;
	h=Date:To:From:Subject:From;
	b=DgBDoWaTDPuKznQMJ2+H2Y3A780SJdhHX56NbPkBlcPVTQH3Nw3+FUCX/4WctZQcc
	 wZn5+a/I+if7xbbV0akvKZkdwoHixwWmr/m68Iq+p0q1vNeULaWzXP5qwSbxIPLR13
	 lYrVKyNccG2QMGCKNC6jF+dGx7gakUcf5YDjdUmA=
Date: Sat, 12 Jul 2025 16:54:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20250712235441.6355AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch
mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list-v4.patch

