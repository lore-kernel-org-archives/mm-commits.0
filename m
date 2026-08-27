Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6DA353A6B;
	Thu, 27 Aug 2026 20:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861310; cv=none; b=ZyTtouqzI7UuGMmjjd36y2kHwVEQ97MaivqSbi+iIrksbVGWhnFAmODH+u+sTu3pr+mKk80Za/muzvh2YdrcJsvhNF54G941IIckzTzdfuSjC4gXhBiQphqLcq3C76LxD18MhU2ZIe90q4k2dlZ4QEa7cvCcjPOgVWnKg0Hztlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861310; c=relaxed/simple;
	bh=aLNvl+PiCR2DNljdb8ZBx+3dqBERKJ039Uqiw4AE2O0=;
	h=Date:To:From:Subject:Message-Id; b=D+yRW+ryY/iE+FaTgD/D7nWlmkop5/yyg0OtwJDC1w/BwRtKKxgZKSQp47p13AruwOoM/93guWEY2nfek/Z6X71kJrujLinO/i0BYufUF7L9Z5Y+2PtFvydwoD/Fz93jMBU6pTdWaYjFyY90+9LAK/dsHuwj2gw89wS3nt6oFFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llmlWQKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llmlWQKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF451F00A3E;
	Thu, 27 Aug 2026 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861308;
	bh=1HjYwhi7HLWnfV/Nf6IEVvNyxLPFg2/4DZnZLASQuME=;
	h=Date:To:From:Subject;
	b=llmlWQKDDwIMZ08vvnUx4GGR8WWnJItmliFOW1PbHbMk8PneEUGnEa+GOMbSQYkhv
	 LHCMuDM9FYXquz/i7nq/IRlQdfZOFr/p/3J/9hcPgP66EaxQzhvdl7bdL9dzcGJ0T3
	 oQoYPgDX28e3HAmnxc1qCfbYE9s3EmhRw+SgWLkA=
Date: Thu, 27 Aug 2026 13:08:27 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,foxieflakey@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch removed from -mm tree
Message-Id: <20260827200828.3EF451F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: reset err to be 0 when move_pages_ptes succeeded
has been removed from the -mm tree.  Its filename was
     userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bryan Lim <foxieflakey@gmail.com>
Subject: userfaultfd: reset err to be 0 when move_pages_ptes succeeded
Date: Wed, 19 Aug 2026 10:08:24 +0700 (WIB)

During move_pages() operation, when move_pages_ptes() returns EAGAIN, the
error code is not cleared even after we processed it.  This leads to a
successful retry but then the same pages are retried again due to the
stale error code.  This time move fails because pages are already moved,
loop is terminated and move_pages() reports a failure.  Clear the error
code once we processes EAGAIN.

Link: https://lore.kernel.org/e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com
Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Assisted-by: ChatGPT:GPT-5.6-Luna
Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded
+++ a/mm/userfaultfd.c
@@ -2171,8 +2171,10 @@ static ssize_t move_pages(struct userfau
 		}
 
 		if (err) {
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
+				err = 0;
 				continue;
+			}
 			break;
 		}
 
_

Patches currently in -mm which might be from foxieflakey@gmail.com are


