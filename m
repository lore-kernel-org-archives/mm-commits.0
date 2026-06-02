Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF553B9610
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439062; cv=none; b=F2BF35ikvfO5ipBeMMB92vZ46mQpXJTQAs94bDGKelWHAUITmtj3eSlD6F1zQ7vSEqSvBQhkB8FmuJ1rQQsGIc5fM0xHc+KZmZd3z+lncNupM+UNRhwpdETYfZuD8Tp1Toiqiivp9wwGD6xfuGa1tqNTY977gDUpNHv4d7EUoj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439062; c=relaxed/simple;
	bh=AcyQlEndWnmQaX/FBbeEMToMvyBMO9JhL9SiEobl3qI=;
	h=Date:To:From:Subject:Message-Id; b=eO+w9dEt8AADapWhhRjiwXJVCkXxKWtcldL6ddNXQkkjLRewyfQHFgwRP4FIm0zmvpMwkeXbj//zUXTqciYuU7QVrpMlzy7dBYSafZYDJ6WKMXbnNkNFIymJEy6ItI8NsK2tltFbudCDbAFv3aFGZTKsoGfEY7TJngmcddT+9ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bG1DDBMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bG1DDBMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645C01F00893;
	Tue,  2 Jun 2026 22:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439061;
	bh=6sJs3NMWWQwNl3PtG+ZOhYxMJgl+ex8IzewdzIvbyik=;
	h=Date:To:From:Subject;
	b=bG1DDBMFMb/gSMT5zYJv3b6TxeXsMezAuKJ3atIeRpGWzu2JmJdrT9X7AJK9Jc+PY
	 cMytF8bw5MWfL/IfojyU8lmpHG76UVauT80/JvAwedaEZxPt13HfugdIvOFsqxtyk8
	 LK++jsH9fBQrBLox4qBk3CqbcM4N3F7oI5cSKF34=
Date: Tue, 02 Jun 2026 15:24:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,junaids@google.com,harry@kernel.org,hannes@cmpxchg.org,ast@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch removed from -mm tree
Message-Id: <20260602222421.645C01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: document that alloc_pages_nolock() uses RCU
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Suggested-by: Junaid Shahid <junaids@google.com>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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

mm-delete-stale-comment-about-cachelines.patch

