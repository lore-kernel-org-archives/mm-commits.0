Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734792F747A;
	Thu, 27 Aug 2026 04:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805600; cv=none; b=RsAZYFqrIuMeylbyERy2qqHayO/KQ6tfTESU2szekf2yQfML1+Mo+FLQCkeqI37lM3SfRyCbi8mTVHM6pAWd2DKL0XtYJa49AM6foijjtRs/Tj85Vo9y43DsA2/bhVKDCn9b696ii6jtHmeye1TR1hLZbd3fgpm0TRRhss4GUqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805600; c=relaxed/simple;
	bh=/NV80uNMJqEeFxKjupDnF07etdByNEox6A4cxY1EhEQ=;
	h=Date:To:From:Subject:Message-Id; b=Qghe29cdkxvMAQVADXzTT1Wh97FQbUymiCFYMgL/X96Cdg604NX/UO76aE9+eXZm+ybSG0oJ53/sz7QcnlSBdtK/2mACnhi99cuxwX4ufsTVPUGtZX0ptQzD8oNVIG20EttpJ2I0ikzuFl01SdopSeIbuFU4sP1V8OkbgjhAYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgprP/WM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgprP/WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA481F000E9;
	Thu, 27 Aug 2026 04:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787805599;
	bh=wrRffFyd9tlWMBes0w/UZ6GVLgsRxDGW4jbmF3/SflM=;
	h=Date:To:From:Subject;
	b=rgprP/WMHNSqvIjV6FzaK460Jxrkq/5GX+XfeMotQM1XxBdCnG8ZdIBWLSmah9mQK
	 s3/zxUY7qsrpmPnOgF+nQRCPRaw/L74DBeHows5psawJpn7/h8hYGXedN+t9M/CRzI
	 osLzAKI25lj+QwVRoXQArSTmTpmugOCNUw1RHcUE=
Date: Wed, 26 Aug 2026 21:39:58 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch added to mm-new branch
Message-Id: <20260827043958.EDA481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: set next refresh jiffies per sysfs context
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Wed, 26 Aug 2026 21:29:19 -0700

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next refresh
is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it. 
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or crash.
The update will not be faster or slower than the lowest and largest
refresh_ms values of the contexts, respectively.  The user can also
manually ask the updates on demand using kdamond state commands.  That
said, clearly this is a bug.

Link: https://lore.kernel.org/20260827042920.93580-3-sj@kernel.org
Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context
+++ a/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_bui
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(str
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

