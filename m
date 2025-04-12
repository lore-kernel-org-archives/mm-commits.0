Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D781DDE9
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417995; cv=none; b=Gdp1ADvYIOPxE1owvgo+qAlt5tBFmpntjm0PC5fmb92M1zIrRrwC0KkUb/a8cgkzvNC7wHC08rw6XRei7dxYhoE5TlhTq/qCqOp9uPyfRVqdIH0r5dCwRJFiPGnOjaEYgA2xmarBKPYz86U4EqilkBP7uc80tZgtfFffxw/E9e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417995; c=relaxed/simple;
	bh=qZ0CyiWLXGWrygVkSZ6eJxDZu625ZnZcZT2At44hQaY=;
	h=Date:To:From:Subject:Message-Id; b=JV7RJncBIb9dp0mEbA4HJjwQ29M33SJjq7d8DjHKqa5dgPQafWy7oGs4kCBjV2PDBauqciIy4+HBB/vjhcjWcgu62FnPBM439DGjBgCWfFfPQppVBLREftBCJmw3eJl52hTg8Szp1M+S1f97c7a9VrlVHxhxL4N95tMPlum9Omk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUE6Z+H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUE6Z+H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34197C4CEE2;
	Sat, 12 Apr 2025 00:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417995;
	bh=qZ0CyiWLXGWrygVkSZ6eJxDZu625ZnZcZT2At44hQaY=;
	h=Date:To:From:Subject:From;
	b=AUE6Z+H+TRhH9DN7FFd+hI+ktlRmmOvXKo16pPALTp8BXfmtKYEcvDaWoM+lJ+2yg
	 WDQBniMDMkW6Who6A4zbu1ZJO86kjxVmK6lwQ/qYuEdAEu8Ph4iU7DnUmeF5IQwstv
	 +yFfV+iytpBLv0NCVZZ9D5HNK5JqOUQ3ISCrt4mA=
Date: Fri, 11 Apr 2025 17:33:14 -0700
To: mm-commits@vger.kernel.org,jeffxu@chromium.org,takumaw1990@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mseal-fix-typo-and-style-in-documentation.patch removed from -mm tree
Message-Id: <20250412003315.34197C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal: fix typo and style in documentation
has been removed from the -mm tree.  Its filename was
     mseal-fix-typo-and-style-in-documentation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Takuma Watanabe <takumaw1990@gmail.com>
Subject: mseal: fix typo and style in documentation
Date: Tue, 18 Mar 2025 20:55:19 +0900

Correct a typo in the mseal documentation.

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


