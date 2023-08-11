Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082E2C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbjHKXAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbjHKW7g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580953A82
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD99C67AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A77EC433C8;
        Fri, 11 Aug 2023 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794758;
        bh=li1A+8ieOsmIF4NdQbtBWGX3WYukpeYKj2oKQ0snruM=;
        h=Date:To:From:Subject:From;
        b=jPwF+F6RjSc+nnur5L2NIUYhwYxEUF+w2rMak9GuBMJ+BxpX4SrQgFReiipC0puM6
         pyj+COxlmEGE1sNZtgTR9nq5KviU6zRoQNITeVCCoGKNWt/ufEODYti0zXCsvJ+V9Q
         2azVcDRBe3Z4OG7vqZ9wf6O5CuhUz4NCe4NreyZk=
Date:   Fri, 11 Aug 2023 15:59:17 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch removed from -mm tree
Message-Id: <20230811225918.1A77EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: consider KSM-placed zeropages when calculating KSM profit
has been removed from the -mm tree.  Its filename was
     ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: consider KSM-placed zeropages when calculating KSM profit
Date: Tue, 13 Jun 2023 11:09:42 +0800

When use_zero_pages is enabled, the calculation of ksm profit is not
correct because ksm zero pages is not counted in.  So update the
calculation of KSM profit including the documentation.

Link: https://lkml.kernel.org/r/20230613030942.186041-1-yang.yang29@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Jiang Xuexin <jiang.xuexin@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |   18 +++++++++++-------
 mm/ksm.c                             |    4 ++--
 2 files changed, 13 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -203,21 +203,25 @@ several times, which are unprofitable me
 1) How to determine whether KSM save memory or consume memory in system-wide
    range? Here is a simple approximate calculation for reference::
 
-	general_profit =~ pages_sharing * sizeof(page) - (all_rmap_items) *
+	general_profit =~ ksm_saved_pages * sizeof(page) - (all_rmap_items) *
 			  sizeof(rmap_item);
 
-   where all_rmap_items can be easily obtained by summing ``pages_sharing``,
-   ``pages_shared``, ``pages_unshared`` and ``pages_volatile``.
+   where ksm_saved_pages equals to the sum of ``pages_sharing`` +
+   ``ksm_zero_pages`` of the system, and all_rmap_items can be easily
+   obtained by summing ``pages_sharing``, ``pages_shared``, ``pages_unshared``
+   and ``pages_volatile``.
 
 2) The KSM profit inner a single process can be similarly obtained by the
    following approximate calculation::
 
-	process_profit =~ ksm_merging_pages * sizeof(page) -
+	process_profit =~ ksm_saved_pages * sizeof(page) -
 			  ksm_rmap_items * sizeof(rmap_item).
 
-   where ksm_merging_pages is shown under the directory ``/proc/<pid>/``,
-   and ksm_rmap_items is shown in ``/proc/<pid>/ksm_stat``. The process profit
-   is also shown in ``/proc/<pid>/ksm_stat`` as ksm_process_profit.
+   where ksm_saved_pages equals to the sum of ``ksm_merging_pages`` and
+   ``ksm_zero_pages``, both of which are shown under the directory
+   ``/proc/<pid>/ksm_stat``, and ksm_rmap_items is also shown in
+   ``/proc/<pid>/ksm_stat``. The process profit is also shown in
+   ``/proc/<pid>/ksm_stat`` as ksm_process_profit.
 
 From the perspective of application, a high ratio of ``ksm_rmap_items`` to
 ``ksm_merging_pages`` means a bad madvise-applied policy, so developers or
--- a/mm/ksm.c~ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit
+++ a/mm/ksm.c
@@ -3092,7 +3092,7 @@ static void wait_while_offlining(void)
 #ifdef CONFIG_PROC_FS
 long ksm_process_profit(struct mm_struct *mm)
 {
-	return mm->ksm_merging_pages * PAGE_SIZE -
+	return (long)(mm->ksm_merging_pages + mm->ksm_zero_pages) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
 #endif /* CONFIG_PROC_FS */
@@ -3373,7 +3373,7 @@ static ssize_t general_profit_show(struc
 {
 	long general_profit;
 
-	general_profit = ksm_pages_sharing * PAGE_SIZE -
+	general_profit = (ksm_pages_sharing + ksm_zero_pages) * PAGE_SIZE -
 				ksm_rmap_items * sizeof(struct ksm_rmap_item);
 
 	return sysfs_emit(buf, "%ld\n", general_profit);
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


