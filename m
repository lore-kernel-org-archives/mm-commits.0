Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D82926CE39
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 03:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779507580; cv=none; b=m4l5sUBSRoDYnVLRvKe3KfAQBiyKGn8I+sok+5k9EgKwILruOJQh1MXqkwGsNK8/fB+Ka6cQ7C0Hj0EHHwyEQaJ95+RJdcK/EpKhqf0Su593EzAZ8y+UQPoEC7RjbvskgndlULgl1LXj4oGZuRONrOsId4ny+e8weoCXf3ovP+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779507580; c=relaxed/simple;
	bh=JzRBqCEKY0Pkq540ugCVLSJGjD2oTjP/trAufVu20N0=;
	h=Date:To:From:Subject:Message-Id; b=sPXxGzkC1b/pWCDEoVwhjogRvcublefK+SsEfuvfXX3l7mRg7bNkgjon5qlBa7VicOIRIyGdXSmMjf4vjF5q8AOX7cIlxVZ6Gh5qXtg2rnfyf6hq47jNNWYgjEzjRVljbSxcPxdNKRJpeWynsz24y8cLVrgJmCDGJNiwxTXLuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rUDxzyHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rUDxzyHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5731F00A3A;
	Sat, 23 May 2026 03:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779507578;
	bh=sPMkaLj5Ij+UmddWNEg9u8qdc01vBSm7qLvYSkpYUhU=;
	h=Date:To:From:Subject;
	b=rUDxzyHVjpCpD5FWE+4FH6dMTyggDS5uEpsZ+v/LRNAwh6PHBc/1+ioNyrfa/Apm5
	 NKxQScuY4qZg36auqblprDuMPilaEtonS6c6CZaCTYyyXcApIT+BOJID1ey0ad39RR
	 oi6/T2+9jwhJkbOPFnSB0Zi9ddr58p1ER+ixeOZ0=
Date: Fri, 22 May 2026 20:39:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,maksym.shcherba@lnu.edu.ua,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch added to mm-new branch
Message-Id: <20260523033938.CD5731F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch

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
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
Date: Thu, 21 May 2026 23:20:20 +0300

The sysfs interface for DAMON quota goals includes a `current_value` file.
This file is not updated by the kernel and only serves to receive user
input.

Clarify in the documentation that the kernel does not update
`current_value`, and that reading it only has meaning when `target_metric`
is set to `user_input`.

While at it, fix missing commas in the goal files list.

Link: https://lore.kernel.org/20260521202020.126500-3-maksym.shcherba@lnu.edu.ua
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Reviewed-by: SeongJae Park <sj@kernel.org>
Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -474,10 +474,12 @@ to ``N-1``.  Each directory represents e
 Among the multiple feedback, the best one is used.
 
 Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value`` ``nid`` and ``path``.  Users can set and
+``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
 get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Note that users should further write
+reading from each of the files.  Because the kernel does not update
+``current_value``, reading it only makes sense when ``target_metric`` is
+``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
_

Patches currently in -mm which might be from maksym.shcherba@lnu.edu.ua are

mm-damon-fix-missing-parens-in-macro-arguments.patch
docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch

