Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F87F7E4
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104103; cv=none; b=tRJ8jRe4knoUgSMCYXWS/8Q8nbRKj7hke3chzbtRIYkLwjDwkiRRpBcOgPKL91gaRfxLz0e6jEGODZkmGuagxT2J/NXBwne6LA10cD1pJ12qQzdoDiTQulkJJdiFZtS5JiBT3FS0xyT6NLCh2xXAJ53rOLQFYuy0GJEGyKsLLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104103; c=relaxed/simple;
	bh=sbqDhLe/P7C7VMLR66vnVi/RfZ5dn1dwI7WHR8Qp/WY=;
	h=Date:To:From:Subject:Message-Id; b=WjnW/XcgS2lsZBx0TmMJQMvU5bDvlV5pFaV/sOLmboWMuNHLKImaFx0Yk1BEN5naXNwRizCyyxkF1UEZBgbRh7Y6LpK5cYLGJF/ovzifVt/YBTbp1bt8CMSuNKD1iD9LX5spKq15zRhiV9dMjpGp9RYU8JnTcKxlW8HMaQP7L50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJl2z3jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJl2z3jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800AEC116B1;
	Fri, 26 Apr 2024 04:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104103;
	bh=sbqDhLe/P7C7VMLR66vnVi/RfZ5dn1dwI7WHR8Qp/WY=;
	h=Date:To:From:Subject:From;
	b=kJl2z3jnG7im1YGFjHebIlANVAZCzcAbIka+ZbLKhT+xc+9LjQvQ4fNNNqGQkyYSV
	 wohs/AGjd9mvbG49OGSWNT7xllEB3AwnLhAmDZ8Kg241+wr/wFnVanz83rDsQNejpS
	 LzIUM8MQ8liYfsrqQ2C1EusliSNgkkIfoynl0uu8=
Date: Thu, 25 Apr 2024 21:01:43 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-max_pages-param-to-recompression.patch removed from -mm tree
Message-Id: <20240426040143.800AEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add max_pages param to recompression
has been removed from the -mm tree.  Its filename was
     zram-add-max_pages-param-to-recompression.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Brian Geffon <bgeffon@google.com>
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


