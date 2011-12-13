From: akpm@linux-foundation.org
Subject: [merged] arch-x86-mm-numac-add-constraints-check-for-nid-parameters.patch removed from -mm tree
Date: Tue, 13 Dec 2011 11:19:44 -0800
Message-ID: <201112131919.pBDJJi1a027817@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49559 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1LMTTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 14:19:47 -0500
Received: by yenm5 with SMTP id m5so600yen.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 11:19:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, anton@redhat.com, hpa@zytor.com, mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/numa.c: add constraints check for nid parameters
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-numac-add-constraints-check-for-nid-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Petr Holasek <pholasek@redhat.com>
Subject: arch/x86/mm/numa.c: add constraints check for nid parameters

Add a constraints checks for numa_set_distance().  It emits a warning and
avoids a store to a negative index in numa_distance[] array.  Negative ids
can be passed when pxm-to-nids mapping is not properly filled while
parsing the SRAT.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anton Arapov <anton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/numa.c~arch-x86-mm-numac-add-constraints-check-for-nid-parameters arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~arch-x86-mm-numac-add-constraints-check-for-nid-parameters
+++ a/arch/x86/mm/numa.c
@@ -430,8 +430,9 @@ static int __init numa_alloc_distance(vo
  * calls are ignored until the distance table is reset with
  * numa_reset_distance().
  *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
  * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
@@ -439,8 +440,9 @@ void __init numa_set_distance(int from, 
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
+		pr_warn_once("NUMA: Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
 	}
_

Patches currently in -mm which might be from pholasek@redhat.com are

linux-next.patch

