Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0E279DB3
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 23:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704683; cv=none; b=Vu68ExvpeyXVzoGnfLSDkD2dJsFa1GswF8zfVACamTnVvfp39HOk8jiQfO8pjxntPwVaiPKO0bLq7DecB4VFPzr0nrT477+U6FiAAuM+8X0XAJdLjKmKu5X2rzqz7n5ZminT5/28bMReohTD/kt+/id+EtnaogzjfGOhp5eJ9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704683; c=relaxed/simple;
	bh=14GwxsCekIugyaNDpbvbeKxGUJ/HRtKp5l4bWLOQ7dE=;
	h=Date:To:From:Subject:Message-Id; b=ckpbsRvWfKsAQLmS2wH/zzrwqY6Xjjqh5hY8ahx+zbLd4YD1JiAx+luC8Ks5LmQuwau18844c2ctvpvKNXlGuYBTY/lTfysDv63Wd+Q2gGrruZRi6Iey+EwHE20wLIJ1VW6hdeujeA+bfK0nXc3Hktf/cVBL/+jQpXDxASQpTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCuCWsPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCuCWsPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818FEC19421;
	Mon, 16 Mar 2026 23:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773704682;
	bh=14GwxsCekIugyaNDpbvbeKxGUJ/HRtKp5l4bWLOQ7dE=;
	h=Date:To:From:Subject:From;
	b=yCuCWsPZuFDeJI/ZIpK8Lsz5UOUd3QzVbcEuJy8p6GQ7rRCLQHk49bey4JvOQ/bQY
	 RTkMW4AzjFy1/a5O2rcb49t7ZClvS+LFVQQ/9hBIx9lUN3XG9qMiCjwoFBqe29Ut97
	 gzxrL5V/ro0tFC6TF84uOmL00Y1y05ub1QwffxIo=
Date: Mon, 16 Mar 2026 16:44:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,toke@redhat.com,rppt@kernel.org,hannes@cmpxchg.org,david@redhat.com,asml.silence@gmail.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch added to mm-unstable branch
Message-Id: <20260316234442.818FEC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch

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
From: Byungchul Park <byungchul@sk.com>
Subject: mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5
Date: Tue, 17 Mar 2026 07:31:13 +0900

gate the sanity check, per Johannes

Link: https://lkml.kernel.org/r/20260316223113.20097-1-byungchul@sk.com
Suggested-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5
+++ a/mm/page_alloc.c
@@ -1379,9 +1379,11 @@ __always_inline bool __free_pages_prepar
 	}
 	if (unlikely(page_has_type(page))) {
 		/* networking expects to clear its page type before releasing */
-		if (unlikely(PageNetpp(page))) {
-			bad_page(page, "page_pool leak");
-			return false;
+		if (is_check_pages_enabled()) {
+			if (unlikely(PageNetpp(page))) {
+				bad_page(page, "page_pool leak");
+				return false;
+			}
 		}
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch
mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch

