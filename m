Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEFE24468C
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779209152; cv=none; b=XAW4mPuppAmokvSx74b6zL401eAGcE4ZmjCBzq5vAEeLEPC0/tvsQb8pwdT4/El9IGgastQo7xTzNYEdIRHObEymWMnNAM3mp5k3gwkVN67b4mKjA+416Yi5yvi0Izh/8lwhFa5cTd44g7MV10RuCl/CnKyACxb2kLqEDaBSotk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779209152; c=relaxed/simple;
	bh=mSz0UBCAiS2WmigpvHf3grxTlWrSsm3l8yL0kCq6KAw=;
	h=Date:To:From:Subject:Message-Id; b=cB3LxOSAdgSvUCu+ChR/bDgydSDfsbBGZexisJY6JOwUJ6fj2UCYjMNz2i1f1eav82M+VT319Wmnko91xPKH3CKaLWrGOXTR6P0Yh4ErR+3HAalp+q9KlTF1Sm4KihGH7EmRSEIDGw2I9pDersViIS366JI9aPR219EycD+4zgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G7QTjqEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G7QTjqEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C510C2BCB8;
	Tue, 19 May 2026 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779209151;
	bh=mSz0UBCAiS2WmigpvHf3grxTlWrSsm3l8yL0kCq6KAw=;
	h=Date:To:From:Subject:From;
	b=G7QTjqEOiuzBSqv+ExxjC7MDh32MtCi5TYe66nvXf9boHJb2Aiy0nQ59B41sJGr2b
	 DWVvfWOU2w+9bbiG8LQktT7ZHHVc886EzA2nzLZjTCOrdUHWFzwzlXlSEymxUmIoGu
	 a88LZcMhQHkQTX0rZP9hoDdbnB+xHJ0coo1N837s=
Date: Tue, 19 May 2026 09:45:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,ast@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch added to mm-unstable branch
Message-Id: <20260519164551.8C510C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: document that alloc_pages_nolock() uses RCU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: document that alloc_pages_nolock() uses RCU
Date: Tue, 19 May 2026 14:17:58 +0000

The allocator interacts with cgroups which rely on RCU.  RCU does not work
everywhere, so the "any context" claim is slightly overstated here.

This should already be enforced by objtool, since this function is not
marked noinstr the x86 build should fail if you call it from a place where
RCU is not watching.  But, expecting readers to make that connection for
themselves seems a bit cruel (I don't think there is even any
documentation of what noinstr means at all, let alone the connection with
RCU).

Note this is not claiming that any cgroup code called from the allocator
would actually break if this restriction was violated, it could very well
be that there's no real way for the allocator to act on a cgroup that can
disappear concurrently.  But, since it's likely nobody has verified this
one way or another, better to just be safe and declare that RCU is
required.  Allocating from an RCU-unsafe context seems a bit crazy anyway.

Link: https://lore.kernel.org/20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Junaid Shahid <jackmanb@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu
+++ a/mm/page_alloc.c
@@ -7937,8 +7937,8 @@ struct page *alloc_frozen_pages_nolock_n
  * @order: allocation order size
  *
  * Allocates pages of a given order from the given node. This is safe to
- * call from any context (from atomic, NMI, and also reentrant
- * allocator -> tracepoint -> alloc_pages_nolock_noprof).
+ * call from any context where RCU is watching (from atomic, NMI, and also
+ * reentrant allocator -> tracepoint -> alloc_pages_nolock_noprof).
  * Allocation is best effort and to be expected to fail easily so nobody should
  * rely on the success. Failures are not reported via warn_alloc().
  * See always fail conditions below.
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch

