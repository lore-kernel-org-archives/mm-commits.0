From: akpm@linux-foundation.org
Subject: + mm-clarify-compaction-kconfig-text.patch added to -mm tree
Date: Tue, 23 Aug 2016 13:55:49 -0700
Message-ID: <57bcb855.QDmQ3ia6GGPAN38E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755833AbcHWUzu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Aug 2016 16:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, js1304@gmail.com, markus@trippelsdorf.de, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify COMPACTION Kconfig text
has been added to the -mm tree.  Its filename is
     mm-clarify-compaction-kconfig-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-compaction-kconfig-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-compaction-kconfig-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: clarify COMPACTION Kconfig text

The current wording of the COMPACTION Kconfig help text doesn't emphasise
that disabling COMPACTION might cripple the page allocator which relies on
the compaction quite heavily for high order requests and an unexpected OOM
can happen with the lack of compaction.  Make sure we are vocal about
that.

Link: http://lkml.kernel.org/r/20160823091726.GK23577@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-clarify-compaction-kconfig-text mm/Kconfig
--- a/mm/Kconfig~mm-clarify-compaction-kconfig-text
+++ a/mm/Kconfig
@@ -262,7 +262,14 @@ config COMPACTION
 	select MIGRATION
 	depends on MMU
 	help
-	  Allows the compaction of memory for the allocation of huge pages.
+          Compaction is the only memory management component to form
+          high order (larger physically contiguous) memory blocks
+          reliably. The page allocator relies on compaction heavily and
+          the lack of the feature can lead to unexpected OOM killer
+          invocations for high order memory requests. You shouldn't
+          disable this option unless there really is a strong reason for
+          it and then we would be really interested to hear about that at
+          linux-mm@kvack.org.
 
 #
 # support for page migration
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-clarify-compaction-kconfig-text.patch
mm-vmscan-get-rid-of-throttle_vm_writeout.patch

