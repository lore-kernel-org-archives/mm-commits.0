Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E87E33D6F9
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777050606; cv=none; b=AwNZqyu4OVQQ6/B94EvfbjqFwVO78eYtljo38trDxWFjMpubrpbprXCeSKl5cCCferwsd6jTQ6KPR9jWf/r17c4/sevhje9LpGz7wViPIj3zWrkfwJw4RIlVOTFG+fFe/DRNQd/xnasxmrtQFCubudCcv77PZIuBh58Oy3F7ACU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777050606; c=relaxed/simple;
	bh=WUJ/UfeKU4t4PotHi1skhEfQAOJ478w/8w4mDRN8+zY=;
	h=Date:To:From:Subject:Message-Id; b=rMLk5l65sRU70RMVDKit0HdJ57HtYfXYIZT8/LMGLev3nK0kvlMoLjtDrAy4dS5rhfGmMu/sblQai76bau7dJx2EY8GDj5297fXmHVB/Ci9UkrOokH9+DRoFjA+X5nO30OvLf6sUEqT6J0t69w0y3SEwpqufDYkeZyThkQrvfVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QMbCn9sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QMbCn9sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96147C2BCB2;
	Fri, 24 Apr 2026 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777050605;
	bh=WUJ/UfeKU4t4PotHi1skhEfQAOJ478w/8w4mDRN8+zY=;
	h=Date:To:From:Subject:From;
	b=QMbCn9sw4U5ezjIIy12SAvovZaBKNZTef9MOccw4uhDQdG28gJwZdO+axeAIw8sVq
	 x3JjAIHfHX19PL9iyG7NfOBm+r/QcZAsbX2y5rywnFjeN9rBcIJYBNtMZb5sZnszvL
	 2jTd4kJ8Pm87uYARKXmHwa0yPu5LjmGCNldaNchk=
Date: Fri, 24 Apr 2026 10:10:04 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch added to mm-new branch
Message-Id: <20260424171005.96147C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: add AI review usage guideline
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sun, 12 Apr 2026 14:19:31 -0700

DAMON is opted-in for DAMON patches scanning [1] and email delivery [2]. 
Clarify how that could be used on DAMON maintainer profile.

Link: https://lore.kernel.org/20260412211932.89038-1-sj@kernel.org
Link: https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958 [1]
Link: https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733 [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   21 ++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -100,3 +100,24 @@ There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
 that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
 provide periodic reminders to the mailing list (damon@lists.linux.dev).
+
+AI Review
+---------
+
+For patches that are publicly posted to DAMON mailing list
+(damon@lists.linux.dev), AI reviews of the patches will be available at
+sashiko.dev.  The reviews could also be sent as mails to the author of the
+patch.
+
+Patch authors are encouraged to check the AI reviews and share their opinions.
+The sharing could be done as a reply to the mail thread.  Consider reducing the
+recipients list for such sharing, since some people are not really interested
+in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
+except DAMON maintainer.
+
+`hkml` also provides a `feature
+<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
+for such sharing.  Please feel free to use the feature.
+
+It is only an optional recommendation.  DAMON maintainer could also ask any
+question about the AI reviews, though.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch
mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch
mm-damon-reclaim-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-lru_sort-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-stat-detect-and-use-fresh-enabled-value.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

