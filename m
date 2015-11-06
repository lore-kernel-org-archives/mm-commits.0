From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-fix-thresholds-for-32b-architectures-fix-fix.patch removed from -mm
 tree
Date: Thu, 05 Nov 2015 18:29:59 -0800
Message-ID: <563c10a7.uld1Y/J5FS+uoPJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben@decadent.org.uk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-thresholds-for-32b-architectures-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-thresholds-for-32b-architectures-fix-fix.patch

This patch was dropped because it was folded into memcg-fix-thresholds-for-32b-architectures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-fix-thresholds-for-32b-architectures-fix-fix

don't attempt to inline mem_cgroup_usage()

The compiler ignores the inline anwyay.  And __always_inlining it adds 600
bytes of goop to the .o file.

Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix-fix
+++ a/mm/memcontrol.c
@@ -2801,7 +2801,7 @@ static unsigned long tree_stat(struct me
 	return val;
 }
 
-static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
 	unsigned long val;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

