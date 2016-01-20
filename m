From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-reign-in-the-config-space-madness-fix.patch removed from -mm
 tree
Date: Wed, 20 Jan 2016 14:41:24 -0800
Message-ID: <56a00d14.lKPoZy0CqdzXYK/k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbcATWlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:41:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-reign-in-the-config-space-madness-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reign-in-the-config-space-madness-fix.patch

This patch was dropped because it was folded into mm-memcontrol-reign-in-the-config-space-madness.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-reign-in-the-config-space-madness-fix

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness-fix
+++ a/mm/memcontrol.c
@@ -4374,6 +4374,8 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
+	memcg_free_kmem(memcg);
+
 	if (memcg->tcp_mem.active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

