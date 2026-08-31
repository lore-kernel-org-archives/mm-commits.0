Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A173E2768
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218140; cv=none; b=EpqyvD0e4hVwen96JcyrB/IRnEqZ71sC3C1pYSZ5PlNvJhsZTTFGTKOHeqKvK/+oflKBQ/BgubxZrHnNSMhYX/2i3wtnr9fwS6cHjM2ii9weIrJNnieA8sn/QEr6FKtvgH1u/qfnOebNM1XQvLEomPreVD2tStU8C3WpPppwwJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218140; c=relaxed/simple;
	bh=PbmrhCQgVpyg4Q84aEXrOKEQ09q1g6BuIk/J8TGaNyo=;
	h=Date:To:From:Subject:Message-Id; b=cugSoZnRRJuKIje5DAKLqj0hyJ5jC05Gi06fb5jVX2Kv7HvAl3AB90VOZ7lSHy6Ija6DxKZboSiMm29/pmsdpNU2ZUIm3paXf0ugUNErfbfE4iKUIMyR9wJJOsjFFlyKRepur6Fz6owBpdMiRVEIj2ARUumNTBvCR7CEDR2OcBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aI7yOW5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aI7yOW5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FDF1F000E9;
	Mon, 31 Aug 2026 23:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218138;
	bh=J+x++lvGTzpNwde4MXYJKhws83KswMNbD80U5PeLhCo=;
	h=Date:To:From:Subject;
	b=aI7yOW5Jm0x+LzFz54mqR8rFZdN7qxJOn56VHnd3jiZHAXAOO86+wk0FTwG8LtIZ7
	 DAiYEzohS42jPgbISsCOFNy+OHufEZN2/6Xb8ySv8+KSa7+BOD5Lls8/+zErtVeZcM
	 fU5onSsPCcdIg1czMdw666ZTRBLbyFZ2lPiZlZCs=
Date: Mon, 31 Aug 2026 16:15:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch added to mm-new branch
Message-Id: <20260831231538.C4FDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: difference between watermarks and nr_snapshots
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Mon, 31 Aug 2026 08:02:25 -0700

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Link: https://lore.kernel.org/20260831150227.83416-3-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -872,7 +872,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

