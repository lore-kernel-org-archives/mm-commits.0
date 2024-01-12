Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534FC19451
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O206s//l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66ECC433C7;
	Fri, 12 Jan 2024 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101706;
	bh=N/1ZaQA4QMkJljHPJncqR7NxU8TtcSPWn7I5G+R0a+I=;
	h=Date:To:From:Subject:From;
	b=O206s//lZtDbiKvxM2Xix4K298ve+XiD1F72UGI2NzzqwjZ9h6DUoPBj/bibkN7xj
	 +tvmcvBMFWsC/6HXnwN1uCtkT19Qxt04xAZ+41Kph2v9mi41jSeoXe7uBKzv1wDr1U
	 hqS3wVBrWkz2I0VSq+owFI2FpVjensdKaafEurHk=
Date: Fri, 12 Jan 2024 15:21:46 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-entry-for-shrinker.patch removed from -mm tree
Message-Id: <20240112232146.B66ECC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add entry for shrinker
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-shrinker.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: MAINTAINERS: add entry for shrinker
Date: Thu, 11 Jan 2024 15:52:19 +0800

Since the shrinker-related code has been moved to a separate shrinker.c
file, it's time to add a MAINTAINERS entry for it.

Dave, Roman, Muchun and I have all worked on shrinker (development,
review, etc) in the past period of time, and all of us are willing to
continue working on shrinker in the future, so I'd like to add all of us
as maintainer/reviewer.

Link: https://lkml.kernel.org/r/20240111075219.34221-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-shrinker
+++ a/MAINTAINERS
@@ -19635,6 +19635,19 @@ T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/i2c/rj54n1cb0c.c
 F:	include/media/i2c/rj54n1cb0c.h
 
+SHRINKER
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Dave Chinner <david@fromorbit.com>
+R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
+R:	Muchun Song <muchun.song@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
+F:	include/linux/shrinker.h
+F:	mm/shrinker.c
+F:	mm/shrinker_debug.c
+
 SH_VOU V4L2 OUTPUT DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


