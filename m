Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E6A30EF8B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303188; cv=none; b=bCfKrw2SmD6QGt87TvzM/mEBouS/5gqhMXk1msiHVckivCQMvAUxIivNyKzACwSViR+bi9HqRz2EGVQzhfznMZDb0ax49IUp6aZwxZm2T5yhyaK9AmoWD3L3JZ5CPEpJv3EBL0uC2lFMu/sL+sgS0fPc5/tTFkK+YgrqIPOOTt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303188; c=relaxed/simple;
	bh=fQuIB5oz58VX1LvtYj2Wok4xbCT/GXN27p7f62dlyXo=;
	h=Date:To:From:Subject:Message-Id; b=Y9HZButp+KJLFmccNj6WQvMbfnIBrWuoQ4V3+/oZGlcZltn+RAuramkOJtPg+KhjV/VLTapFsXmJoNLh1ET8wbKeViKCb8RORHyJez2rzpSnPOBnfceiLX3+kPA3ceukQBV/PlbZ+3F8qaKldLqxSBq40oYtVcYoL7kfmFn51xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGzDrA+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGzDrA+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65757C2BCB4;
	Mon, 27 Apr 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777303188;
	bh=fQuIB5oz58VX1LvtYj2Wok4xbCT/GXN27p7f62dlyXo=;
	h=Date:To:From:Subject:From;
	b=gGzDrA+w+kO24zuq5whFdA9hfTQ6Ex//Fd08bf+qFWgfN0RSUzxkALGDFEOORI9Of
	 Imbb6sp8yE8gy2wV4THE3L/vrPS9zQjSb4p1fAONTkSlF/IwuZBTUgoaMljmGWDaWm
	 QJsxpS2UINL5CsugEBJhh0rDDnpq82UKMyI/ssy4=
Date: Mon, 27 Apr 2026 08:19:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-pause-sysfs-file.patch added to mm-new branch
Message-Id: <20260427151948.65757C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: update for pause sysfs file
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-pause-sysfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-pause-sysfs-file.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for pause sysfs file
Date: Mon, 27 Apr 2026 08:12:24 -0700

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Link: https://lore.kernel.org/20260427151231.113429-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-pause-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch

