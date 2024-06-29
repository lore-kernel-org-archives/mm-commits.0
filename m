Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CC5BA46
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628232; cv=none; b=YsZ8l818slOQTrGRpW6+nwSFao+WyK989aW1GfSPkrU9gv2T81ZpjhL1LJsaQtSjblAMbf/ReU/R4NINDsiPX1NLF6w1X6Usxq5fWEtQEsTJ4lpr5qW02uRUV+ao1BicQzfFQYvl0FaGfdfa8EteeO7HIiQIpnf/HY1EeoGOZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628232; c=relaxed/simple;
	bh=dJCsXNsCllOLT+HD7y7EUdeOtmROKalmRzhsGVGKy9A=;
	h=Date:To:From:Subject:Message-Id; b=UBWfI2Nrl08Jl2ZbSXzTsMgjPEgYWSpftmhBkqp44sEL6FRyAFbTkZ/qyxUbdVh84pxmOzfVaSPWhkdQ5xjklAGMSD6iTOy3j5Dw7oP0f8M3xTi9/FP2r80ad5/KVKVPuyFUBc4GuOg0hPR3jgWd/xkt4l+1Oubsew7YzAKF7kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4IOZbRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4IOZbRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A46DC116B1;
	Sat, 29 Jun 2024 02:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628232;
	bh=dJCsXNsCllOLT+HD7y7EUdeOtmROKalmRzhsGVGKy9A=;
	h=Date:To:From:Subject:From;
	b=P4IOZbRb0usc5QH9HKw6qL/DjcepQiaD9Gf7PCnqNpHDRj014IfFcvGK7sHwjSzf+
	 SHrciZuqZ9kMaWR4rxq73EmzqRBMTW6rN9r43DyCMJxMiaNSHPQZXp7GziRhu8F2aS
	 hzuDILDWpk9oNGMPfDdDfy/EWtPmQp9U/GLS/kzs=
Date: Fri, 28 Jun 2024 19:30:31 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-introduce-hackermail.patch removed from -mm tree
Message-Id: <20240629023032.1A46DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: introduce HacKerMaiL
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-introduce-hackermail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

