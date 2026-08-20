Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B451AC44D
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787194534; cv=none; b=um0Ah4PcAsbMIKoPReJ40y+3TTXVXn6hNZBVSToEdiOwoNhFhqWXEyn110vsPI10Qn8dz8zO7A1yuVzK40iy77ZBNjC5kVdxV0XpQHDQP38DL4b1RA/Vj/SMHTn77nKjEBGKK5WjRL0VrBZx4Ebc9Fv/oXFN0gyivTucD8Mxx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787194534; c=relaxed/simple;
	bh=mfYrdXlB/FEmo64J/OfHYQcKQGkFym20SuHJwQOb1gw=;
	h=Date:To:From:Subject:Message-Id; b=AUym5lb7WY74LyB9L4zXemBlQFjKFk7UlAGUwQuUQxlAxO/8gNSt/kYAJTQDVPa+Ipnu+nCv1aDOXcits7rmNKPvdXALcyY78g46jdvGfE9b+FwA3g8KjtI593h6bkXyXDHBJA/hUNsFvw6AcqiuCvXzJirZiaqwCua2WYPaGWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hb4iyMnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hb4iyMnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EC1F000E9;
	Thu, 20 Aug 2026 02:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787194533;
	bh=4Xe3jBbMv986OzdH3LV96eiyXdR8bDl6BhbIIid+r/s=;
	h=Date:To:From:Subject;
	b=hb4iyMnW57lk3U0ktxzdfyp4PV12bTKa9B4U1QtSuyxQXwrIxLWcVS8X7jiJeRMz1
	 pezHr3HgvdSYodX6BuCrirKf1mz59bQOls4HJ0k1xUYsy8AUgnA+VTqprXyI+ah5y/
	 R7AY3bk7fz+wviW1hTIoHoXoz0wiD0GD3/ICyZDo=
Date: Wed, 19 Aug 2026 19:55:32 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree-fix-allocation-warning-messages.patch removed from -mm tree
Message-Id: <20260820025533.019EC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/interval_tree: fix allocation warning messages
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-fix-allocation-warning-messages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: lib/interval_tree: fix allocation warning messages
Date: Sat, 8 Aug 2026 14:36:08 +0200

WARN_ON_ONCE() takes a condition, not a message.  The string literals are
always true, so the warnings still trigger but the messages are never
printed.

Use WARN_ONCE(1, ...) instead to print the messages and keep the once-only
behavior.

Found with a Coccinelle script.  Clang's -Wstring-conversion also flags
such calls but is not enabled in kernel builds.

Link: https://lore.kernel.org/20260808123608.73613-1-kmehltretter@gmail.com
Fixes: 82114e45131f ("lib/interval_tree: add test case for interval_tree_iter_xxx() helpers")
Assisted-by: Claude:claude-fable-5 coccinelle
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/interval_tree_test.c~lib-interval_tree-fix-allocation-warning-messages
+++ a/lib/interval_tree_test.c
@@ -140,13 +140,13 @@ static int intersection_range_check(void
 
 	intxn1 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn1) {
-		WARN_ON_ONCE("Failed to allocate intxn1\n");
+		WARN_ONCE(1, "Failed to allocate intxn1\n");
 		return -ENOMEM;
 	}
 
 	intxn2 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn2) {
-		WARN_ON_ONCE("Failed to allocate intxn2\n");
+		WARN_ONCE(1, "Failed to allocate intxn2\n");
 		bitmap_free(intxn1);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch

