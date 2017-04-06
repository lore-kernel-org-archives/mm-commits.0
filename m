From: akpm@linux-foundation.org
Subject: + mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch added
 to -mm tree
Date: Thu, 06 Apr 2017 15:06:47 -0700
Message-ID: <58e6bbf7.b/cFIY45OqX34IvW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755649AbdDFWGs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 18:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix setting of defer+madvise thp defrag mode
has been added to the -mm tree.  Its filename is
     mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch

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
Subject: mm, thp: fix setting of defer+madvise thp defrag mode

Setting thp defrag mode of "defer+madvise" actually sets "defer" in the
kernel due to the name similarity and the out-of-order way the string is
checked in defrag_store().

Check the string in the correct order so that
TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG is set appropriately for
"defer+madvise".

Fixes: 21440d7eb904 ("mm, thp: add new defer+madvise defrag option")
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1704051814420.137626@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-setting-of-defermadvise-thp-defrag-mode mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-setting-of-defermadvise-thp-defrag-mode
+++ a/mm/huge_memory.c
@@ -240,18 +240,18 @@ static ssize_t defrag_store(struct kobje
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("defer", buf,
-		    min(sizeof("defer")-1, count))) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 	} else if (!memcmp("defer+madvise", buf,
 		    min(sizeof("defer+madvise")-1, count))) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
+	} else if (!memcmp("defer", buf,
+		    min(sizeof("defer")-1, count))) {
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 	} else if (!memcmp("madvise", buf,
 			   min(sizeof("madvise")-1, count))) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch
mm-vmstat-print-non-populated-zones-in-zoneinfo.patch
mm-vmstat-suppress-pcp-stats-for-unpopulated-zones-in-zoneinfo.patch

