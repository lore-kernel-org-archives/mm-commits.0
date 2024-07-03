Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526F58F40
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719971595; cv=none; b=h2V+70PQojOYX7GxWnLremFTH+brvW/ZeNjkfbTJwz5cCtgRF0XEq3Nb82QXHDwVtGlosbD4Ufi5/TOd35oCcy99Ati8qzg+VrFObwIaolFVxFnTBaJlw4q3wkmaDba7fOWHuPee6FtAtHf+ponfuDVZ1+zHsN5IJe2veBnXMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719971595; c=relaxed/simple;
	bh=bTURzG4zr1WKfLleteLiQA9iymac1SDOlXfQ+gnK7rE=;
	h=Date:To:From:Subject:Message-Id; b=tfUzlyRokkpPkwO0GeF26wkl0gKsGSLqWudT3lW2chXj8umPPmf+mZTF87j9SFMMdSGJhEoBDDSCJITEHXRxZr7dzItDJ2wvuClt4DvcLu1z//QLAjBo4raEHj0JR+n+xHqpb1MHMPW6oLBwWJyfU6nMg9E0B9HNO8BmqUN0YLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FtMPOauo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FtMPOauo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4146C116B1;
	Wed,  3 Jul 2024 01:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719971594;
	bh=bTURzG4zr1WKfLleteLiQA9iymac1SDOlXfQ+gnK7rE=;
	h=Date:To:From:Subject:From;
	b=FtMPOauoB3Ggg65b0T6LIBKL0Rj+vSZ8Z/VJ8fBEE76WreWYoHeLBH5ujxL33UTOp
	 klaUx3PNq0++Hvn0x8bfC5Y885zJ2b3j6P+LHlbfvninA+GVw3DDJ4NGsyVfxCS374
	 Zm6IQbvTDbqFscddzOZCgZom9pzTSGx1SAY22SfE=
Date: Tue, 02 Jul 2024 18:53:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zonelist_zone-to-get-zone.patch added to mm-unstable branch
Message-Id: <20240703015314.D4146C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zonelist_zone() to get zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-zonelist_zone-to-get-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zonelist_zone-to-get-zone.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: use zonelist_zone() to get zone
Date: Tue, 2 Jul 2024 23:40:06 +0000

Instead of accessing zoneref->zone directly, use zonelist_zone() like
other places for consistency.

No functional change.

Link: https://lkml.kernel.org/r/20240702234008.19101-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-use-zonelist_zone-to-get-zone
+++ a/include/linux/mmzone.h
@@ -1690,7 +1690,7 @@ static inline struct zoneref *first_zone
 			zone = zonelist_zone(z))
 
 #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
-	for (zone = z->zone;	\
+	for (zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-use-zonelist_zone-to-get-zone.patch
modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

