Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C91662F0
	for <mm-commits@vger.kernel.org>; Fri, 21 Jun 2024 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989434; cv=none; b=Q+rccn9ByCuwTGNShuukhryocaDx4Ky4teXPvTrG5s7fL9AEAy6QVJx5vWBZG4kia9FFzfy+UIwbVJxFXAkfZFy3+7j0TDaJ8rGKKUN5HNmPQ8P/hCc2v+u9SUbs+vFpmoWAIfA6l8whI3eAY902yqC8jZdyKa4H7gNtCW6t/p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989434; c=relaxed/simple;
	bh=ZMSALXgZ+EntDuLVivTlaUw2DEdcll6hXDE2P/247YA=;
	h=Date:To:From:Subject:Message-Id; b=aDqLskaG6Y2Lwo8v8cVmAR5aCT2+4QYNHHuw1GVlXTQTV1QFz/93YHyC4PMxkuCt00PBux+szL0pr1X2N8uR6WqNXNZwH1ZbpPwPd0weDxp+WZ1fylnm3G7ko73Ol6frkrts5riRfCoCUqAxaJkxNrkTDBScdU4zfXBEv98oAPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bzykD5b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bzykD5b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB83C2BBFC;
	Fri, 21 Jun 2024 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718989433;
	bh=ZMSALXgZ+EntDuLVivTlaUw2DEdcll6hXDE2P/247YA=;
	h=Date:To:From:Subject:From;
	b=bzykD5b0Sw7XQL0s44hA6gU5yt1YnWSruHftkBsRakqwp6lQfX4ZD1UG55ftdP32I
	 6rJGsDBQVBfrJ9CjIbWTiYKlBDKiQQWVp2o81OEzKCIkRR4RQTQdi5PeLreXuFGRJY
	 NkLBweMBQsgGPztdswyXyGtKO1Xy2TZVOUs/cVDc=
Date: Fri, 21 Jun 2024 10:03:53 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-introduce-hackermail.patch added to mm-unstable branch
Message-Id: <20240621170353.BFB83C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: introduce HacKerMaiL
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-introduce-hackermail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-introduce-hackermail.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: introduce HacKerMaiL
Date: Fri, 21 Jun 2024 09:36:25 -0700

Patch series "Docs/mm/damon/maintaier-profile: document a mailing tool and
community meetup series", v2.

There is a mailing tool that developed and maintained by DAMON
maintainer aiming to support DAMON community.  Also there are DAMON
community meetup series.  Both are known to have rooms of improvements
in terms of their visibility.  Document those on the maintainer's
profile document.


This patch (of 2):

Since DAMON was merged into mainline, I periodically received some
questions around DAMON's mailing lists based workflow.  The workflow is
not different from the normal ones that well documented, but it is also
true that it is not always easy and familiar for everyone.

I personally overcame it by developing and using a simple tool, named
HacKerMaiL (hkml)[1].  Based on my experience, I believe it is matured
enough to be used for simple workflows like that of DAMON.  Actually some
DAMON contributors and Linux kernel developers other than myself told me
they are using the tool.

As DAMON maintainer, I also believe helping new DAMON community members
onboarding to the worklow is one of the most important parts of my
responsibilities.  For the reason, the tool is announced[2] to support
DAMON community.  To further increasing the visibility of the fact,
document the tool and the support plan on DAMON maintainer's profile.

[1] https://github.com/damonitor/hackermail
[2] https://github.com/damonitor/hackermail/commit/3909dad91301

Link: https://lkml.kernel.org/r/20240621163626.74815-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240621163626.74815-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   17 ++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-introduce-hackermail
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -53,6 +53,22 @@ Mon-Fri) in PT (Pacific Time).  The resp
 slow.  Do not hesitate to send a ping if you have not heard back within a week
 of sending a patch.
 
+Mailing tool
+------------
+
+Like many other Linux kernel subsystems, DAMON uses the mailing lists
+(damon@lists.linux.dev and linux-mm@kvack.org) as the major communication
+channel.  There is a simple tool called HacKerMaiL (``hkml``) [8]_ , which is
+for people who are not very familiar with the mailing lists based
+communication.  The tool could be particularly helpful for DAMON community
+members since it is developed and maintained by DAMON maintainer.  The tool is
+also officially announced to support DAMON and general Linux kernel development
+workflow.
+
+In other words, ``hkml`` [8]_ is a mailing tool for DAMON community, which
+DAMON maintainer is committed to support.  Please feel free to try and report
+issues or feature requests for the tool to the maintainer.
+
 
 .. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
 .. [2] https://git.kernel.org/sj/h/damon/next
@@ -61,3 +77,4 @@ of sending a patch.
 .. [5] https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh
 .. [6] https://github.com/awslabs/damon-tests/tree/master/corr
 .. [7] https://github.com/awslabs/damon-tests/tree/master/perf
+.. [8] https://github.com/damonitor/hackermail
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch
docs-damon-document-damos_migrate_hotcold-fix.patch
mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

