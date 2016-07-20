From: akpm@linux-foundation.org
Subject: +
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2.patch added to -mm tree
Date: Wed, 20 Jul 2016 11:43:29 -0700
Message-ID: <578fc651.63fI2iyJ8CTxPKUJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbcGTSna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 14:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aryabinin@virtuozzo.com, glider@google.com, mgorman@techsingularity.net, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
has been added to the -mm tree.  Its filename is
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix

use __GFP_NOWARN for stack

Link: http://lkml.kernel.org/r/20160720151905.GB19146@node.shutemov.name
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/stackdepot.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2 lib/stackdepot.c
--- a/lib/stackdepot.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2
+++ a/lib/stackdepot.c
@@ -242,6 +242,7 @@ depot_stack_handle_t depot_save_stack(st
 		 */
 		alloc_flags &= ~GFP_ZONEMASK;
 		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
+		alloc_flags |= __GFP_NOWARN;
 		page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
 		if (page)
 			prealloc = page_address(page);
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-2.patch

