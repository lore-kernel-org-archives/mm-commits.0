Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460261C32EB
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150133; cv=none; b=DnUen4IYXUHgSsr6cxlTzhDScl7jGpah91W08pdruBLdOuAHzArBUgwQbtT40FIfLVkYm+AAkaTub5zUhXO1k5ziUzsfMHr53YdGR3GbLY8BLee7+cK8F+3YBdhjTQNnDaRSQs2OV06g4eyqdb1pTOwbgzllJ1rcFKsP1o/8ZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150133; c=relaxed/simple;
	bh=hLdGtOG/qn7PrK0xfleMfhCBe0CNNcDzhII+GAqDzOA=;
	h=Date:To:From:Subject:Message-Id; b=N0/A7KTl0qy/D79VD8tnGmUKDVk6oy+SaagHOyi7eRPgM+pR+XiPtOMb/OWE8Ubb2oJxjY87T2S/n3XPhHEMinDnfBBj9z14SSXQvWct1XAEGIPtntHQuPD0CHp4IiKIZgB2Y9LxLY4aovDYgdM5rkyAE9FCHxph6hCuY0P2t/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FobbOvDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FobbOvDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C01EC4CEC3;
	Thu, 17 Oct 2024 07:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150133;
	bh=hLdGtOG/qn7PrK0xfleMfhCBe0CNNcDzhII+GAqDzOA=;
	h=Date:To:From:Subject:From;
	b=FobbOvDrg+2/b4no20hJ7k3ZrkLeXhAtltisjJdBK/eWaRtAW+r72IzgsqoFcsTPD
	 4fYzMzK6MZlurhqruN61vKF42ov0NveASaHqq2/pIjhCqNGWg7rfneHm6CPqX1KaqV
	 qOsS3q7EKAKto2VEbGDGGp/4vMxVDxGnc6S7ugTg=
Date: Thu, 17 Oct 2024 00:28:52 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-damon-maintainer-profile-add-missing-_-suffixes-for-external-web-links.patch removed from -mm tree
Message-Id: <20241017072853.1C01EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon/maintainer-profile: add missing '_' suffixes for external web links
has been removed from the -mm tree.  Its filename was
     docs-damon-maintainer-profile-add-missing-_-suffixes-for-external-web-links.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon/maintainer-profile: add missing '_' suffixes for external web links
Date: Fri, 11 Oct 2024 10:01:53 -0700

Patch series "Docs/damon/maintainer-profile: a couple of minor hotfixes".

DAMON maintainer-profile.rst file patches[1] that were merged into the
v6.12-rc1 have a couple of minor mistakes.  Fix those.

[1] https://lore.kernel.org/20240826015741.80707-1-sj@kernel.org


This patch (of 2):

Links to external web pages on DAMON's maintainer-profile.rst are missing
'_' suffixes.  As a result, rendered document is having only verbose URLs
that cannot be clicked.  Fix those.

Also, update the link texts for git trees to contain the names of the
trees, for better readability and avoiding below Sphinx warning.

    maintainer-profile.rst:4: WARNING: Duplicate explicit target name: "tree".

Link: https://lkml.kernel.org/r/20241011170154.70651-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20241011170154.70651-2-sj@kernel.org
Fixes: 2e9b3d6e2e59 ("Docs/damon/maintainer-profile: add links in place")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   38 ++++++++--------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-damon-maintainer-profile-add-missing-_-suffixes-for-external-web-links
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -7,26 +7,26 @@ The DAMON subsystem covers the files tha
 section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the mm-unstable `tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>` whenever possible and posted to
-the mailing lists.
+linux-mm@kvack.org.  Patches should be made against the `mm-unstable tree
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ whenever possible and posted
+to the mailing lists.
 
 SCM Trees
 ---------
 
 There are multiple Linux trees for DAMON development.  Patches under
 development or testing are queued in `damon/next
-<https://git.kernel.org/sj/h/damon/next>` by the DAMON maintainer.
+<https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
 Sufficiently reviewed patches will be queued in `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>` by the memory management
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ by the memory management
 subsystem maintainer.  After more sufficient tests, the patches will be queued
-in `mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>` , and finally
+in `mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_, and finally
 pull-requested to the mainline by the memory management subsystem maintainer.
 
-Note again the patches for mm-unstable `tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>` are queued by the memory
+Note again the patches for `mm-unstable tree
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ are queued by the memory
 management subsystem maintainer.  If the patches requires some patches in
-damon/next `tree <https://git.kernel.org/sj/h/damon/next>` which not yet merged
+`damon/next tree <https://git.kernel.org/sj/h/damon/next>`_ which not yet merged
 in mm-unstable, please make sure the requirement is clearly specified.
 
 Submit checklist addendum
@@ -37,25 +37,25 @@ When making DAMON changes, you should do
 - Build changes related outputs including kernel and documents.
 - Ensure the builds introduce no new errors or warnings.
 - Run and ensure no new failures for DAMON `selftests
-  <https://github.com/awslabs/damon-tests/blob/master/corr/run.sh#L49>` and
+  <https://github.com/awslabs/damon-tests/blob/master/corr/run.sh#L49>`_ and
   `kunittests
-  <https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh>`.
+  <https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh>`_.
 
 Further doing below and putting the results will be helpful.
 
 - Run `damon-tests/corr
-  <https://github.com/awslabs/damon-tests/tree/master/corr>` for normal
+  <https://github.com/awslabs/damon-tests/tree/master/corr>`_ for normal
   changes.
 - Run `damon-tests/perf
-  <https://github.com/awslabs/damon-tests/tree/master/perf>` for performance
+  <https://github.com/awslabs/damon-tests/tree/master/perf>`_ for performance
   changes.
 
 Key cycle dates
 ---------------
 
 Patches can be sent anytime.  Key cycle dates of the `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>` and `mm-stable
-<https://git.kernel.org/akpm/mm/h/mm-stable>` trees depend on the memory
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
+<https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
 management subsystem maintainer.
 
 Review cadence
@@ -72,13 +72,13 @@ Mailing tool
 Like many other Linux kernel subsystems, DAMON uses the mailing lists
 (damon@lists.linux.dev and linux-mm@kvack.org) as the major communication
 channel.  There is a simple tool called `HacKerMaiL
-<https://github.com/damonitor/hackermail>` (``hkml``), which is for people who
+<https://github.com/damonitor/hackermail>`_ (``hkml``), which is for people who
 are not very familiar with the mailing lists based communication.  The tool
 could be particularly helpful for DAMON community members since it is developed
 and maintained by DAMON maintainer.  The tool is also officially announced to
 support DAMON and general Linux kernel development workflow.
 
-In other words, `hkml <https://github.com/damonitor/hackermail>` is a mailing
+In other words, `hkml <https://github.com/damonitor/hackermail>`_ is a mailing
 tool for DAMON community, which DAMON maintainer is committed to support.
 Please feel free to try and report issues or feature requests for the tool to
 the maintainer.
@@ -98,8 +98,8 @@ slots, and attendees should reserve one
 time slot, by reaching out to the maintainer.
 
 Schedules and available reservation time slots are available at the Google `doc
-<https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`.
+<https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
 There is also a public Google `calendar
-<https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`
+<https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
 that has the events.  Anyone can subscribe it.  DAMON maintainer will also
 provide periodic reminder to the mailing list (damon@lists.linux.dev).
_

Patches currently in -mm which might be from sj@kernel.org are


