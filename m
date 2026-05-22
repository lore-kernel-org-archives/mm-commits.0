Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42525274FE3
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411508; cv=none; b=hiMz12HbJSbr/PKvLiexp9eYqveS9/6SzaSeDGVCDjxDGVR6nOzgTCvstBHH6aE/N4wgvajKZQmYdSHDGkHja0EhVkukar3HPykseQS2X9K4v8FsDNALa0PQN48oqnbKW25Nzl0UdWQ45lyUQyLehq6kHDBiO6YFE5x514IIMS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411508; c=relaxed/simple;
	bh=XNfm/2UtGnQUQmcJe+f8IY+O6cvU5JdDD18s7xVLqY8=;
	h=Date:To:From:Subject:Message-Id; b=la5w7jE6Kz2R/7u9jY4x3ranMV3x4C+HPOdlGAZeO6wulbd3O789Hj0m0iO3WOjAtOFubGnvh2XznDqlSWAgzS+cEQrcAWFCTNro2WFzTMU7/nBu/AR9FgJ+5hBo855Cfj+5+TmVhEg5nYsaNn4Icj1nhdm/NfZF3J/1rN6SIrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kE2vXZCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kE2vXZCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5421F000E9;
	Fri, 22 May 2026 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779411507;
	bh=Mm0qZ9fxtH4Wu4tjStV2SVKBOHYeIiTEYeCxFdFPSiI=;
	h=Date:To:From:Subject;
	b=kE2vXZCvbxvcbC5mcd5TT8aUrhc2Y8fNHklpeYVsBkB8LTTJh8YvDsp2r6ccevqRc
	 4jdpxkjwl2pZ4rsGK8kw4hty/NWR8/4Oitk+U3teJIh94OO1LvNnupn1ceRyPM7d/u
	 SvCkegf29BCA0V2SVlYRMC55Lr7o4vJ23MRpOkjg=
Date: Thu, 21 May 2026 17:58:26 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,niecheng1@uniontech.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,ssh1326@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-three-typos.patch added to mm-unstable branch
Message-Id: <20260522005826.DE5421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix three typos
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-three-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-three-typos.patch

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
From: Sakurai Shun <ssh1326@icloud.com>
Subject: Docs/mm/damon/design: fix three typos
Date: Tue, 19 May 2026 18:21:00 -0700

L140: "unsinged" -> "unsigned"
L371: "sampleing" -> "sampling"
L387: "multipled" -> "multiplied"

Link: https://lore.kernel.org/20260520012104.93602-3-sj@kernel.org
Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: niecheng <niecheng1@uniontech.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-three-typos
+++ a/Documentation/mm/damon/design.rst
@@ -147,7 +147,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
@@ -417,7 +417,7 @@ with theoretical maximum ``nr_accesses``
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampleing interval`` and ``aggregation
+and increases or decrease the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -433,7 +433,7 @@ The tuning is turned off by default, and
 As a rule of thumbs and the Parreto principle, 4% access samples ratio target
 is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
-to capture 64% (80% multipled by 80%) real access events (outcomes).
+to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`intervals_goal
_

Patches currently in -mm which might be from ssh1326@icloud.com are

docs-mm-fix-typo-in-process_addrsrst.patch
docs-mm-damon-design-fix-three-typos.patch

