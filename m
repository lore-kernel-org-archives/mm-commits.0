Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F393BE652
	for <mm-commits@vger.kernel.org>; Wed, 19 Aug 2026 03:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110143; cv=none; b=uY5XDHSATtLo+yUX+ocssdG8giEq35tskzZbFujncPlqZueaHzA4a1w+7FVJIGIdmGiug8PaKaZRq1q1F0j+BFcoTpr6aIA84vZjZuklvWpoUuUTD2OLWfTqZC+6ftlhBXnU3YaMvVRZUorBMwLmsiMC5sQPYRDiXN9HJekSGhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110143; c=relaxed/simple;
	bh=Kr1ljh5GtM2+hzFH5ujQ+jiA5Dc66cv/Wfih00vo/Bw=;
	h=Date:To:From:Subject:Message-Id; b=RNGtAJA9prZ1KGCxAZifTOJdPSi7o2aq68pul8RFf/MZYBaeZeNfcZ3ghHUUCEZwdTdGtnx1LCwjtp328sFXfSAkzf1xVQ5t/PlOp0NF83dwrKXbBuO3RSdUbQMPl3Qd+t1InYAO1C/5kCcqIt88bqtiRAiVcfNr9XiC2ew/h1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WW/w+HB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WW/w+HB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE02D1F000E9;
	Wed, 19 Aug 2026 03:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787110141;
	bh=edNOVkoG41zokzbk8cr0qJlY3sX64jqNFlTCRI6qjH4=;
	h=Date:To:From:Subject;
	b=WW/w+HB5kZt8tN7FdajQluMM/ylRKvxaFnD77LBS29/dPbQIUNUV6jhZaL0FSmXpy
	 2Nil1nafXpSos2AWAYdRHBCi8V3A2axpEb+r8dF2i/t7ZDTkpkNcTwWpbt59qUVpoy
	 uRSTjtNjniS1DC7W8BSQA/Yq/0D6/habb0VJ8YG4=
Date: Tue, 18 Aug 2026 20:29:01 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,peterx@redhat.com,foxieflakey@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch added to mm-hotfixes-unstable branch
Message-Id: <20260819032901.AE02D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: reset err to be 0 when move_pages_ptes succeeded
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded
+++ a/mm/userfaultfd.c
@@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfau
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

userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch

