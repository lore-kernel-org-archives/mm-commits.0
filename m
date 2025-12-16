Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E902D46B2
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911495; cv=none; b=OGskw55PUNybC2/tB95RHnNQPHychfHZP+N/Dn8NpR9lkfh9uT+Di0B3q1bjLit7QWZ6tDtxDLUfgRg89MEY5cngkgBlAOv7dJ5tJmerzhl7PirbkcWNjjluyBukA4Grvuq3bU0t0bISMwsQVmfdewwuRdFUeUiSHpf0GmkNe3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911495; c=relaxed/simple;
	bh=paSxXICW2D6MSk8WnE/G39Sw3+W5IguoaovyNzyRnCQ=;
	h=Date:To:From:Subject:Message-Id; b=ubxuebdLkpUrUsTFgHra1hzs1EUtlOfVgElKxcHrAizBX5v42MOgsK6AlPcFetdHeUj6aL0sVOJYGo4bSb9AEpZ4gk3t4Tf3/cBpNiZbPLiJD27ePlRrk4l+yt2u8ovLziuL3LLIF5tczpY3bA4/eqNsihVMTeTeh0+rDZl6OYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+G+S3fz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+G+S3fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EADC4CEF1;
	Tue, 16 Dec 2025 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911495;
	bh=paSxXICW2D6MSk8WnE/G39Sw3+W5IguoaovyNzyRnCQ=;
	h=Date:To:From:Subject:From;
	b=u+G+S3fz8IqEleolSuRGyUa6g6kcUfubU4jgOKmTJochmCe7s9r3Zqtu6crAN95Rm
	 4lzBauM/loKGfFNx1tmbvb2SHqIYoj7OufAVjsJSGDK3R1pKNZpfmcKVXE6gZlJmQO
	 uWFuHFqU0eYz2pMPNZyIOBRauEJ8TWhl6aHnOV6M=
Date: Tue, 16 Dec 2025 10:58:14 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-update-damos-kerneldoc-for-stat-field.patch added to mm-new branch
Message-Id: <20251216185815.20EADC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: update damos kerneldoc for stat field
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-update-damos-kerneldoc-for-stat-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-update-damos-kerneldoc-for-stat-field.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/damon: update damos kerneldoc for stat field
Date: Tue, 16 Dec 2025 00:01:19 -0800

Commit 0e92c2ee9f45 ("mm/damon/schemes: account scheme actions that
successfully applied") has replaced ->stat_count and ->stat_sz of 'struct
damos' with ->stat.  The commit mistakenly did not update the related
kernel doc comment, though.  Update the comment.

Link: https://lkml.kernel.org/r/20251216080128.42991-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-damos-kerneldoc-for-stat-field
+++ a/include/linux/damon.h
@@ -532,9 +532,7 @@ struct damos_migrate_dests {
  * unsets @last_applied when each regions walking for applying the scheme is
  * finished.
  *
- * After applying the &action to each region, &stat_count and &stat_sz is
- * updated to reflect the number of regions and total size of regions that the
- * &action is applied.
+ * After applying the &action to each region, &stat is updated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

