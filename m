Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDBA3E6DE6
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252769; cv=none; b=XOS/1C73m2rYzzhCsXEPVRXiqF6PXxvF0+/EzF4VAeZt31hQUYyt1g9pei3F2v2TQxT1VF6XQWqBjOLnLJvFO7/qHiJqO8B2yOUK7Q2g0Jir8XTXVnh/sPUVMrpF/lAArkH0gPY8OX3YmIOY4DvC7qSYJOCmYKlQO9hk5XWz1gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252769; c=relaxed/simple;
	bh=gS/Pi3i0nqDBLhcHVqCiML57nS3k35rFHqbJXLEqsNw=;
	h=Date:To:From:Subject:Message-Id; b=CzoV2ijLzEYODQz9yFo5TqzOxCMihWg9xBkGGSq86cvh0r+DhJbZWJqTca12DhviVjo3zatin83YVJrQLH40kVJcXEYOTR+QfW3gBo6AjZFbAgWKF4vzjdhaXMwuS4k3Mfnve5yuZpAM5MwKJnITkCuKXOHgwTirASulC81nLtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wdKi0Vif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wdKi0Vif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25FEC4CEF7;
	Wed, 11 Mar 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252769;
	bh=gS/Pi3i0nqDBLhcHVqCiML57nS3k35rFHqbJXLEqsNw=;
	h=Date:To:From:Subject:From;
	b=wdKi0VifB4AIz2Hm2EowCDxnv/bHp5fMX+AZ0SdgkaZQvA/EffPW4xd2+gDFdetoD
	 f3rP3Wejv3Oeb6nBDAGmJ5ZaxPGC9wK8KXE8oRKT1u75uh3LH8t4dI+VmI/Z4bGS/g
	 nvZ+7MwuuVhOKlWekJwHi8Fl9Jx7YuE8wdLXV+J0=
Date: Wed, 11 Mar 2026 11:12:48 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-autocorrect-bad-recompression-parameters.patch added to mm-unstable branch
Message-Id: <20260311181248.F25FEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not autocorrect bad recompression parameters
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-autocorrect-bad-recompression-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-autocorrect-bad-recompression-parameters.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not autocorrect bad recompression parameters
Date: Wed, 11 Mar 2026 17:42:45 +0900

Do not silently autocorrect bad recompression priority parameter value and
just error out.

Link: https://lkml.kernel.org/r/20260311084312.1766036-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-autocorrect-bad-recompression-parameters
+++ a/drivers/block/zram/zram_drv.c
@@ -2528,19 +2528,16 @@ static ssize_t recompress_store(struct d
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
+	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
-	u32 prio, prio_max;
 	struct page *page = NULL;
 	ssize_t ret;
 
-	prio = ZRAM_SECONDARY_COMP;
-	prio_max = zram->num_active_comps;
-
 	args = skip_spaces(buf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
@@ -2590,10 +2587,7 @@ static ssize_t recompress_store(struct d
 			if (ret)
 				return ret;
 
-			if (prio == ZRAM_PRIMARY_COMP)
-				prio = ZRAM_SECONDARY_COMP;
-
-			prio_max = prio + 1;
+			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2613,7 +2607,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = prio + 1;
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2630,6 +2624,11 @@ static ssize_t recompress_store(struct d
 		ret = -EINVAL;
 		goto out;
 	}
+
+	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch

