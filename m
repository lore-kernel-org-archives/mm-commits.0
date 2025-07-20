Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979F208CA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976873; cv=none; b=Ce6TQZfTeRx+R03GgLK4pmV57X3F8rFqXqRQnqE5LEs+nSyESVkfh49UKLIhGHNhHbzdM8px3ryxS6gYyC5uUg8642HQ8/hykOtg24zdHJjME8DJizho3ebSWLQWWdDgRlGgy15vYtzEFuLpN1iKTEL9ofcok8KsqdqDIyqvfK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976873; c=relaxed/simple;
	bh=rrPr2k1b0ZSyXBUHMnSWEt+NAKOaYAy+ei4V3XWctW4=;
	h=Date:To:From:Subject:Message-Id; b=rgYX0LNv5xeIxmTknFZRTA7KaiumV9U62GTTHgQbTjCilGhucWS52SQT+V68V8e5UN1YdOePlfG2VGCbLhscJo8mVBsDzK9a581gug7Ci6x4tmmEZc8uSBsLg8NtxEj5s1t5nl8FTlDBuRxetEfsOWSX/lxngRMBnijtDVFLxWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBnveOfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBnveOfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D41C4CEF4;
	Sun, 20 Jul 2025 02:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976873;
	bh=rrPr2k1b0ZSyXBUHMnSWEt+NAKOaYAy+ei4V3XWctW4=;
	h=Date:To:From:Subject:From;
	b=eBnveOfz5yyaBJA8CUNOipLSAixp4bOm4BSw3gMBwHA2WNlnx2Q4mOfnuebHBQEO4
	 Fb1mw3nOhXsonH0gAE3/upvZbPrRAqNOpX2w+ZPy70z1hPU0apKC9L/9xZ6tFuEb+C
	 gJk/MCW7sC3PI0UvX6zf+Hqe7rJWicwhQ95mjOcg=
Date: Sat, 19 Jul 2025 19:01:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch removed from -mm tree
Message-Id: <20250720020113.39D41C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: update for mm-new tree
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: update for mm-new tree
Date: Sat, 5 Jul 2025 10:50:00 -0700

Recently a new mm tree for new patches, namely mm-new, has been added. 
Update DAMON maintainer's profile doc for DAMON patches life cycle, which
depend on those of mm trees.

Link: https://lkml.kernel.org/r/20250705175000.56259-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   35 ++++++++--------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-update-for-mm-new-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -7,9 +7,9 @@ The DAMON subsystem covers the files tha
 section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the `mm-unstable tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ whenever possible and posted
-to the mailing lists.
+linux-mm@kvack.org.  Patches should be made against the `mm-new tree
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ whenever possible and posted to the
+mailing lists.
 
 SCM Trees
 ---------
@@ -17,17 +17,19 @@ SCM Trees
 There are multiple Linux trees for DAMON development.  Patches under
 development or testing are queued in `damon/next
 <https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ by the memory management
-subsystem maintainer.  After more sufficient tests, the patches will be queued
-in `mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_, and finally
-pull-requested to the mainline by the memory management subsystem maintainer.
-
-Note again the patches for `mm-unstable tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ are queued by the memory
-management subsystem maintainer.  If the patches requires some patches in
-`damon/next tree <https://git.kernel.org/sj/h/damon/next>`_ which not yet merged
-in mm-unstable, please make sure the requirement is clearly specified.
+Sufficiently reviewed patches will be queued in `mm-new
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ by the memory management subsystem
+maintainer.  As more sufficient tests are done, the patches will move to
+`mm-unstable <https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and then to
+`mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_.  And finally those
+will be pull-requested to the mainline by the memory management subsystem
+maintainer.
+
+Note again the patches for `mm-new tree
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
+subsystem maintainer.  If the patches requires some patches in `damon/next tree
+<https://git.kernel.org/sj/h/damon/next>`_ which not yet merged in mm-new,
+please make sure the requirement is clearly specified.
 
 Submit checklist addendum
 -------------------------
@@ -53,8 +55,9 @@ Further doing below and putting the resu
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
+Patches can be sent anytime.  Key cycle dates of the `mm-new
+<https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_and `mm-stable
 <https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
 management subsystem maintainer.
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

