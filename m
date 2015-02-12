From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 14:13:43 -0800
Message-ID: <54dd2597.fDWALI5NRVJKPhKm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbBLWNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:13:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fromorbit.com, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-shrinker-always-scan-at-least-one-object-of-each-type-fix
has been removed from the -mm tree.  Its filename was
     fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch

This patch was dropped because it was folded into fs-shrinker-always-scan-at-least-one-object-of-each-type.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-shrinker-always-scan-at-least-one-object-of-each-type-fix

add comment

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type-fix fs/super.c
--- a/fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type-fix
+++ a/fs/super.c
@@ -91,6 +91,9 @@ static unsigned long super_cache_scan(st
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
+	 *
+	 * Ensure that we always scan at least one object - memcg kmem
+	 * accounting uses this to fully empty the caches.
 	 */
 	sc->nr_to_scan = dentries + 1;
 	freed = prune_dcache_sb(sb, sc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
zram-rework-reset-and-destroy-path-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

