Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB043DB332
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218138; cv=none; b=J2kt1rDtrGECWml5vCRy0AVPWg5de45v6BfNFSxAt4SOrMXiQWDgcUrFMHWsFkEoUsaWHqL7zY0qxh9cTKiwufpFmLJfBQrIQBCjgvbYCRM10UInUll7JWk+Qi/csjJ2eyk2FlCTwLJ5ivAduy+8v3r0kV1hkX2Ri4L0reFCShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218138; c=relaxed/simple;
	bh=yWEAJWoWVjA00vriAg59jVc5vYZ3qe5Zx9d8gkCeU6o=;
	h=Date:To:From:Subject:Message-Id; b=QjwKFdCWeY/H2oqpWz9mz5ejS9siWXlxzLJcvO4mgIpfq/2YNECTUqJDcaG9ZhDGwjJ/EvNZB/VGJvevntGInE+wHU+BQJYbAD/IGGEL1N7cHW6gUUhjhI3MK6hVCYT/l1/hLdcc48hY6/rrqURHtTKDko1otWMYw5VW37tTsTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJqYCiV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJqYCiV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B661F000E9;
	Mon, 31 Aug 2026 23:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218136;
	bh=ehwWHV1ZwT6/GQmuC48h1GdFQE0VAOnNfU32R3/fygI=;
	h=Date:To:From:Subject;
	b=RJqYCiV/HLmK0+5tJk5EwS7JLneMpKy4UHiLpEiGvu06sG6iFY9tJ7m//TqHaoLv2
	 S/mopBUVE8W0ZVW2vrqFUXb+HePtLTL+AuJz6zP1E9HOBSNMkVFEwNnjuulaYJwy61
	 BxOhkZnGhyz124TuGebmsNzwvbTRc0n4QVVDeaHs=
Date: Mon, 31 Aug 2026 16:15:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch added to mm-new branch
Message-Id: <20260831231536.42B661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: accurate semantics of nr_snapshots
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch

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
Subject: docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Mon, 31 Aug 2026 08:02:24 -0700

Patch series "docs/mm/damon/design: add explanation of nr_snapshots", v3.

Add an explanation of nr_snapshots to avoid misunderstandings.


This patch (of 3):

Change "tried to be applied" -> "completely tried to be applied" to
maintain consistency between the documentation and the code.

Link: https://lore.kernel.org/20260831150227.83416-1-sj@kernel.org
Link: https://lore.kernel.org/20260831150227.83416-2-sj@kernel.org
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

 Documentation/mm/damon/design.rst |    4 ++--
 include/linux/damon.h             |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-accurate-semantics-of-nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -846,8 +846,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is
+  completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
--- a/include/linux/damon.h~docs-mm-damon-design-accurate-semantics-of-nr_snapshots
+++ a/include/linux/damon.h
@@ -357,7 +357,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is completely
+ *		tried to be applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

