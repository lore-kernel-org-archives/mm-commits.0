Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFA21C160
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962096; cv=none; b=fqWDcAht4GXqI6c+qnpgLeViBsBQUgPGmLCqtgHMB36WqzNE6IgqAv4sHYtzJl2itru4oX6i0sJljgERBH5/XidDMT7sxviB3F72DDaSD4ckSuf6zpWonJpjGLF31yWiXtDU2DTfK+rXnHJO17m4GJy6HGq5w22eJElANoZQjm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962096; c=relaxed/simple;
	bh=2Ps72OZM7Sj9hYYkUJ+ZHoCxsy203BwSZA2KbTmLw9Y=;
	h=Date:To:From:Subject:Message-Id; b=sG8E6f+XY8kgRTweR95wAZN3LUixOFjNm2Adi0H1jtEiIzEhoATYOZtXqLOOegQrBtPQP0XljXNG2rWTVgNUt3lIE8iLOKyrsybWF/R34bKs6ifqTIFwNqOHB1jPvDQYJUCQ63bkbdaDUwdyGfmabamIeY5DzZIAKV9usrsEJ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gn0gQQTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gn0gQQTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A574C4CEED;
	Tue, 12 Aug 2025 01:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962095;
	bh=2Ps72OZM7Sj9hYYkUJ+ZHoCxsy203BwSZA2KbTmLw9Y=;
	h=Date:To:From:Subject:From;
	b=Gn0gQQTERChSXIL6XH4MrkrRYixWWQ+iOUSZqGINx2XA9jXE69RXFeD04IRL9R/u0
	 Olgq/R8Yo43J7Qq2yk+LRM3v4Ut/EHfIFrrZzysp8d3G1f+s+bwUoWUMws1EC7h7vZ
	 RIwMe66Rc0iVR329zwyxR+oNZbSUxR2IEMC4dgtk=
Date: Mon, 11 Aug 2025 18:28:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,dev.jain@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch added to mm-unstable branch
Message-Id: <20250812012815.7A574C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: fix typo: s/sz_trtied/sz_tried/
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: docs/mm/damon/design: fix typo: s/sz_trtied/sz_tried/
Date: Sun, 10 Aug 2025 12:25:47 -0700

There are some typo in statistics section of DAMON design docs
- sz_trtied -> sz_tried

Link: https://lkml.kernel.org/r/20250729144414.31958-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried
+++ a/Documentation/mm/damon/design.rst
@@ -689,7 +689,7 @@ DAMOS accounts below statistics for each
 scheme's execution.
 
 - ``nr_tried``: Total number of regions that the scheme is tried to be applied.
-- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
 - ``nr_applied``: Total number of regions that the scheme is applied.
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch

