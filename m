Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D550D3A0B20
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772142220; cv=none; b=OzT8e8gMBKoloLFOj4LnKRj4shI7XvL7nS3lBOGsCrtGP5zVWUAnXD5cjti//NrDrfRo9RQX1CSVzSItdh+IoYG923CKN0H+5lDrR8kFi3SP/O32pigvGtVUgNfJWtKvVDRGwH4rzczl00T9+lje0k2+pYqSLuC+lSNtX4dNRgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772142220; c=relaxed/simple;
	bh=sAbzRFA36x3oRIC/fNWZZyKVZswp8igWxaEHaEdwkn8=;
	h=Date:To:From:Subject:Message-Id; b=Z+Q8Geg0we1D0uBvHjrlLGX82tp3/Y+GT4v4LYc1czCKCxezs+8VRJy6QYjzP2A2V85fhZ3tXk1NsimVm3sdJkmeaCHfc5d+JWWFFqESNaU4yjLStfJK1Xx4njB6H2oJk2iQSx6QwCcEx8UmBS0IltrrTGcbsPnvupplgCAZcdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xr88oClw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xr88oClw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C711C116C6;
	Thu, 26 Feb 2026 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772142220;
	bh=sAbzRFA36x3oRIC/fNWZZyKVZswp8igWxaEHaEdwkn8=;
	h=Date:To:From:Subject:From;
	b=xr88oClwG+no+0nQDM0CvbdznYl8iN6g0klClAc105FX1nbwsOVVxPWlOEsAHE1jx
	 XKQ5JdxolNxC7xAxvxr1WC3fKtyGca1ku9thffU1Mk3CBZQu7fcmypzX6JY/B6OamY
	 3Qeq+a8s4jW14Qek/JHdrLncR727mKl8P7m1QkWs=
Date: Thu, 26 Feb 2026 13:43:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-zone-lock-users-to-wrappers-fix.patch added to mm-new branch
Message-Id: <20260226214340.3C711C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-zone-lock-users-to-wrappers-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-zone-lock-users-to-wrappers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-zone-lock-users-to-wrappers-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-zone-lock-users-to-wrappers-fix
Date: Thu Feb 26 01:38:56 PM PST 2026

convert kernel/power/snapshot.c and mm/shuffle.c

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    5 +++--
 mm/shuffle.c            |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/power/snapshot.c~mm-convert-zone-lock-users-to-wrappers-fix
+++ a/kernel/power/snapshot.c
@@ -13,6 +13,7 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/zone_lock.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
@@ -1251,7 +1252,7 @@ static void mark_free_pages(struct zone
 	if (zone_is_empty(zone))
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	max_zone_pfn = zone_end_pfn(zone);
 	for_each_valid_pfn(pfn, zone->zone_start_pfn, max_zone_pfn) {
@@ -1284,7 +1285,7 @@ static void mark_free_pages(struct zone
 			}
 		}
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 #ifdef CONFIG_HIGHMEM
--- a/mm/shuffle.c~mm-convert-zone-lock-users-to-wrappers-fix
+++ a/mm/shuffle.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2018 Intel Corporation. All rights reserved.
 
 #include <linux/mm.h>
+#include <linux/zone_lock.h>
 #include <linux/init.h>
 #include <linux/mmzone.h>
 #include <linux/random.h>
@@ -85,7 +86,7 @@ void __meminit __shuffle_zone(struct zon
 	const int order = SHUFFLE_ORDER;
 	const int order_pages = 1 << order;
 
-	spin_lock_irqsave(&z->lock, flags);
+	zone_lock_irqsave(z, flags);
 	start_pfn = ALIGN(start_pfn, order_pages);
 	for (i = start_pfn; i < end_pfn; i += order_pages) {
 		unsigned long j;
@@ -138,12 +139,12 @@ void __meminit __shuffle_zone(struct zon
 
 		/* take it easy on the zone lock */
 		if ((i % (100 * order_pages)) == 0) {
-			spin_unlock_irqrestore(&z->lock, flags);
+			zone_unlock_irqrestore(z, flags);
 			cond_resched();
-			spin_lock_irqsave(&z->lock, flags);
+			zone_lock_irqsave(z, flags);
 		}
 	}
-	spin_unlock_irqrestore(&z->lock, flags);
+	zone_unlock_irqrestore(z, flags);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-convert-zone-lock-users-to-wrappers-fix.patch
mm-add-tracepoints-for-zone-lock-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

