From: akpm@linux-foundation.org
Subject: + arch-x86-mm-numac-add-constraints-check-for-nid-parameters.patch added to -mm tree
Date: Thu, 08 Dec 2011 15:17:42 -0800
Message-ID: <201112082317.pB8NHg0n006835@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36169 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1LHXRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Dec 2011 18:17:45 -0500
Received: by ghrr18 with SMTP id r18so282657ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Dec 2011 15:17:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, anton@redhat.com, hpa@zytor.com, mingo@redhat.com, rientjes@google.com, tglx@linutronix.de


The patch titled
     Subject: arch/x86/mm/numa.c: add constraints check for nid parameters
has been added to the -mm tree.  Its filename is
     arch-x86-mm-numac-add-constraints-check-for-nid-parameters.patch

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
Subject: Subject: arch/x86/mm/numa.c: add constraints check for nid parameters

Patches currently in -mm which might be from pholasek@redhat.com are

arch-x86-mm-numac-add-constraints-check-for-nid-parameters.patch

