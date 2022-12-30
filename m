Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563CBC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 22:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbiL3WB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbiL3WBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 17:01:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EBC1CFFA
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 14:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7F661C2C
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 22:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81860C433D2;
        Fri, 30 Dec 2022 22:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437699;
        bh=uxBgpL/JN9LnSLz+R4S/mau9Gd1ys8wuLJbBN+sKjSY=;
        h=Date:To:From:Subject:From;
        b=IVXgS6aZ1UqwqOmAG3PuBNH2FOgBRcTL3ivRZOC3O/REs1O/HLyczljk9vFfyzJJP
         fWikCicyRwBPWlstvtct4WsgIhnYFqz1KSFDnlIw+DQSobfEx9LrYVG8hJMtBVFcBw
         WtfSMTcamdt9b7EuIlh0J37J0TYCeWlF7xuGW7r4=
Date:   Fri, 30 Dec 2022 14:01:38 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-count-all-zero-pages-placed-by-ksm.patch added to mm-unstable branch
Message-Id: <20221230220139.81860C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: count all zero pages placed by KSM
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-count-all-zero-pages-placed-by-ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-count-all-zero-pages-placed-by-ksm.patch

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
Subject: ksm: count all zero pages placed by KSM
Date: Fri, 30 Dec 2022 09:15:14 +0800 (CST)

As pages_sharing and pages_shared don't include the number of zero pages
merged by KSM, we cannot know how many pages are zero pages placed by KSM
when enabling use_zero_pages, which leads to KSM not being transparent
with all actual merged pages by KSM.  In the early days of use_zero_pages,
zero-pages was unable to get unshared by the ways like MADV_UNMERGEABLE so
it's hard to count how many times one of those zeropages was then
unmerged.

But now, unsharing KSM-placed zero page accurately has been achieved, so
we can easily count both how many times a page full of zeroes was merged
with zero-page and how many times one of those pages was then unmerged. 
and so, it helps to estimate memory demands when each and every shared
page could get unshared.

So we add zero_pages_sharing under /sys/kernel/mm/ksm/ to show the number
of all zero pages placed by KSM.

Link: https://lkml.kernel.org/r/202212300915147801864@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~ksm-count-all-zero-pages-placed-by-ksm
+++ a/mm/ksm.c
@@ -276,6 +276,9 @@ static unsigned int zero_checksum __read
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
+/* The number of zero pages placed by KSM use_zero_pages */
+static unsigned long ksm_zero_pages_sharing;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -789,8 +792,10 @@ stale:
  */
 static inline void clean_rmap_item_zero_flag(struct ksm_rmap_item *rmap_item)
 {
-	if (rmap_item->address & ZERO_PAGE_FLAG)
+	if (rmap_item->address & ZERO_PAGE_FLAG) {
+		ksm_zero_pages_sharing--;
 		rmap_item->address &= PAGE_MASK;
+	}
 }
 
 /* Only called when rmap_item is going to be freed */
@@ -2109,8 +2114,10 @@ static int try_to_merge_with_kernel_zero
 		if (vma) {
 			err = try_to_merge_one_page(vma, page,
 						ZERO_PAGE(rmap_item->address));
-			if (!err)
+			if (!err) {
 				rmap_item->address |= ZERO_PAGE_FLAG;
+				ksm_zero_pages_sharing++;
+			}
 		} else {
 			/* If the vma is out of date, we do not need to continue. */
 			err = 0;
@@ -3228,6 +3235,13 @@ static ssize_t pages_volatile_show(struc
 }
 KSM_ATTR_RO(pages_volatile);
 
+static ssize_t zero_pages_sharing_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%ld\n", ksm_zero_pages_sharing);
+}
+KSM_ATTR_RO(zero_pages_sharing);
+
 static ssize_t stable_node_dups_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
@@ -3283,6 +3297,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
+	&zero_pages_sharing_attr.attr,
 	&full_scans_attr.attr,
 #ifdef CONFIG_NUMA
 	&merge_across_nodes_attr.attr,
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

