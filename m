Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9111EB5C2
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 20:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774729847; cv=none; b=LdqkiBAamm37L7pmSBqiZ88YxyTIGE1mj5Ni5JbdcR0Ww+ugKEuhUkOawptQndfV6ynxqwby5qrvckZk5OsAVydBS0BRX40cg7+kPCojJunMh6j52NnyDgt+YV1mGFLa1+Ez9ZEccjC+PxkbpkVYte62q9CRMF3U+a7Tg40TUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774729847; c=relaxed/simple;
	bh=Z36vYPOBmJISGoB9ut5JdTs85Aqd980UWTRI27bKrzg=;
	h=Date:To:From:Subject:Message-Id; b=QBi22irFK6D6BJdrlwXd6uT7MAjxFWnJ/3F6EAppMnudnxZNMP1YCfAjy8e8rhuu8PMpQsxH7TyjzrMphBkKBM3y+3uh/KJzq4yP1lrWEHGyEaqgbrsE2i4dIq0f+Nojf0NLEJcl1YaTzAh/BVRwZv9V1tyCfgiwocmcBeyDkCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLhaW/PM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLhaW/PM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163DBC4CEF7;
	Sat, 28 Mar 2026 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774729847;
	bh=Z36vYPOBmJISGoB9ut5JdTs85Aqd980UWTRI27bKrzg=;
	h=Date:To:From:Subject:From;
	b=gLhaW/PMye+hwzgIO7wB7KrsmB6Mi/a8KioNDfDA4/gLQSz0pVEA/MoJCDpzL99Vo
	 EPp3XDDNxEyvBRcE/nEvSU/QNf02t3/JvDY5GPOfvGJBVTqwm1bnWB/Uo5IAPxyq2M
	 H3bJ8gR7dIU3q838PEPUoR7WzQLPEtyc0fguFktw=
Date: Sat, 28 Mar 2026 13:30:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,toke@redhat.com,rppt@kernel.org,hannes@cmpxchg.org,david@redhat.com,asml.silence@gmail.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch removed from -mm tree
Message-Id: <20260328203047.163DBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-new-page-type-for-page-pool-in-page-type-v5.patch

This patch was dropped because it was folded into mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch

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

