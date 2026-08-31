Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6624A3E7BBF
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218142; cv=none; b=VC00LrlE5mpZOOaqKX0H2foRiKPMekcjefHIUMflMnK9KM4adCvrwCPdlPUXpSwsQHHbXvulcg670MqmqXybUZQb51xYisf/AjA220Snttkof+woIQy3vn/36uCuIacIM10aHrQE80pWJS/ABxX1fUr38TdWrtq4z4t5VX5B//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218142; c=relaxed/simple;
	bh=yqC8zSKHHXninOM1Iz63f+tS8o8awzuR3YERRX7SDmY=;
	h=Date:To:From:Subject:Message-Id; b=QwwVZjq4ME/VfUnMS/BO4kKossYU/5TP7Yj3/t4nHlSH8tReXmg3jWfslQYYI5OOnl2V+dp8HlI8q8G32k3xQUunsIbdqYpFyLGBDGtkaI8wpV/2BiZDbhfq0PLroNrPz0qdtEUSN1QYx0vxmgXD+TeIb22M+1GhPjp9qWePryo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRMyOT9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRMyOT9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3151F000E9;
	Mon, 31 Aug 2026 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218140;
	bh=A5fkeR1JYkhdVeVnNpb/zdi4IqNe3Rfn3Xc6GHpp/l0=;
	h=Date:To:From:Subject;
	b=IRMyOT9xMVA24zgWXAqy4Z44DSipTl9IVI/hK5yIK0CSDcIbsMqmKKItWQLuW2TSN
	 1u8HoNlIQ4MwR3PkRJ7cR3dp7sMZEV0iL+qYipeAqb0G82IW3AgUN0rVt2o99ZBWxn
	 SJJ/hZBPYs2Rh4rr1ihX+5saMBJ8a9m4ou00nmno=
Date: Mon, 31 Aug 2026 16:15:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch added to mm-new branch
Message-Id: <20260831231540.CB3151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: fix typo of max_nr_snapshots
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

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
Subject: docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Mon, 31 Aug 2026 08:02:26 -0700

Fix a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Link: https://lore.kernel.org/20260831150227.83416-4-sj@kernel.org
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
 include/linux/damon.h             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typo-of-max_nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -871,8 +871,8 @@ action is ``pageout`` while all pages of
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
--- a/include/linux/damon.h~docs-mm-damon-design-fix-typo-of-max_nr_snapshots
+++ a/include/linux/damon.h
@@ -549,7 +549,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

