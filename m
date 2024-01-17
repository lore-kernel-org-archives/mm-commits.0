Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927DE250F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524925; cv=none; b=auBhEslDPK5q7yKLpWL2h0JQucsJMejZpSrNecG0M9h1TPhsxv3MQaN8HqoyuuJKdDHbBu9iabbIF+gbhY5W7oaMOvUO4/3/iVo0mIMyqV6tDOhWXbSWWQab/Dvd5VqTnRF17SsxnKE/cdunJ2V3Du8Kdvgc8B1D5BpM+JKqBWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524925; c=relaxed/simple;
	bh=8jdEu6SmyibsclIUe2axoBclr5EOB574fh4MxtTR+xw=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=VZzW+HMqfmTfV8KMmIokZ1/v9cSeVl6JV1q4BSUrC4L7SW8AuvILEI1pZaGrGTvw3s7YugPjsEwbYxXuoTRrH5OeIMDy+K9T+xcx/8NLgTrJP68MvSQLCMuJKhh6DInWmuTU9eHoCl8FuQtmID6F83lKxv7j9QEP894TQb4xUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o936++Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o936++Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B76C433F1;
	Wed, 17 Jan 2024 20:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524924;
	bh=8jdEu6SmyibsclIUe2axoBclr5EOB574fh4MxtTR+xw=;
	h=Date:To:From:Subject:From;
	b=o936++AdL9RMcejD+a9YNhPObgGU82uEaGOp9bEqrNb15t3rWEnzVI0Q+7dEW3+PV
	 J32n8uke1QBCDBb1N9iYOxqkLVwpAtXhdrhhPmtVqvCsS/dCoh0EuPtn/FB+KI3dto
	 LbNVBdXWDy1TwwHv2KWGlhecC+qGwuqDpF8yS8p8=
Date: Wed, 17 Jan 2024 12:55:21 -0800
To: mm-commits@vger.kernel.org,alx@kernel.org,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-man-pages-git-trees.patch added to mm-hotfixes-unstable branch
Message-Id: <20240117205523.A6B76C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add man-pages git trees
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-man-pages-git-trees.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-man-pages-git-trees.patch

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
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: add man-pages git trees
Date: Wed, 17 Jan 2024 13:22:57 +0100

The maintainer uses both.

Link: https://lkml.kernel.org/r/20240117122257.2707637-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Alejandro Colomar <alx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-man-pages-git-trees
+++ a/MAINTAINERS
@@ -12832,6 +12832,8 @@ M:	Alejandro Colomar <alx@kernel.org>
 L:	linux-man@vger.kernel.org
 S:	Maintained
 W:	http://www.kernel.org/doc/man-pages
+T:	git git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
+T:	git git://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git
 
 MANAGEMENT COMPONENT TRANSPORT PROTOCOL (MCTP)
 M:	Jeremy Kerr <jk@codeconstruct.com.au>
_

Patches currently in -mm which might be from pvorel@suse.cz are

maintainers-add-man-pages-git-trees.patch

