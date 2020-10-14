Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A983C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FAA2224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709315;
	bh=xlC8WKr7aDgPSs3OY3AoXL87NhO7yWLgpjaSZpQ+MpY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yNiYmWoAMd39GWYLkK5z4UKNH6yeZINFVO1M9FC5gYxTJ6Oq3oOhCPezzqKCSq/2+
	 4lmRyiDvj8xiL+3gf/bbGGQP5koCbySIP7Ev4Z7O5B7aIAGMwfexi8EV8p2H+ZYUvU
	 dEIAIFL6vKLndPXdYTuwgF5UlroWOnmS/CQpnGg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgJNVBY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730477AbgJNVBY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA7320725;
        Wed, 14 Oct 2020 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709283;
        bh=xlC8WKr7aDgPSs3OY3AoXL87NhO7yWLgpjaSZpQ+MpY=;
        h=Date:From:To:Subject:From;
        b=AgPLxrX5B1MC1W+kaiJ/jY5voKIvizD/+u/4JI7f+4l1cy5MIApaUdFCmsa1/9Qf/
         qJFH8JhXKxbVibTVkd2tmMGI80KLbAAZ34blqXt1Vvc/iumB+7EirDvjzd6hyZd/rN
         hFp56tPyhw7X2SUjMUDplIGzCWAS0AUgDQRTi/a0=
Date:   Wed, 14 Oct 2020 14:01:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-mmap-check-on-file-instead-of-the-rb=5Froot=5Fcached-of?=
 =?US-ASCII?Q?-its-address=5Fspace.patch?= removed from -mm tree
Message-ID: <20201014210123.tEekeFslT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: check on file instead of the rb_root_cached of its address_space
has been removed from the -mm tree.  Its filename was
     mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: check on file instead of the rb_root_cached of its address_space

In __vma_adjust(), we do the check on *root* to decide whether to adjust
the address_space.  It seems to be more meaningful to do the check on
*file* itself.  This means we are adjusting some data because it is a file
backed vma.

Since we seem to assume the address_space is valid if it is a file backed
vma, let's just replace *root* with *file* here.

Link: https://lkml.kernel.org/r/20200913133631.37781-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space
+++ a/mm/mmap.c
@@ -823,7 +823,7 @@ again:
 			anon_vma_interval_tree_pre_update_vma(next);
 	}
 
-	if (root) {
+	if (file) {
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, root);
 		if (adjust_next)
@@ -844,7 +844,7 @@ again:
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
-	if (root) {
+	if (file) {
 		if (adjust_next)
 			vma_interval_tree_insert(next, root);
 		vma_interval_tree_insert(vma, root);
@@ -896,7 +896,7 @@ again:
 		anon_vma_unlock_write(anon_vma);
 	}
 
-	if (root) {
+	if (file) {
 		i_mmap_unlock_write(mapping);
 		uprobe_mmap(vma);
 
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

