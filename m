Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FB7C3063F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 17:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjGCRjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjGCRjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jul 2023 13:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6F5CE
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 10:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 929D360FFC
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 17:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DF0C433C8;
        Mon,  3 Jul 2023 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688405945;
        bh=2qJXFKXWiflNdDmjU4+/37TQFLmcOGN1kcaCys9O16o=;
        h=Date:To:From:Subject:From;
        b=ssJxbzp61cD8UgRrp8Rbp6Hdvce7w9aK4rUlEwJU+fNTA9haBx19K6mozByEaJVR/
         gl/JpN4vMezLYyPoDeLkyfJv5QAX5csQQ+nRvBPbhufG3NgVN3oj51DPQ6KUUg4EA3
         8WzN6/mU6t0Wp63Yjrev6gaE0zPTQ7C7s1UEhzUM=
Date:   Mon, 03 Jul 2023 10:39:04 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch added to mm-unstable branch
Message-Id: <20230703173904.E2DF0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: consider KSM-placed zeropages when calculating KSM profit
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch

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

ksm-support-unsharing-ksm-placed-zero-pages.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-add-ksm-zero-pages-for-each-process.patch
ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch
selftest-add-a-testcase-of-ksm-zero-pages.patch

