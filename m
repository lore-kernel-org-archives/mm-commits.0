Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15EAF4ED
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545872; cv=none; b=c7GtoVsM6/64pHbuYTSnuqrFagUphPDQpwWmjW4GVddD8LTpJtE1L0N4RzjBG/Cjsf3l0pz8Z5y9BPaUUwRDEtY6IIbvd/3E1e/KVYq4DEjgOVp+FmngUsKb/1uVmU+Fjrs1FdbUNJ1hyAE9bVFtGk4i511MMXTo1oE8sHgDiT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545872; c=relaxed/simple;
	bh=TNfIluLpOgXOAJyT9tcPO2nuTXzJWpGE1FIUeSSzUbI=;
	h=Date:To:From:Subject:Message-Id; b=ronwQtiGGFkqLm0QSzc8+n7+s3yeXvBPPrXmJJO6gZXBrO2X9m+cXZd5lKI4GEonDPnFIWHm+5eRZ+votUZZmudeNFNzFgHPZn2avRTdivzajtT8VqlpmO4/CPbi6B5McJ3fr1ru/iesNlEjFS3j4z6lKDeaMSLyzFwaBlmkt48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1iOCTn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1iOCTn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAF9C4CEED;
	Tue,  1 Apr 2025 22:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545871;
	bh=TNfIluLpOgXOAJyT9tcPO2nuTXzJWpGE1FIUeSSzUbI=;
	h=Date:To:From:Subject:From;
	b=V1iOCTn21SKOxnjQqg3vgNTcxtYyVsoOA3Rz2fsphCBvdzjgi+FCZ0RjEACIiB5XR
	 10mbWVaYpFyn+UFJJgBpRQRv+prxov0CdwiWom9UIAu5Kypsc4m4qV144he3BG5HiI
	 W5Oq8QyCPVaNoXmU6eKAKHQl9s8lcn1tFgc2jNWk=
Date: Tue, 01 Apr 2025 15:17:50 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-defrag_modes-retry-oom-path.patch removed from -mm tree
Message-Id: <20250401221751.6AAF9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix defrag_mode's retry & OOM path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-defrag_modes-retry-oom-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix defrag_mode's retry & OOM path
Date: Sat, 22 Mar 2025 19:21:45 -0400

Brendan points out that defrag_mode doesn't properly clear
ALLOC_NOFRAGMENT on its last-ditch attempt to allocate.  But looking
closer, the problem is actually more severe: it doesn't actually *check*
whether it's already retried, and keeps looping.  This means the OOM path
is never taken, and the thread can loop indefinitely.

This is verified with an intentional OOM test on defrag_mode=1, which
results in the machine hanging.  After this patch, it triggers the OOM
kill reliably and recovers.

Clear ALLOC_NOFRAGMENT properly, and only retry once.

Link: https://lkml.kernel.org/r/20250401041231.GA2117727@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-defrag_modes-retry-oom-path
+++ a/mm/page_alloc.c
@@ -4604,8 +4604,8 @@ retry:
 		goto retry;
 
 	/* Reclaim/compaction failed to prevent the fallback */
-	if (defrag_mode) {
-		alloc_flags &= ALLOC_NOFRAGMENT;
+	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
+		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


