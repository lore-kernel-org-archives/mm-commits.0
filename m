Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC80E26A0A7;
	Tue, 24 Mar 2026 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774379914; cv=none; b=McAKqQADuGGcdO3FxEs0UqwMwWO2Jg7Z7obDJiyH0ZfB9AoG5oPQ8LOvg/La/hJ4podpM0yaYykiWVtrDKGJ+iKWPCrWnSvbhZr7w71atwx7UEwNQ63gFba0YxqP8GN9t03TQe3fwIZ+np4JJYRnsLIlco+jMZ+l9moIczvQHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774379914; c=relaxed/simple;
	bh=JPtDym5iDx7dE6u/fjL0RKrRgDH1LaMNjixVLLIe40g=;
	h=Date:To:From:Subject:Message-Id; b=Pr+4uCKG5Alhb8heu5G12Nux7zjBQpsh/2bZJGD+zVXWWpXedKLibGqlUj+krejrrBqad//Xctev/TDay/eui1Nm6/Gc871FCDpGhdrhf6wDew4gLRd9y0AS29+UvhqOjtCgBB6lHFzVtB+iYDj7qbQO9PHQdbo+EEoT5TTe9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBnuoY50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBnuoY50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3EBC19424;
	Tue, 24 Mar 2026 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774379914;
	bh=JPtDym5iDx7dE6u/fjL0RKrRgDH1LaMNjixVLLIe40g=;
	h=Date:To:From:Subject:From;
	b=fBnuoY50wISFUuR34Wqv/Jr+TIQ35WEM8RCJhpVrda5+ndfYHysx3foOxWUgPYI03
	 sVCRFzKfy9/PFDrZa/3ZUmd2ygGdYShVo0qXOiy8gDV7MbwE/aE9RqRyY7SBg1SaoF
	 DpXwGxvfhsl4rWsusS9IQYQ83eY4z3lYMa1v14jE=
Date: Tue, 24 Mar 2026 12:18:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,objecting@objecting.org,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-length-calculation-in-extract_kvec_to_sg.patch added to mm-nonmm-unstable branch
Message-Id: <20260324191834.6E3EBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: fix length calculation in extract_kvec_to_sg
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-fix-length-calculation-in-extract_kvec_to_sg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-fix-length-calculation-in-extract_kvec_to_sg.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: fix length calculation in extract_kvec_to_sg
Date: Mon, 23 Mar 2026 22:23:50 +0100

When extracting from a kvec to a scatterlist, do not cross page
boundaries.  The required length is already calculated but not used as
intended.

The previous changes to the kunit_iov_iter.c demonstrate that the patch is
necessary.

Link: https://lkml.kernel.org/r/20260323212350.807118-4-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Josh Law <objecting@objecting.org>
Tested-by: Josh Law <objecting@objecting.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/scatterlist.c~lib-fix-length-calculation-in-extract_kvec_to_sg
+++ a/lib/scatterlist.c
@@ -1247,7 +1247,7 @@ static ssize_t extract_kvec_to_sg(struct
 			else
 				page = virt_to_page((void *)kaddr);
 
-			sg_set_page(sg, page, len, off);
+			sg_set_page(sg, page, seg, off);
 			sgtable->nents++;
 			sg++;
 			sg_max--;
_

Patches currently in -mm which might be from lk@c--e.de are

lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch
lib-fix-length-calculation-in-extract_kvec_to_sg.patch

