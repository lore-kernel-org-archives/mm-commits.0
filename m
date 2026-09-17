Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693EE2F39C7
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 04:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789618817; cv=none; b=IHInWnhLPK44+W1bm0ZQtaDz0KhJcI9KrLAyeerswdOafQTfgsPOwu7xOKB98h0b08qu57DPknCRRwXsjqVctgDNObRG23uNPolB18ocEiK1snkhhXEIWYp8PO2uW6xsEhplm+1ZLuAx5oS/qszWY0ISMCZKzzoHC8gfEd5K0NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789618817; c=relaxed/simple;
	bh=/YbbwZV7ReZcGOPpuYxxmIJn3hNNHlBxAEr79Aaw7Kw=;
	h=Date:To:From:Subject:Message-Id; b=jaAWwA2vv2RFmbUfdgxz6GoV9gIrnni9uvVq6AFask00tIQMt8rmKzcwEX5vifzJB/An79HRvrCwJQMHBSxlIZqFBWEX6FHv3qaRps0vVEbolqAp3aUb3aX53hdfM7babbrUk9o8WjgHdysVW+haCFHr4Td3SU5O5D2iLdpLvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWV4X/pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWV4X/pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CEF1F000FF;
	Thu, 17 Sep 2026 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789618815;
	bh=M68vzH7qdMByt6ovk49AVt73qlpf69fVsTG6SUz0Jqw=;
	h=Date:To:From:Subject;
	b=uWV4X/pgsncXGTZOFJ3sTfwng8bwSMN8Jdnn3HJYiq3RmQRyPX98G03wisOd2PnM+
	 d8kmM555qhNgP6fuwIrc9+iaW6MR+UJB9l6bklbBePeAWMwQS/2nRi42Tv+2hWtnR1
	 +DfCix/b7p0+9EQxh+NnUgl/lYNbDvjzmw9FvpA4=
Date: Wed, 16 Sep 2026 21:20:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch added to mm-new branch
Message-Id: <20260917042015.C5CEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
Date: Wed Sep 16 09:18:41 PM PDT 2026

fix the fix

Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -309,7 +309,7 @@ named ``0`` to ``N-1``.  Each directory
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
 filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
-``min`` and ``max`` file acts as files of the same names for :ref:`DAMOS
+``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-fix-min-signedness-mismatch.patch
mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

