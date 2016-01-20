From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 14:41:30 -0800
Message-ID: <56a00d1a.xY2JFY2laEnN5uqE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbcATWlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-reign-in-the-config-space-madness-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

This patch was dropped because it was folded into mm-memcontrol-reign-in-the-config-space-madness.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-reign-in-the-config-space-madness-fix-fix

rework mem_cgroup_css_free() statement ordering

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness-fix-fix
+++ a/mm/memcontrol.c
@@ -4374,11 +4374,10 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
-	memcg_free_kmem(memcg);
