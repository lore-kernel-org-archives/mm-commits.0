Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E54EE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjHUUoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjHUUna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D78CEC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D74DF64B2C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B719C433C7;
        Mon, 21 Aug 2023 20:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650528;
        bh=6qCqDyhVeXKixIBVooAl0hpkT1CjGuwsoSgFTIOA434=;
        h=Date:To:From:Subject:From;
        b=VIdb2CMqEiu2Kiz2o161vuo0sYcPlfVBB0aSm8tgsbtUIV9wJ3nLIRr/ghHLcrYsa
         DB3ndlQ2cFiH6YMTOh0Eb/w/CqXsTK41ekqSFpU6rIClPVb1L3W8y9WMGqWTDp21Ot
         nsdC0BWHOS2bswdDYOH1aopEyEhlmC0YSkfUJ5PY=
Date:   Mon, 21 Aug 2023 13:42:07 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-add-pages-scanned-metric.patch removed from -mm tree
Message-Id: <20230821204208.3B719C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: add pages scanned metric
has been removed from the -mm tree.  Its filename was
     mm-ksm-add-pages-scanned-metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: add pages scanned metric
Date: Fri, 11 Aug 2023 12:36:55 -0700

ksm currently maintains several statistics, which let you determine how
successful KSM is at sharing pages.  However it does not contain a metric
to determine how much work it does.

This commit adds the pages scanned metric.  This allows the administrator
to determine how many pages have been scanned over a period of time.

Link: https://lkml.kernel.org/r/20230811193655.2518943-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    2 ++
 mm/ksm.c                             |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-add-pages-scanned-metric
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -159,6 +159,8 @@ The effectiveness of KSM and MADV_MERGEA
 
 general_profit
         how effective is KSM. The calculation is explained below.
+pages_scanned
+        how many pages are being scanned for ksm
 pages_shared
         how many shared pages are being used
 pages_sharing
--- a/mm/ksm.c~mm-ksm-add-pages-scanned-metric
+++ a/mm/ksm.c
@@ -242,6 +242,9 @@ static struct kmem_cache *rmap_item_cach
 static struct kmem_cache *stable_node_cache;
 static struct kmem_cache *mm_slot_cache;
 
+/* The number of pages scanned */
+static unsigned long ksm_pages_scanned;
+
 /* The number of nodes in the stable tree */
 static unsigned long ksm_pages_shared;
 
@@ -2476,8 +2479,9 @@ static void ksm_do_scan(unsigned int sca
 {
 	struct ksm_rmap_item *rmap_item;
 	struct page *page;
+	unsigned int npages = scan_npages;
 
-	while (scan_npages-- && likely(!freezing(current))) {
+	while (npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
@@ -2485,6 +2489,8 @@ static void ksm_do_scan(unsigned int sca
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
 	}
+
+	ksm_pages_scanned += scan_npages - npages;
 }
 
 static int ksmd_should_run(void)
@@ -3323,6 +3329,13 @@ static ssize_t max_page_sharing_store(st
 }
 KSM_ATTR(max_page_sharing);
 
+static ssize_t pages_scanned_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_pages_scanned);
+}
+KSM_ATTR_RO(pages_scanned);
+
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
@@ -3431,6 +3444,7 @@ static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
 	&run_attr.attr,
+	&pages_scanned_attr.attr,
 	&pages_shared_attr.attr,
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
_

Patches currently in -mm which might be from shr@devkernel.io are


