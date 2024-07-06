Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB0C139CFC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292046; cv=none; b=q30IMsFBuGM94FePepBGCA9lhCQew1alJSZGAoW0TYFT68M+k7q3DVvW0nbm5V0gEWHYJ6V4kpDZpjrKuS+L2fYuJQV+YTxGBtrctakZ2QardBEZk83a9kqO6xLml3FcFY3WLs8mb+BupbBk6ZksaRu9ubGd4HeNMLo1WBOZofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292046; c=relaxed/simple;
	bh=FiaIL/slSoFzOvrnm2bbOt9O6SVRTYXcDy56Ta+sWso=;
	h=Date:To:From:Subject:Message-Id; b=VQcv5rwUGWrTwaSbAQf4lE2oGlcG/J5rxhuAM/UphIhmABPAYyRwXg/BfSO1+AYjGGkKDuz+efKG00HAAPZrtfUb+eMvPfM/MHq1/+kmXCWT2EDlbjDypZqANRIdSY/IncKNcx+xb98QN526bxeyfVnhi/15OAikW2rCQbg144s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NGw3hks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NGw3hks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED09C2BD10;
	Sat,  6 Jul 2024 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292046;
	bh=FiaIL/slSoFzOvrnm2bbOt9O6SVRTYXcDy56Ta+sWso=;
	h=Date:To:From:Subject:From;
	b=1NGw3hksqMFzlybXK/GY3ZzJVVsqcGxhLQ1Q3xRpKZfAuR2iCDC6jiSXrAHuoyBFR
	 LQOspJfrn7/XnhUoYAzPu7Mjzon0iKKNljIEpXviHG2I6KhYB3uEF4fVZrx+8K8FUA
	 QfwQaQ3B4suVkkXG0c9fvB4escROQpMGybHFPu84=
Date: Sat, 06 Jul 2024 11:54:05 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-two-typos.patch removed from -mm tree
Message-Id: <20240706185405.DED09C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix two typos
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-two-typos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: fix two typos
Date: Mon, 1 Jul 2024 12:26:58 -0700

Patch series "Docs/damon: minor fixups and improvements".

Fixup typos, clarify regions merging operation design with recent change,
add access pattern snapshot example use case, and improve readability of
the design document and subsystem documents index by
reorganizing/wordsmithing and adding links to other sections and/or
documents for easy browsing.


This patch (of 9):

Fix two typos.  The first one is just a simple typo: s/accurach/accuracy/

The second one is made by the author being out of their mind.  'Region
Based Sampling' section of the doc is mistakenly calling the access
frequency counter of region as 'nr_regions'.  Fix it with the correct
name, 'nr_accesses'.

Link: https://lkml.kernel.org/r/20240701192706.51415-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240701192706.51415-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-two-typos
+++ a/Documentation/mm/damon/design.rst
@@ -25,7 +25,7 @@ DAMON subsystem is configured with three
 - Operations Set: Implements fundamental operations for DAMON that depends on
   the given monitoring target address-space and available set of
   software/hardware primitives,
-- Core: Implements core logics including monitoring overhead/accurach control
+- Core: Implements core logics including monitoring overhead/accuracy control
   and access-aware system operations on top of the operations set layer, and
 - Modules: Implements kernel modules for various purposes that provides
   interfaces for the user space, on top of the core layer.
@@ -192,7 +192,7 @@ one page in the region is required to be
 interval``, DAMON randomly picks one page in each region, waits for one
 ``sampling interval``, checks whether the page is accessed meanwhile, and
 increases the access frequency counter of the region if so.  The counter is
-called ``nr_regions`` of the region.  Therefore, the monitoring overhead is
+called ``nr_accesses`` of the region.  Therefore, the monitoring overhead is
 controllable by setting the number of regions.  DAMON allows users to set the
 minimum and the maximum number of regions for the trade-off.
 
_

Patches currently in -mm which might be from sj@kernel.org are


