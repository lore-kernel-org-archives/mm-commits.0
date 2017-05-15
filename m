From: akpm@linux-foundation.org
Subject: +
 mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch added to
 -mm tree
Date: Mon, 15 May 2017 14:27:00 -0700
Message-ID: <591a1d24.j/pYkveaiqH3p9h+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758956AbdEOV1L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip over holes in __reset_isolation_suitable
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch

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
Subject: mm, compaction: skip over holes in __reset_isolation_suitable

__reset_isolation_suitable walks the whole zone pfn range and it tries to
jump over holes by checking the zone for each page.  It might still
stumble over offline pages, though.  Skip those by checking
pfn_to_online_page()

Link: http://lkml.kernel.org/r/20170515085827.16474-9-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-over-holes-in-__reset_isolation_suitable mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-over-holes-in-__reset_isolation_suitable
+++ a/mm/compaction.c
@@ -236,10 +236,9 @@ static void __reset_isolation_suitable(s
 
 		cond_resched();
 
-		if (!pfn_valid(pfn))
+		page = pfn_to_online_page(pfn);
+		if (!page)
 			continue;
