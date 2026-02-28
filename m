Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CE0430B95
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772309061; cv=none; b=dYiYAIIa+6zA0qIaGSr0ehkUle2iE7es1R9cv6yCzPY8WxCSyI8zpTx72dhO1AU1MZv1tjN6FLwdSvJPu2KvmWt0miBAo+Ksnam9M9e+PJ4frDt0WUud9x9LyBxc4m4rrdfkQOcb90XthbchdR8DoQ0s7t9YEguu1dbh2crs384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772309061; c=relaxed/simple;
	bh=PWjW2+xeJcv6+irXDq5kuXZ7G1DpS4EmlmHsDRTqdAs=;
	h=Date:To:From:Subject:Message-Id; b=O9T4aA76AaBwbi4KpJJGerMyiGDt0Jk3fvNQUO+awjecuJ8S99JW4aR7BF8X6ylprNUWKuBnTwYe8NAAZE0jUldaQ+W/wug4VzLWE5sK47GJW092D9ltDoIudbuFD+j53X6LH73CZSUSutmipFwc2Ez1kmKCIaTbTw4aY/FD1Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVLBBBVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVLBBBVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E35C116D0;
	Sat, 28 Feb 2026 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309061;
	bh=PWjW2+xeJcv6+irXDq5kuXZ7G1DpS4EmlmHsDRTqdAs=;
	h=Date:To:From:Subject:From;
	b=oVLBBBVxSn84gI2pw3V/GiNHC44VIm9K5U+tcsWAgFqYGYCo9NaCIpIFD1Imrz9GA
	 EXGsa0H7i7i78TEfKMN010xUx65ye8amknt9Fgs0XZoAxHWQIIlwKLDKd+9/VM6BNw
	 OmoyOpLiF8+LC5I7+moV5EzIzOw/XiTDTyU2LCWk=
Date: Sat, 28 Feb 2026 12:04:20 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-autocorrect-bad-recompression-parameters.patch added to mm-new branch
Message-Id: <20260228200421.08E35C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not autocorrect bad recompression parameters
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-autocorrect-bad-recompression-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-autocorrect-bad-recompression-parameters.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not autocorrect bad recompression parameters
Date: Fri, 27 Feb 2026 17:21:07 +0900

Do not silently autocorrect bad recompression priority parameter value and
just error out.

Link: https://lkml.kernel.org/r/8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-autocorrect-bad-recompression-parameters
+++ a/drivers/block/zram/zram_drv.c
@@ -2524,19 +2524,16 @@ static ssize_t recompress_store(struct d
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
@@ -2586,10 +2583,7 @@ static ssize_t recompress_store(struct d
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
@@ -2609,7 +2603,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = prio + 1;
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2626,6 +2620,11 @@ static ssize_t recompress_store(struct d
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

zram-rename-writeback_compressed-device-attr.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

