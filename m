From: akpm@linux-foundation.org
Subject: + cpumask-update-setup_node_to_cpumask_map-comments.patch added to -mm tree
Date: Thu, 10 Nov 2011 15:34:38 -0800
Message-ID: <201111102334.pAANYcsf013396@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:53186 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1KJXem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 18:34:42 -0500
Received: by faas12 with SMTP id s12so83399faa.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 15:34:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaowanlong@cn.fujitsu.com, rusty@rustcorp.com.au


The patch titled
     Subject: cpumask: update setup_node_to_cpumask_map() comments
has been added to the -mm tree.  Its filename is
     cpumask-update-setup_node_to_cpumask_map-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: cpumask: update setup_node_to_cpumask_map() comments

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

linux-next.patch
cpumask-update-setup_node_to_cpumask_map-comments.patch

