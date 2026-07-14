Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FF643550F;
	Tue, 14 Jul 2026 19:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057196; cv=none; b=R4RcaVGfP9HR0M+3Oy17QN207VjVzTL6HOkl6sUnNf8w8rME6XEuq0xdS8NqI8Kyk21RI+II7quBdM1tQo3Ef9cPudeIpotjyb6NVPtUN5KdcdKcaKIXvZUbf8RbmFdH9JMxU7tjKxzjdp0zJKS/JYU8cCFRKJtRnUZ3hTSvYys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057196; c=relaxed/simple;
	bh=DcAzajSqCunJxr0FdUfewaKosOP5X5y1kjgf0/1bfA4=;
	h=Date:To:From:Subject:Message-Id; b=n0NaytqM6Mjrl5ybxkfm3hFGGE9PTWaXrSJjKGk71Oz9cWM8zb/dY8TWLChln4+fAGWLrXZ1A95/6PHBSVBXM04x9vPeO0dsfsTOTDwoD1ku7laWtpYFellnF5W/cxyuptdMmzE990kieOLG8E2rw/HJzchYeXFlWDOWR6moMQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gG8sYcIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gG8sYcIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB351F000E9;
	Tue, 14 Jul 2026 19:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057185;
	bh=tRZl80cIL3bceruoW/T+8unND8ARGow/PrXin/lYvrc=;
	h=Date:To:From:Subject;
	b=gG8sYcIeNaqACEbyDzVtKLYDXHoCab0mHSSgpCOasxLnp9nwyIiCOJ6MtQEVv/hrl
	 xXUZscJdx75u1nSyA4vjn35+SgCZUrRRGbQRRZf/oWldxJVgSrdsggOllnxrhxWrwJ
	 Qh3UkAfOL5/7tnAyA5plbobV7GG6Hrxk6AyQHfcc=
Date: Tue, 14 Jul 2026 12:26:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch added to mm-unstable branch
Message-Id: <20260714192625.BAB351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: fix typo in intervals_goal sysfs path
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Tue, 14 Jul 2026 07:01:13 -0700

Patch series "Docs/ABI/damon: sysfs ABI document fixes and additions", v2.

This series fixes typos and fills in missing entries in the DAMON sysfs
ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).

Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in four
What: entries; the documented path points to a non-existent directory, so
it is Cc'ed to stable.

Patch 2 fixes two further typos ("WDate:", "manimum").

Patches 3 and 4 add ABI entries that exist in the kernel and are already
described in usage.rst but are missing from the canonical ABI document:
the 'update_tuned_intervals' state command (patch 3) and the
'tried_regions/<R>/probes/<P>/hits' file (patch 4).


This patch (of 4):

The ABI document spells the DAMON sysfs directory as "intrvals_goal"
(missing 'e') in four What: entries, but the kernel creates it as
"intervals_goal" (mm/damon/sysfs.c).  Following the documented path
therefore yields a non-existent directory.

Link: https://lore.kernel.org/20260714140117.94147-1-sj@kernel.org
Link: https://lore.kernel.org/20260714140117.94147-2-sj@kernel.org
Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -112,7 +112,7 @@ Description:	Writing a value to this fil
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/access_bp
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
@@ -120,7 +120,7 @@ Description:	Writing a value to this fil
 		the given time interval (aggrs in same directory), in bp
 		(1/10,000).  Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/aggrs
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
@@ -128,14 +128,14 @@ Description:	Writing a value to this fil
 		access events ratio (access_bp in same directory) within.
 		Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/min_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/max_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch
docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch
docs-abi-damon-fix-typos.patch
docs-abi-damon-document-update_tuned_intervals-state-command.patch
docs-abi-damon-document-tried_regions-probe-hits.patch

