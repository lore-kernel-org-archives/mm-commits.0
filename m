Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5961C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76ABF21D42
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486626;
	bh=hNBFEmkKMa6Mb1AbM3tl5a2PsNuws+6IPtroYyeTNdM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bBwwyNltNdhbM3HYikYb+p3x2afqx6Kuv8wEF5WZtLqAXG2relcUE5lNxcS5xJEqa
	 dODVP8SrJGZsLC62aoUw2h0fRxAgKhjqfWIiM4LAZeQ5CYNZMmEIiZdu9+475cvlSf
	 NmIGBUUWVeukkg5dubH+tZos3ePGpxWwDmRz3Vh0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgISDhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISDhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:37:05 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE2721897;
        Sat, 19 Sep 2020 03:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486624;
        bh=hNBFEmkKMa6Mb1AbM3tl5a2PsNuws+6IPtroYyeTNdM=;
        h=Date:From:To:Subject:From;
        b=HX8jquEgySQreoLttXrirDxl2eUz50XvKlhcrzaJ7EEBpvAcspfFPUumZxneC27C0
         10SZbj7QNVNlekyNoM2MR9P3pJ8we5e/JwTwR3ZNO420T6lLDrBfFLVoC0e/zOa6ES
         FqjQOM5+KnfSoxksPGwwlBxgcRYrMRwG72cKVpCk=
Date:   Fri, 18 Sep 2020 20:37:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        mike.kravetz@oracle.com, julia.lawall@inria.fr,
        gregkh@linuxfoundation.org, efremov@linux.com,
        alex.dewar90@gmail.com, joe@perches.com
Subject:  [to-be-updated]
 mm-and-drivers-core-convert-hugetlb_report_node_meminfo-to-sysfs_emit.patch
 removed from -mm tree
Message-ID: <20200919033703.T3TC8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: and drivers core: convert hugetlb_report_node_meminfo to sysfs_emit
has been removed from the -mm tree.  Its filename was
     mm-and-drivers-core-convert-hugetlb_report_node_meminfo-to-sysfs_emit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: and drivers core: convert hugetlb_report_node_meminfo to sysfs_emit

Convert the unbound sprintf in hugetlb_report_node_meminfo to use
sysfs_emit_at so that no possible overrun of a PAGE_SIZE buf can occur.

Link: https://lkml.kernel.org/r/894b351b82da6013cde7f36ff4b5493cd0ec30d0.1600285923.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J.Wysocki" <rafael@kernel.org>
Cc: Denis Efremov <efremov@linux.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Alex Dewar <alex.dewar90@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c     |    2 +-
 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   18 ++++++++++--------
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/base/node.c~mm-and-drivers-core-convert-hugetlb_report_node_meminfo-to-sysfs_emit
+++ a/drivers/base/node.c
@@ -467,7 +467,7 @@ static ssize_t node_read_meminfo(struct
 				       HPAGE_PMD_NR)
 #endif
 		       );
-	n += hugetlb_report_node_meminfo(nid, buf + n);
+	n += hugetlb_report_node_meminfo(buf, n, nid);
 	return n;
 }
 
--- a/include/linux/hugetlb.h~mm-and-drivers-core-convert-hugetlb_report_node_meminfo-to-sysfs_emit
+++ a/include/linux/hugetlb.h
@@ -129,7 +129,7 @@ void __unmap_hugepage_range(struct mmu_g
 				unsigned long start, unsigned long end,
 				struct page *ref_page);
 void hugetlb_report_meminfo(struct seq_file *);
-int hugetlb_report_node_meminfo(int, char *);
+int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo(void);
 unsigned long hugetlb_total_pages(void);
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -245,7 +245,7 @@ static inline void hugetlb_report_meminf
 {
 }
 
-static inline int hugetlb_report_node_meminfo(int nid, char *buf)
+static inline int hugetlb_report_node_meminfo(char *buf, int len, int nid)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mm-and-drivers-core-convert-hugetlb_report_node_meminfo-to-sysfs_emit
+++ a/mm/hugetlb.c
@@ -3582,18 +3582,20 @@ void hugetlb_report_meminfo(struct seq_f
 	seq_printf(m, "Hugetlb:        %8lu kB\n", total / 1024);
 }
 
-int hugetlb_report_node_meminfo(int nid, char *buf)
+int hugetlb_report_node_meminfo(char *buf, int len, int nid)
 {
 	struct hstate *h = &default_hstate;
+
 	if (!hugepages_supported())
 		return 0;
-	return sprintf(buf,
-		"Node %d HugePages_Total: %5u\n"
-		"Node %d HugePages_Free:  %5u\n"
-		"Node %d HugePages_Surp:  %5u\n",
-		nid, h->nr_huge_pages_node[nid],
-		nid, h->free_huge_pages_node[nid],
-		nid, h->surplus_huge_pages_node[nid]);
+
+	return sysfs_emit_at(buf, len,
+			     "Node %d HugePages_Total: %5u\n"
+			     "Node %d HugePages_Free:  %5u\n"
+			     "Node %d HugePages_Surp:  %5u\n",
+			     nid, h->nr_huge_pages_node[nid],
+			     nid, h->free_huge_pages_node[nid],
+			     nid, h->surplus_huge_pages_node[nid]);
 }
 
 void hugetlb_show_meminfo(void)
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
checkpatch-warn-on-self-assignments.patch
checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

