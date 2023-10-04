Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8A5E7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjJDURs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJDURr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E1393
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F16C433C9;
        Wed,  4 Oct 2023 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450663;
        bh=aBqZd1FSbAKnCqLGYT74cdCNuLJqTdyodp1gEeh9yQ8=;
        h=Date:To:From:Subject:From;
        b=geJS8GnwAvroK4VVDqcJK0KgqGc9ExUlZaJvzotaW5piqcPhC4yaeYambqWCZoWBr
         Iug+l3QpZ+wpvvLEJY0irrJSWFK+w2fOoq0tb+Br6C6BqK6tjvuTg/EEY9vS3xeskp
         S3gciXmcYpwO16lZJUxaIA9ZxGNIEL9izGbgrXMM=
Date:   Wed, 04 Oct 2023 13:17:41 -0700
To:     mm-commits@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, mel@csn.ul.ie, lee.schermerhorn@hp.com,
        andi@firstfloor.org, xueshi.hu@smartx.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch removed from -mm tree
Message-Id: <20231004201743.12F16C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix nodes huge page allocation when there are surplus pages
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-fix-nodes-huge-page-allocation-when-there-are-surplus-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xueshi Hu <xueshi.hu@smartx.com>
Subject: mm/hugetlb: fix nodes huge page allocation when there are surplus pages
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


