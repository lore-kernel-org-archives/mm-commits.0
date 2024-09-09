Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0280418E34C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925278; cv=none; b=SJ44Xw0/T486hGMzkoFgE/A+WkOGLs5qNnUAOq0jTVqDq5xDFpz8B7B87KUBsy8dSk7bxCpx3Ifpq70OEK0ZHKxhh3g/DTc2j4N/s84D7fwblBwhEU3eqHrNz5Mq4b6Z2ofKcY9OmTDRfoR5xkstnkVOmtoDgHWp2GfSatu5+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925278; c=relaxed/simple;
	bh=ys9yxBbCbDowGlUmC7s+9tqehDNIEmpFIQVQHbnd+iY=;
	h=Date:To:From:Subject:Message-Id; b=pM87Ye5eXHfgRH/9+yxcdmh3a1dah+qVhL2e4WCYbsqkD5VcFzoRrYac0t/zKziA0Ohu5SX7qig0t6W//VZeRm7Bf4BR69EfrtYBpFuucKPlqZqXP4jHtbGAQDm+PfmNecMUzYe+AheygPjI5jETV3oDrXi9NlFXG/bqMnKo/Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ps7XxnBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ps7XxnBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C866EC4CECA;
	Mon,  9 Sep 2024 23:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925277;
	bh=ys9yxBbCbDowGlUmC7s+9tqehDNIEmpFIQVQHbnd+iY=;
	h=Date:To:From:Subject:From;
	b=Ps7XxnBJ6cdqcEzh4sM6Q12LXoHdL4GXwQ4Oys1pajQw+5vLG28Vno7P7c/VrdOW7
	 VpQG8rFZCAdbfhaP9wXvUulv/kQVXpUtmUJfjwMNZVHz8E9uFHEvfL18/Pog7zpcfs
	 pw4lln5Xj7g4xZIyFpFjW83uR42kR8WBiNwPeRUg=
Date: Mon, 09 Sep 2024 16:41:17 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-support-for-dict-comp-config.patch removed from -mm tree
Message-Id: <20240909234117.C866EC4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add support for dict comp config
has been removed from the -mm tree.  Its filename was
     zram-add-support-for-dict-comp-config.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add support for dict comp config
Date: Mon, 2 Sep 2024 19:56:04 +0900

Handle dict=path algorithm param so that we can read a pre-trained
compression algorithm dictionary which we then pass to the backend
configuration.

Link: https://lkml.kernel.org/r/20240902105656.1383858-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   45 +++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-support-for-dict-comp-config
+++ a/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/debugfs.h>
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
+#include <linux/kernel_read_file.h>
 
 #include "zram_drv.h"
 
@@ -998,8 +999,34 @@ static int __comp_algorithm_store(struct
 	return 0;
 }
 
-static int comp_params_store(struct zram *zram, u32 prio, s32 level)
+static void comp_params_reset(struct zram *zram, u32 prio)
 {
+	struct zcomp_params *params = &zram->params[prio];
+
+	vfree(params->dict);
+	params->level = ZCOMP_PARAM_NO_LEVEL;
+	params->dict_sz = 0;
+	params->dict = NULL;
+}
+
+static int comp_params_store(struct zram *zram, u32 prio, s32 level,
+			     const char *dict_path)
+{
+	ssize_t sz = 0;
+
+	comp_params_reset(zram, prio);
+
+	if (dict_path) {
+		sz = kernel_read_file_from_path(dict_path, 0,
+						&zram->params[prio].dict,
+						INT_MAX,
+						NULL,
+						READING_POLICY);
+		if (sz < 0)
+			return -EINVAL;
+	}
+
+	zram->params[prio].dict_sz = sz;
 	zram->params[prio].level = level;
 	return 0;
 }
@@ -1010,7 +1037,7 @@ static ssize_t algorithm_params_store(st
 				      size_t len)
 {
 	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NO_LEVEL;
-	char *args, *param, *val, *algo = NULL;
+	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct zram *zram = dev_to_zram(dev);
 	int ret;
 
@@ -1039,6 +1066,11 @@ static ssize_t algorithm_params_store(st
 			algo = val;
 			continue;
 		}
+
+		if (!strcmp(param, "dict")) {
+			dict_path = val;
+			continue;
+		}
 	}
 
 	/* Lookup priority by algorithm name */
@@ -1060,7 +1092,7 @@ static ssize_t algorithm_params_store(st
 	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
-	ret = comp_params_store(zram, prio, level);
+	ret = comp_params_store(zram, prio, level, dict_path);
 	return ret ? ret : len;
 }
 
@@ -2050,12 +2082,7 @@ static void zram_comp_params_reset(struc
 	u32 prio;
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		struct zcomp_params *params = &zram->params[prio];
-
-		vfree(params->dict);
-		params->level = ZCOMP_PARAM_NO_LEVEL;
-		params->dict_sz = 0;
-		params->dict = NULL;
+		comp_params_reset(zram, prio);
 	}
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

