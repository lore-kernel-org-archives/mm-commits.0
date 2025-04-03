Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985292E339D
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 03:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650389; cv=none; b=ApXV8Am/kMkOA+Yfzv4YVttyj7glRVD318AUXSD0mktfWrjJkkGdNqFMiSFqiOb0W8Jq3rln1rpMfm14/fcbOgEhW3JBV4UoKI0iBk8fNDFmBlYSs7Iup1b21eV/mVNBipmENur0K0LvxcZn3I+QC5RCOeOLLy3rLKEiN6L/GJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650389; c=relaxed/simple;
	bh=BVqFtI4/wzBQgDXfRMuXqwmRGrwobgIjMYr4QVTaoN0=;
	h=Date:To:From:Subject:Message-Id; b=Up+BH3vjh+pJtDYIi7F+inAFy4A795GvkZut54CqGVbYy598Kbs605sQREIHLsJR9BfamGEMTVjBejG5JIVq0QASBopXdKBY0k/nQ72kzb2w/KX4DRZN5YULiwVyzWCVwoZlP3xQoV5XdWErYFn4nthCb8SbCdsWtP+22JvZEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gA2ZyUNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gA2ZyUNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE6AC4CEDD;
	Thu,  3 Apr 2025 03:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743650388;
	bh=BVqFtI4/wzBQgDXfRMuXqwmRGrwobgIjMYr4QVTaoN0=;
	h=Date:To:From:Subject:From;
	b=gA2ZyUNTa1ahf28hZKtDJukomdQBIZDJgnX3HcMKnpP/rn7cVnJ/UxAFUX+Rba0BF
	 Lijou3zYEMJMwbfJD2DJ6me6Bq57pO5DvRhg0dbsvzIWMUkBKl8/lIfDXwFRH77AwZ
	 GZb0mxjhYzpS3h2eOb+i3Ws9J4sgzK/Tjmg7xRnI=
Date: Wed, 02 Apr 2025 20:19:48 -0700
To: mm-commits@vger.kernel.org,jeffxu@chromium.org,takumaw1990@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-fix-typo-and-style-in-documentation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403031948.DDE6AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: fix typo and style in documentation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mseal-fix-typo-and-style-in-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-fix-typo-and-style-in-documentation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Takuma Watanabe <takumaw1990@gmail.com>
Subject: mseal: fix typo and style in documentation
Date: Tue, 18 Mar 2025 20:55:19 +0900

Corrected a typo in the mseal documentation.

Link: https://lkml.kernel.org/r/20250318115521.11654-1-takumaw1990@gmail.com
Signed-off-by: Takuma Watanabe <takumaw1990@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/userspace-api/mseal.rst~mseal-fix-typo-and-style-in-documentation
+++ a/Documentation/userspace-api/mseal.rst
@@ -27,7 +27,7 @@ SYSCALL
 =======
 mseal syscall signature
 -----------------------
-   ``int mseal(void \* addr, size_t len, unsigned long flags)``
+   ``int mseal(void *addr, size_t len, unsigned long flags)``
 
    **addr**/**len**: virtual memory address range.
       The address range set by **addr**/**len** must meet:
_

Patches currently in -mm which might be from takumaw1990@gmail.com are

mseal-fix-typo-and-style-in-documentation.patch

