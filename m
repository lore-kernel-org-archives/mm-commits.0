Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF981A6835
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744854; cv=none; b=aGdsciiHvuK7CRdwNKwdknQ3+4Bg3AyNKTrRTAB5O1KI3+Eb9F32dxsRT5WEABsiyyAKsMZe8S0kBpj1WvMDjt8imUd4BDp//h2dna8EV4O9yiqEw5iC+J+7Bm4P6hVeo7IXwDEfiuPMRFjn7fbrsjXnJncg3P/WgvaLU6JGIOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744854; c=relaxed/simple;
	bh=b4rOMI3AVSqkypqrjF+t+xQ7VXbDndkvVHWGK49VY6Y=;
	h=Date:To:From:Subject:Message-Id; b=MZf3GdeAYBgSahwZ+pjydLTt10pb0IgG7fUc2Qy6j0jBB60ADDT+qhhJKHqg4dAlDc0YWGBlwV+mp6Ws1tgAVbyKs08+DUliAYx0bjOgimx81S3/UbpkCyfBi0NDCwXPbsVq5vtNDUv27TYaPrhg4aBcYED8w38IvRlQabC9AAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CK2rXXus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CK2rXXus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D43C4CEF7;
	Sun, 29 Mar 2026 00:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744854;
	bh=b4rOMI3AVSqkypqrjF+t+xQ7VXbDndkvVHWGK49VY6Y=;
	h=Date:To:From:Subject:From;
	b=CK2rXXusf957ZhS5JoyssOQYLev1mNcW5badSWe+XIeEPrsTIq4ILhyzkdCncpazt
	 QZgA86MTx9fuE2XSIrATfACJCHudybDDBW/uk0vE4UlfF4bAM561K2xm6x7rJ646Ng
	 5TCh5tkHKxabcigl6obvSw+//CXXz4kOw42SfwSQ=
Date: Sat, 28 Mar 2026 17:40:53 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-autocorrect-bad-recompression-parameters.patch removed from -mm tree
Message-Id: <20260329004054.62D43C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not autocorrect bad recompression parameters
has been removed from the -mm tree.  Its filename was
     zram-do-not-autocorrect-bad-recompression-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2517,19 +2517,16 @@ static ssize_t recompress_store(struct d
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
@@ -2579,10 +2576,7 @@ static ssize_t recompress_store(struct d
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
@@ -2602,7 +2596,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = prio + 1;
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2619,6 +2613,11 @@ static ssize_t recompress_store(struct d
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


