Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAF72F25
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711768420; cv=none; b=NImgBh8efFQYi2xr3YZF+Illct5rIOKwdNe+zFkn/Mbw3KEVCX9eWpiL0E6/5J0tjsOkUqriEq1Yk4qy3YlsYd5WTI+03N5BP36r77OD5q9H8NN9hgPazXZ9ipVSwEc9GTKy1qJVxrthPzJ1JsmhtRR6xCUKdns96rQeg0UtBIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711768420; c=relaxed/simple;
	bh=dOATp0wYN8W5fVxq72id487wyOn0BI2ggzH0l6Zf3MI=;
	h=Date:To:From:Subject:Message-Id; b=JytmYlHTH5BjSFqR+d9zvVH0k27vLVSGmX9OS6QWkqNnK7WjIZV7wy8kpaSqf6cr9C7fZ6RGj3rb02zPn8qUFieXuqnEt9XfVAkeLBPep78W/XTpsOVkos7Zag9gmII/7lde4xTBw7u4n84fyM/73lhmVwHGpuEBcfHfPc02Dh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIwlIQfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIwlIQfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B317C433C7;
	Sat, 30 Mar 2024 03:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711768418;
	bh=dOATp0wYN8W5fVxq72id487wyOn0BI2ggzH0l6Zf3MI=;
	h=Date:To:From:Subject:From;
	b=cIwlIQfgHK+Opo2hb9lMhbB00vnSI5wBcslzw39pE7jIm6oUDIJbyIfYXhdVkDbh0
	 cqA335FKf4uPOAAI1KspBxFOJ44wWxxyNizQMo0PmmWqaw94yORubnOKJqdZ/S0tPU
	 uVdWpd32tJKsgVvQN/WM0Lh3BnUrrA2ZXSeG3EK0=
Date: Fri, 29 Mar 2024 20:13:38 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-max_pages-param-to-recompression.patch added to mm-unstable branch
Message-Id: <20240330031338.9B317C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add max_pages param to recompression
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-max_pages-param-to-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-max_pages-param-to-recompression.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add max_pages param to recompression
Date: Fri, 29 Mar 2024 18:39:41 +0900

Introduce "max_pages" param to recompress device attribute which sets an
upper limit on the number of entries (pages) zram attempts to recompress
(in this particular recompression call).  S/W recompression can be quite
expensive so limiting the number of pages recompress touches can be quite
helpful.

Link: https://lkml.kernel.org/r/20240329094050.2815699-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    5 ++
 drivers/block/zram/zram_drv.c               |   31 ++++++++++++++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-max_pages-param-to-recompression
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -466,6 +466,11 @@ of equal or greater size:::
 	#recompress idle pages larger than 2000 bytes
 	echo "type=idle threshold=2000" > /sys/block/zramX/recompress
 
+It is also possible to limit the number of pages zram re-compression will
+attempt to recompress:::
+
+	echo "type=huge_idle max_pages=42" > /sys/block/zramX/recompress
+
 Recompression of idle pages requires memory tracking.
 
 During re-compression for every page, that matches re-compression criteria,
--- a/drivers/block/zram/zram_drv.c~zram-add-max_pages-param-to-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1568,7 +1568,8 @@ static int zram_bvec_write(struct zram *
  * Corresponding ZRAM slot should be locked.
  */
 static int zram_recompress(struct zram *zram, u32 index, struct page *page,
-			   u32 threshold, u32 prio, u32 prio_max)
+			   u64 *num_recomp_pages, u32 threshold, u32 prio,
+			   u32 prio_max)
 {
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long handle_old;
@@ -1645,6 +1646,15 @@ static int zram_recompress(struct zram *
 	if (!zstrm)
 		return 0;
 
+	/*
+	 * Decrement the limit (if set) on pages we can recompress, even
+	 * when current recompression was unsuccessful or did not compress
+	 * the page below the threshold, because we still spent resources
+	 * on it.
+	 */
+	if (*num_recomp_pages)
+		*num_recomp_pages -= 1;
+
 	if (class_index_new >= class_index_old) {
 		/*
 		 * Secondary algorithms failed to re-compress the page
@@ -1710,6 +1720,7 @@ static ssize_t recompress_store(struct d
 	struct zram *zram = dev_to_zram(dev);
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 	char *args, *param, *val, *algo = NULL;
+	u64 num_recomp_pages = ULLONG_MAX;
 	u32 mode = 0, threshold = 0;
 	unsigned long index;
 	struct page *page;
@@ -1732,6 +1743,17 @@ static ssize_t recompress_store(struct d
 			continue;
 		}
 
+		if (!strcmp(param, "max_pages")) {
+			/*
+			 * Limit the number of entries (pages) we attempt to
+			 * recompress.
+			 */
+			ret = kstrtoull(val, 10, &num_recomp_pages);
+			if (ret)
+				return ret;
+			continue;
+		}
+
 		if (!strcmp(param, "threshold")) {
 			/*
 			 * We will re-compress only idle objects equal or
@@ -1788,6 +1810,9 @@ static ssize_t recompress_store(struct d
 	for (index = 0; index < nr_pages; index++) {
 		int err = 0;
 
+		if (!num_recomp_pages)
+			break;
+
 		zram_slot_lock(zram, index);
 
 		if (!zram_allocated(zram, index))
@@ -1807,8 +1832,8 @@ static ssize_t recompress_store(struct d
 		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		err = zram_recompress(zram, index, page, threshold,
-				      prio, prio_max);
+		err = zram_recompress(zram, index, page, &num_recomp_pages,
+				      threshold, prio, prio_max);
 next:
 		zram_slot_unlock(zram, index);
 		if (err) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-max_pages-param-to-recompression.patch

