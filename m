Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A62CE94131
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjJFVtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJFVtZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:49:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37045BE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:49:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E4C433C8;
        Fri,  6 Oct 2023 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628963;
        bh=7Y8NZInUx7dLzqw11S9OdF/J4qU1KaWvuRglaOB5Du8=;
        h=Date:To:From:Subject:From;
        b=xGzTYQhITPo/OVQMby8BrBl4pm74s8Qz79A8lBNq9OSZur17fwoIUx6fUqrNodAee
         T9N88HEthTpko/9eL3e6UfnzlrEKxmBv4nvlSkCc4Y3N5Vs0d64wLVgzWji2ldeeSo
         2JtkNd4dFQqZOv2lRgmA4YLnsojs5T7tbKLNzq1E=
Date:   Fri, 06 Oct 2023 14:49:21 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-add-pages_skipped-metric.patch removed from -mm tree
Message-Id: <20231006214923.706E4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: add pages_skipped metric
has been removed from the -mm tree.  Its filename was
     mm-ksm-add-pages_skipped-metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: add pages_skipped metric
Date: Mon, 25 Sep 2023 21:09:37 -0700

This change adds the "pages skipped" metric.  To be able to evaluate how
successful smart page scanning is, the pages skipped metric can be
compared to the pages scanned metric.

The pages skipped metric is a cumulative counter.  The counter is stored
under /sys/kernel/mm/ksm/pages_skipped.

Link: https://lkml.kernel.org/r/20230926040939.516161-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/ksm.c~mm-ksm-add-pages_skipped-metric
+++ a/mm/ksm.c
@@ -294,6 +294,9 @@ static bool ksm_smart_scan = true;
 /* The number of zero pages which is placed by KSM */
 unsigned long ksm_zero_pages;
 
+/* The number of pages that have been skipped due to "smart scanning" */
+static unsigned long ksm_pages_skipped;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -2377,6 +2380,7 @@ static bool should_skip_rmap_item(struct
 	}
 
 	/* Skip this page */
+	ksm_pages_skipped++;
 	rmap_item->remaining_skips--;
 	remove_rmap_item_from_tree(rmap_item);
 	return true;
@@ -3464,6 +3468,13 @@ static ssize_t pages_volatile_show(struc
 }
 KSM_ATTR_RO(pages_volatile);
 
+static ssize_t pages_skipped_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_pages_skipped);
+}
+KSM_ATTR_RO(pages_skipped);
+
 static ssize_t ksm_zero_pages_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
@@ -3561,6 +3572,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
+	&pages_skipped_attr.attr,
 	&ksm_zero_pages_attr.attr,
 	&full_scans_attr.attr,
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from shr@devkernel.io are


