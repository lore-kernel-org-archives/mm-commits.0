Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B10339B5E
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676282; cv=none; b=jqOwCqsJZlyQuoumnLzLLV9PWmRxnSJzVPjRivMocDi1bN5y1wPeAoInjmlnl1gg/nISzYsze/UMGnvjJrq8fYmF8/MahP7Nzr1RcUtlfaUWpEbmpNJTCivmF5nEtTxu+KlWBKdnGDvmlva2+TGMFZ/KV8hw59USYChc4DtIq7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676282; c=relaxed/simple;
	bh=4AJXt6GqGppup/jh40aAt00VOcVeIeY5774LXP5pvIA=;
	h=Date:To:From:Subject:Message-Id; b=UavIBBYOWLvnnWpjyyOJVas9dhGD5PSWP+MzLJShnWXJD2dQX9XCfOWZd7lwe8eu0y59dZDGOZRc/FAA8jabD7/xs/ZCeYWKmE/My6AZxk2W0F20tHSOY47GFOGxA4wJ0mdHQsVIt/JPE/b/hzkTxM1vEzCB9g/7wpXQcC+9fYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjogHsSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjogHsSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED69C4CEF1;
	Thu, 20 Nov 2025 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676281;
	bh=4AJXt6GqGppup/jh40aAt00VOcVeIeY5774LXP5pvIA=;
	h=Date:To:From:Subject:From;
	b=mjogHsSayuCYVc6YjDRnZyXTU1eXaSlsE1ErNOAKOeyA0TBYca3vYFsJeYU+JQmIp
	 RlZNBAvd+fTWayu7xB8bHfCpiqj7HSfHkgOulK0rH7W///+IWIKKH0roIV6duDayFG
	 t7QPjExx/ND24fj5jifQf1Hf7VwzLo6vTY+Dv2WU=
Date: Thu, 20 Nov 2025 14:04:41 -0800
To: mm-commits@vger.kernel.org,richard120310@gmail.com,mingo@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch removed from -mm tree
Message-Id: <20251120220441.CED69C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "lib/plist.c: enforce memory ordering in plist_check_list"
has been removed from the -mm tree.  Its filename was
     revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Revert "lib/plist.c: enforce memory ordering in plist_check_list"
Date: Thu, 13 Nov 2025 19:34:13 +0000

This reverts commit 7abcb84f953df037d40fad66f2109db318dd155b.

The introduction of WRITE_ONCE() calls for the 'prev' and 'next' variables
inside plist_check_list() was a misapplication.  WRITE_ONCE() is
fundamentally a compiler barrier designed to prevent compiler
optimizations (like caching or reordering) on shared memory locations. 
However, the variables 'prev' and 'next' are local, stack-allocated
pointers accessed only by the current thread's invocation of the function.

Since these pointers are thread-local and are never accessed concurrently,
applying WRITE_ONCE() to them is semantically incorrect and unnecessary. 
Furthermore, the use of WRITE_ONCE() on local variables prevents the
compiler from performing standard optimizations, such as keeping these
variables cached solely in CPU registers throughout the loop, potentially
introducing performance overhead.  Restore the conventional C assignment
for local loop variables, allowing the compiler to generate optimal code.

Link: https://lkml.kernel.org/r/20251113193413.499309-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/plist.c~revert-lib-plistc-enforce-memory-ordering-in-plist_check_list
+++ a/lib/plist.c
@@ -47,8 +47,8 @@ static void plist_check_list(struct list
 
 	plist_check_prev_next(top, prev, next);
 	while (next != top) {
-		WRITE_ONCE(prev, next);
-		WRITE_ONCE(next, prev->next);
+		prev = next;
+		next = prev->next;
 		plist_check_prev_next(top, prev, next);
 	}
 }
_

Patches currently in -mm which might be from visitorckw@gmail.com are


