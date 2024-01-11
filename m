Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB9055E5A
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 21:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oDI3PDri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DAFC433C7;
	Thu, 11 Jan 2024 21:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705007710;
	bh=g31W6i0wwEuBp4esr9MTsRnNobFIlWDhHNM8kw5OKRU=;
	h=Date:To:From:Subject:From;
	b=oDI3PDriwn5PmghGQJC/xcg6usAd48RGwg+Dt4ZkOE1rAt/VLX/jaWoPO4uw7isUZ
	 jrh4izLE2iEB3alNtXnGsglB06s85gz0EwTf0JVQDyv0mJS3tHXKdWf3I2LqmeUcWw
	 JxLJM0U/6UvLA4G53ApmjlV2u57283sfLCTo7l8Q=
Date: Thu, 11 Jan 2024 13:15:09 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entry-for-shrinker.patch added to mm-hotfixes-unstable branch
Message-Id: <20240111211510.A2DAFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add entry for shrinker
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-entry-for-shrinker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entry-for-shrinker.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -19648,6 +19648,19 @@ T:	git git://linuxtv.org/media_tree.git
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

maintainers-add-entry-for-shrinker.patch

