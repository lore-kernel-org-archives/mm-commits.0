From: akpm@linux-foundation.org
Subject: +
 fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch added
 to -mm tree
Date: Fri, 19 Jan 2018 12:59:19 -0800
Message-ID: <5a625c27.Jiy0jcvXZovZeKr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbeASU7U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jan 2018 15:59:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptesarik@suse.com, aryabinin@virtuozzo.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer
has been added to the -mm tree.  Its filename is
     fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer

The comment is confusing.  On the one hand, it refers to 32-bit alignment
(struct page alignment on 32-bit platforms), but this would only guarantee
that the 2 lowest bits must be zero.  On the other hand, it claims that at
least 3 bits are available, and 3 bits are actually used.

This is not broken, because there is a stronger alignment guarantee, just
less obvious.  Let's fix the comment to make it clear how many bits are
available and why.

Link: http://lkml.kernel.org/r/20180119080908.3a662e6f@ezekiel.suse.cz
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemi Wang <kemi.wang@intel.com>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer include/linux/mmzone.h
--- a/include/linux/mmzone.h~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer
+++ a/include/linux/mmzone.h
@@ -1166,8 +1166,16 @@ extern unsigned long usemap_size(void);
 
 /*
  * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  There should be at least
- * 3 bits here due to 32-bit alignment.
+ * a little bit of information.  The pointer is calculated
+ * as mem_map - section_nr_to_pfn(pnum).  The result is
+ * aligned to the minimum alignment of the two values:
+ *   1. All mem_map arrays are page-aligned.
+ *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
+ *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
+ *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
+ *      worst combination is powerpc with 256k pages,
+ *      which results in PFN_SECTION_SHIFT equal 6.
+ * To sum it up, at least 6 bits are available.
  */
 #define	SECTION_MARKED_PRESENT	(1UL<<0)
 #define SECTION_HAS_MEM_MAP	(1UL<<1)
_

Patches currently in -mm which might be from ptesarik@suse.com are

fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch

