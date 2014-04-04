From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmemc-mark-function-as-static.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:48 -0700
Message-ID: <533f08a4.E3onLeCiu3XSA6/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaDDTbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-nobootmemc-mark-function-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:48 -0700


The patch titled
     Subject: mm/nobootmem.c: mark function as static
has been removed from the -mm tree.  Its filename was
     mm-nobootmemc-mark-function-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/nobootmem.c: mark function as static

Mark function as static in nobootmem.c because it is not used outside this
file.

This eliminates the following warning in mm/nobootmem.c:
mm/nobootmem.c:324:15: warning: no previous prototype for `___alloc_bootmem_node' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmemc-mark-function-as-static mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmemc-mark-function-as-static
+++ a/mm/nobootmem.c
@@ -334,7 +334,7 @@ void * __init __alloc_bootmem_node_nopan
 	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
-void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+static void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				    unsigned long align, unsigned long goal,
 				    unsigned long limit)
 {
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

