From: akpm@linux-foundation.org
Subject: +
 mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix.patch
 added to -mm tree
Date: Mon, 11 Jul 2016 13:01:32 -0700
Message-ID: <5783fb1c.3F6s6ueL92NblaWe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbcGKUBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 16:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: prevent VM_BUG_ON when terminating freeing scanner fix
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: prevent VM_BUG_ON when terminating freeing scanner fix

Per Joonsoo.

An artifact of __isolate_free_page() doing per-zone watermark checks (?),
we don't want to rescan pages in a pageblock that were not successfully
isolated last time.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1607111244150.83138@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix
+++ a/mm/compaction.c
@@ -1055,7 +1055,6 @@ static void isolate_freepages(struct com
 			 * If isolation failed early, do not continue
 			 * needlessly.
 			 */
-			isolate_start_pfn = block_start_pfn;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch
mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

