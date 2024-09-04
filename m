Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D09A7406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423505; cv=none; b=lrJUC/A1MSE0gD0AJFXbu5gQga7a4YTSbVbUulhAmdqnFIRZndajN7i8twEpzjAlwbEcOoiFogkDhpGVuSuKt0amgMHuPQ72ei/06Q1qDsu4gDgO6XQZmRMZz7KCStRwzOFuNY92oIWJOCVZCVo0hCzLaLEiVNR6EMyTEKwAUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423505; c=relaxed/simple;
	bh=CPVf8o/ja/EtYSX+FmpO5mzeIgIYgjOA5n6u6g60CqM=;
	h=Date:To:From:Subject:Message-Id; b=mq2Ak98OzVWaqQNH66qtDRSqs6Wc/7qNvuGpjrP/HmjbJXdK6YUnWFBf+Hiq1BENA+XqYbLxBm/YeGAsp1Ei+t59DNQM7uJIC57ZI+V8HjEeDwjVpIu1rptQzXYY+UPUOvlYwxJ0/umsM/1Ay4UFC8aMhazBPPb2m0XFW1qOg8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOGr1vDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOGr1vDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BC4C4CEC2;
	Wed,  4 Sep 2024 04:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423505;
	bh=CPVf8o/ja/EtYSX+FmpO5mzeIgIYgjOA5n6u6g60CqM=;
	h=Date:To:From:Subject:From;
	b=sOGr1vDn6GAIB9iKMDizfnFOdAvm9xRhtD5iHRQv7oGBMMLVooVkeURThzI8TbAro
	 VQ5X9s4xnusTXQQ//796oBJbjgijKBGDWKPOKKD9y+Cru3NYGvvHYZ8+QAIdIH36o3
	 9UjbuWZcbe8wx4Bg/RspScYWExAMoUEfWP6kLkqM=
Date: Tue, 03 Sep 2024 21:18:24 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch removed from -mm tree
Message-Id: <20240904041825.33BC4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrinker: use min() to improve shrinker_debugfs_scan_write()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: mm: shrinker: use min() to improve shrinker_debugfs_scan_write()
Date: Tue, 20 Aug 2024 06:22:55 +0200

Use the min() macro to simplify the shrinker_debugfs_scan_write() function
and improve its readability.

Link: https://lkml.kernel.org/r/20240820042254.99115-2-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker_debug.c~mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write
+++ a/mm/shrinker_debug.c
@@ -114,7 +114,7 @@ static ssize_t shrinker_debugfs_scan_wri
 	int nid;
 	char kbuf[72];
 
-	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
+	read_len = min(size, sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
 		return -EFAULT;
 	kbuf[read_len] = '\0';
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are


