Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01A91C14
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720726299; cv=none; b=sNGo58GhtliMLshS49JSG4nqhTdChyQN47o5Ft6KyGIIK8gEgF9Sh2j5spE1uwDf9iPPzCpFCe0Wf6pONE0214cJye8/1E34s9phK0PmWVcgfUIaWzIafY1n9FlYvdpVUIIbWinWTinn9i6QnV0Dc6SysPnxYVi/HnaNJm3PnrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720726299; c=relaxed/simple;
	bh=PRmdlWVzJeymaopi/jWJu/plSfkSl1z5UYq60Jf1qIM=;
	h=Date:To:From:Subject:Message-Id; b=pT8K6AjFkLAPtJS2QR3de6RaHctLlne7ZKlbEzXPZklDPA4D/m5x9hDVMhsleycVa3LZjMnZ88BJ7GYJIU4fgb42rAckQyU5scFSAjqPKAhILWsGXojEHKzF+pB0I5S/efztWs4xsrb3bFuoMX1+ktWvqJvT92JR6ZfaywLSt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8SqRTg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8SqRTg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72CEC116B1;
	Thu, 11 Jul 2024 19:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720726299;
	bh=PRmdlWVzJeymaopi/jWJu/plSfkSl1z5UYq60Jf1qIM=;
	h=Date:To:From:Subject:From;
	b=L8SqRTg77jf7BBdwR/4EBVqmhhNvC9dRCy/twBypCxbDWS4VivES/oh+k3IF29KLL
	 8wogg7gtoXjAsIfqmGnaQ8pNXvo1G9L1DiQAD8dWsQ+gZBzP1DngL2sA7gMoh11i/U
	 xowVv6jndj7Av3T/NyRCCASMq5asO2XhkMmV/mvE=
Date: Thu, 11 Jul 2024 12:31:38 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,dan.j.williams@intel.com,peili.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ignore-data-race-in-__swap_writepage.patch added to mm-unstable branch
Message-Id: <20240711193138.E72CEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ignore data-race in __swap_writepage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ignore-data-race-in-__swap_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ignore-data-race-in-__swap_writepage.patch

This patch will later appear in the mm-unstable branch at
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
From: Pei Li <peili.dev@gmail.com>
Subject: mm: ignore data-race in __swap_writepage
Date: Thu, 11 Jul 2024 09:32:30 -0700

Syzbot reported a possible data race:

BUG: KCSAN: data-race in __swap_writepage / scan_swap_map_slots

read-write to 0xffff888102fca610 of 8 bytes by task 7106 on cpu 1.
read to 0xffff888102fca610 of 8 bytes by task 7080 on cpu 0.

While we are in __swap_writepage to read sis->flags, scan_swap_map_slots
is trying to update it with SWP_SCANNING.

value changed: 0x0000000000008083 -> 0x0000000000004083.

While this can be updated non-atomicially, this won't affect
SWP_SYNCHRONOUS_IO, so we consider this data-race safe.

This is possibly introduced by commit 3222d8c2a7f8 ("block: remove
->rw_page"), where this if branch is introduced.

Link: https://lkml.kernel.org/r/20240711-bug13-v1-1-cea2b8ae8d76@gmail.com
Fixes: 3222d8c2a7f8 ("block: remove ->rw_page")
Signed-off-by: Pei Li <peili.dev@gmail.com>
Reported-by: syzbot+da25887cc13da6bf3b8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da25887cc13da6bf3b8c
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/page_io.c~mm-ignore-data-race-in-__swap_writepage
+++ a/mm/page_io.c
@@ -382,7 +382,12 @@ void __swap_writepage(struct folio *foli
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, wbc);
-	else if (sis->flags & SWP_SYNCHRONOUS_IO)
+	/*
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
+	 * is safe.
+	 */
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
 		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
 		swap_writepage_bdev_async(folio, wbc, sis);
_

Patches currently in -mm which might be from peili.dev@gmail.com are

mm-ignore-data-race-in-__swap_writepage.patch

