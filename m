Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57246257844
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485532; cv=none; b=HhzzYJ6HoUX4kSc6gDmwf8XxNg2Nqnr+7b8060TX/IJyx/bf/6ZsDdTr5pJqtLJGzx5WYZqksT9CM7SE/M4uQwTZ18ySMWXfb6ZtIEblzWkEQ+uwVL9i32jvVMpnAKJhmgXAnPUnN+BZIcFzgIAyTC4tBsZdS8cEHXDYat0N7NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485532; c=relaxed/simple;
	bh=z4vyn9WFG0hZTzfUL0NXsgUyy3okQF2DUGWON9cNKJA=;
	h=Date:To:From:Subject:Message-Id; b=sr61Uek25HcKAVHn9i0ea1jQ+PIvkoi/EjQbvl2qSc4oqjYVbx0/5mxGbC5vs9F0PZu7yPxQdCwqkidaC9ny9W4YQ8tjiC2yA2qlVQzePPdD3xLmRx9o240BqD1IbvL1aT9fJgHpRHwfeHYa1llhcZiDDkupg5ld4g6yE9jog2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QaZaIpkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QaZaIpkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD94C4CEEB;
	Mon, 18 Aug 2025 02:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755485531;
	bh=z4vyn9WFG0hZTzfUL0NXsgUyy3okQF2DUGWON9cNKJA=;
	h=Date:To:From:Subject:From;
	b=QaZaIpkHXOSQH/M83rfjQYmLjg72saPO5AucT8gKFkM3n2fryNvkl69HDmw2jr6NL
	 atwtp5qcoRP9frEPSu1zXyLxQPSAfl6/G2sJ/jHLcr7ptlzv4zXv9+BzgNjcSHAhR6
	 s4q/MnYwWZIpmjIKdCVx20HMRHkvoHUP2tZ90pdk=
Date: Sun, 17 Aug 2025 19:52:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,ryan@lahfa.xyz,maximilian@mbosch.me,dhowells@redhat.com,ct@flyingcircus.io,brauner@kernel.org,arnout@bzzt.net,asmadeus@codewreck.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch removed from -mm tree
Message-Id: <20250818025211.AFD94C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: iov_folioq_get_pages: don't leave empty slot behind
has been removed from the -mm tree.  Its filename was
     iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominique Martinet <asmadeus@codewreck.org>
Subject: iov_iter: iov_folioq_get_pages: don't leave empty slot behind
Date: Wed, 13 Aug 2025 15:04:56 +0900

After advancing into a folioq it makes more sense to point to the next
slot than at the end of the current slot.  This should not be needed for
correctness, but this also happens to "fix" the 9p bug with
iterate_folioq() not copying properly.

Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-0-a0ffad2b665a@codewreck.org
Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-2-a0ffad2b665a@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Acked-by: David Howells <dhowells@redhat.com>
Tested-by: Arnout Engelen <arnout@bzzt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Theune <ct@flyingcircus.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maximilian Bosch <maximilian@mbosch.me>
Cc: Ryan Lahfa <ryan@lahfa.xyz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/iov_iter.c~iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind
+++ a/lib/iov_iter.c
@@ -1032,9 +1032,6 @@ static ssize_t iter_folioq_get_pages(str
 			maxpages--;
 		}
 
-		if (maxpages == 0 || extracted >= maxsize)
-			break;
-
 		if (iov_offset >= fsize) {
 			iov_offset = 0;
 			slot++;
@@ -1043,6 +1040,9 @@ static ssize_t iter_folioq_get_pages(str
 				slot = 0;
 			}
 		}
+
+		if (maxpages == 0 || extracted >= maxsize)
+			break;
 	}
 
 	iter->count = count;
_

Patches currently in -mm which might be from asmadeus@codewreck.org are

iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch

