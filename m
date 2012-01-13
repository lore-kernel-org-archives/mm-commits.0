From: akpm@linux-foundation.org
Subject: [merged] cpumask-update-setup_node_to_cpumask_map-comments.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:12 -0800
Message-ID: <20120113203613.0914E5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40171 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:14 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt14so106252wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: update setup_node_to_cpumask_map() comments
has been removed from the -mm tree.  Its filename was
     cpumask-update-setup_node_to_cpumask_map-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: cpumask: update setup_node_to_cpumask_map() comments

node_to_cpumask() has been replaced by cpumask_of_node(), and wholly
removed since commit 29c337a0 ("cpumask: remove obsolete node_to_cpumask
now everyone uses cpumask_of_node").

So update the comments for setup_node_to_cpumask_map().

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    2 +-
 arch/x86/mm/numa.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/numa.c~cpumask-update-setup_node_to_cpumask_map-comments arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~cpumask-update-setup_node_to_cpumask_map-comments
+++ a/arch/powerpc/mm/numa.c
@@ -58,7 +58,7 @@ static int distance_lookup_table[MAX_NUM
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
- * Note: node_to_cpumask() is not valid until after this is done.
+ * Note: cpumask_of_node() is not valid until after this is done.
  */
 static void __init setup_node_to_cpumask_map(void)
 {
diff -puN arch/x86/mm/numa.c~cpumask-update-setup_node_to_cpumask_map-comments arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpumask-update-setup_node_to_cpumask_map-comments
+++ a/arch/x86/mm/numa.c
@@ -110,7 +110,7 @@ void __cpuinit numa_clear_node(int cpu)
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
- * Note: node_to_cpumask() is not valid until after this is done.
+ * Note: cpumask_of_node() is not valid until after this is done.
  * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 void __init setup_node_to_cpumask_map(void)
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch

