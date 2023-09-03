Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA452C83F2C
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 02:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjICCZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 22:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbjICCZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 22:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166D4CCA
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 19:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD55EB80A7C
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 02:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936A8C433C7;
        Sun,  3 Sep 2023 02:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693707940;
        bh=2QDR+Q++/MUQcRD0+nL/6s2mWHm3HpK9ciHw3s0hI5k=;
        h=Date:To:From:Subject:From;
        b=GQ/WuwoREJLQFk1k/J4Qk8/j6cY2FJp2qCnQf5SG5X4LrpSbZLkP7hNGoH0Iy4pn5
         st2fCJZveJB6uDsPkTO9uiV+ePcOh608uAcm0Kx9wW/m+2SND78BE9akp0F1ZWM9F+
         DaYpwhoX5e3l+iKa2yDsQoAh5P9v/eYsSTsPUwsM=
Date:   Sat, 02 Sep 2023 19:25:39 -0700
To:     mm-commits@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, mel@csn.ul.ie, lee.schermerhorn@hp.com,
        andi@firstfloor.org, xueshi.hu@smartx.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch added to mm-unstable branch
Message-Id: <20230903022540.936A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: fix nodes huge page allocation when there are surplus pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xueshi Hu <xueshi.hu@smartx.com>
Subject: mm/hugeltb: fix nodes huge page allocation when there are surplus pages
Date: Tue, 29 Aug 2023 11:33:43 +0800

In set_nr_huge_pages(), local variable "count" is used to record
persistent_huge_pages(), but when it cames to nodes huge page allocation,
the semantics changes to nr_huge_pages.  When there exists surplus huge
pages and using the interface under
/sys/devices/system/node/node*/hugepages to change huge page pool size,
this difference can result in the allocation of an unexpected number of
huge pages.

Steps to reproduce the bug:

Starting with:

				  Node 0          Node 1    Total
	HugePages_Total             0.00            0.00     0.00
	HugePages_Free              0.00            0.00     0.00
	HugePages_Surp              0.00            0.00     0.00

create 100 huge pages in Node 0 and consume it, then set Node 0 's
nr_hugepages to 0.

yields:

				  Node 0          Node 1    Total
	HugePages_Total           200.00            0.00   200.00
	HugePages_Free              0.00            0.00     0.00
	HugePages_Surp            200.00            0.00   200.00

write 100 to Node 1's nr_hugepages

		echo 100 > /sys/devices/system/node/node1/\
	hugepages/hugepages-2048kB/nr_hugepages

gets:

				  Node 0          Node 1    Total
	HugePages_Total           200.00          400.00   600.00
	HugePages_Free              0.00          400.00   400.00
	HugePages_Surp            200.00            0.00   200.00

Kernel is expected to create only 100 huge pages and it gives 200.

Link: https://lkml.kernel.org/r/20230829033343.467779-1-xueshi.hu@smartx.com
Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages
+++ a/mm/hugetlb.c
@@ -3457,7 +3457,9 @@ static int set_max_huge_pages(struct hst
 	if (nid != NUMA_NO_NODE) {
 		unsigned long old_count = count;
 
-		count += h->nr_huge_pages - h->nr_huge_pages_node[nid];
+		count += persistent_huge_pages(h) -
+			 (h->nr_huge_pages_node[nid] -
+			  h->surplus_huge_pages_node[nid]);
 		/*
 		 * User may have specified a large count value which caused the
 		 * above calculation to overflow.  In this case, they wanted
_

Patches currently in -mm which might be from xueshi.hu@smartx.com are

mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch

