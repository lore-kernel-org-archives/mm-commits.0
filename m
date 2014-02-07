From: akpm@linux-foundation.org
Subject: + mm-nobootmemc-mark-function-as-static.patch added to -mm tree
Date: Fri, 07 Feb 2014 14:31:29 -0800
Message-ID: <52f55ec1.LREQJIMOpuPJ2SY0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGWba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + mm-nobootmemc-mark-function-as-static.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:31:29 -0800


The patch titled
     Subject: mm/nobootmem.c: mark function as static
has been added to the -mm tree.  Its filename is
     mm-nobootmemc-mark-function-as-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmemc-mark-function-as-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmemc-mark-function-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch

