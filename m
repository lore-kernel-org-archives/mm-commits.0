Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ECF2E7380;
	Thu, 18 Jun 2026 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781809112; cv=none; b=sMilpLgowBRPFRVZNgAsvwrmrgNdHX718t1QsAankf50FYvOL1WigjFJkxcc9BmI0oKYWeM7ACioSzq2xqOkUeuz97K/eIN2lE+rwbCEIbRHvT1GE1Y5rqrml3IDcFjAC0vfdW3kHm8YAZ3FlcQTVbuudyJ2f0zMtc5QC5wbP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781809112; c=relaxed/simple;
	bh=fwaUZzNMvaZc2BPbZsPy9GK/Y+EIKakI6c48Ze86IEc=;
	h=Date:To:From:Subject:Message-Id; b=VK/2Bjfk5HiqblbnVrDqgbAu7GOfmixd84iq4sFkDqNxmcLIZBFWuu1ee/t4+/ahvkpQyxYAb1vn0YeMLHJVWR2ugHSSFjYlkJudJTQVxrKekW9UUfxu0AfkMX1waktJsvIn/q2R0+kbVtTg+1KNVuVwPEy+YQsGTZ79zn4Io50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndh2oNXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndh2oNXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978911F00A3A;
	Thu, 18 Jun 2026 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781809110;
	bh=XmZqcRfe6Zcbmv4JeSN5ep1uMN8ny2VjQolVW7Zqd/Y=;
	h=Date:To:From:Subject;
	b=ndh2oNXb9RJeTIJ3iwd7r/RJdzoMV/97KXlMplTonz5cq9OtYNFtwpG/awXl8Ykwg
	 DMYL4a+2ZCDtrSdEaEils3gWbfYAH5QZrSRl/li+S/uOgSNwE3L8/HQzlxhGkUjEea
	 fSD+aBxP0OnimAwh4UbrK3oYQU77B5KFmASgQQOk=
Date: Thu, 18 Jun 2026 11:58:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20260618185830.978911F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Wed, 17 Jun 2026 17:56:48 -0700

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after the
stats directory setup is completed.  When the tried_regions directory
setup is failed, the setup function ensures the reference for the tried
regions directory is released.  Hence the error path should put references
on setup succeeded directory objects, starting from the stats directory. 
However, the error path is putting the tried_regions directory instead of
the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation, the
scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260618005650.83868-3-sj@kernel.org
Link: https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org [1]
Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error
+++ a/mm/damon/sysfs-schemes.c
@@ -2283,12 +2283,12 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

