Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CA289E10
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061626; cv=none; b=G0i4snNDEQuXfqyyN8L5/JKdl0x5yNaKHjCjIspqZsKFuU4DmN7Wg6sV4FcyeyuN4un5WKJ9XUKt+lZaXIxwu6hrlFbMUP69/gQL9VzXivgvsRlB3i5BoL5FAdPArwviGbXDHg1T1YRlSID/hEd+1JbmAOlcWmBde0OXOHGWKuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061626; c=relaxed/simple;
	bh=+v9ndMUMAE1ehAE2ZSUrIL6NC0O1Bc7F/TZFMWwqfU4=;
	h=Date:To:From:Subject:Message-Id; b=tuWBY6qFKCmBOCRIMsqPS8mPZrvF07/LfKA0qXwHedsnPjcnkqI92gzhOBZv0lOjvHfmp12gukTlMBxaIxdfmYYWav8c4/7AqJ/asdjmefzbOo3zOGHdareDPiKGqgFfRKiVCL/2D4bloR3XZ7v+pAdx7wYR3M0k2m8b1ScsEL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eDI4dAXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eDI4dAXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D9C4CEE3;
	Fri, 27 Jun 2025 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751061625;
	bh=+v9ndMUMAE1ehAE2ZSUrIL6NC0O1Bc7F/TZFMWwqfU4=;
	h=Date:To:From:Subject:From;
	b=eDI4dAXFnFyHF8gNca7ar5ouw27Rq0dpGBEaynL3lNcEBrEELYqQrXewGAbvwxAA+
	 5v0PrLFGgbPn+inrWv98yBrawACxaqSMDKwVuz0UeShkEYnPoriOrd6HtfwVC5OQEs
	 rHdYpXiH6NeuTDBTCKA7va3KRxuUfD57zVflPzm4=
Date: Fri, 27 Jun 2025 15:00:25 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch added to mm-hotfixes-unstable branch
Message-Id: <20250627220025.9F5D9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch

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
Date: Fri, 27 Jun 2025 20:57:46 +0800

In shrink_folio_list(), hwpoisoned folios may be large folios, which
cannot be handled by unmap_poisoned_folio().  Since uncorrectable errors
(UCEs) are rare in the real world, and races with reclamation are even
rarer, simply skipping the hwpoisoned large folio is sufficient. 
memory_failure() will handle it if the UCE is triggered again.

Link: https://lkml.kernel.org/r/20250627125747.3094074-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Fixes: 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
Reported-by: syzbot+3b220254df55d8ca8a61@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68412d57.050a0220.2461cf.000e.GAE@google.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1138,6 +1138,14 @@ retry:
 			goto keep;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
+			/*
+			 * unmap_poisoned_folio() can't handle large
+			 * folio, just skip it. memory_failure() will
+			 * handle it if the UCE is triggered again.
+			 */
+			if (folio_test_large(folio))
+				goto keep_locked;
+
 			unmap_poisoned_folio(folio, folio_pfn(folio), false);
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch

