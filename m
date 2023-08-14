Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9A3EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjHNUcg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjHNUc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639ACE5E
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01892617AA
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48269C433C7;
        Mon, 14 Aug 2023 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692045144;
        bh=XxowjPPskGwZyWcxCW9INVesZ/pGmfKaovFItCJed0g=;
        h=Date:To:From:Subject:From;
        b=CHiwsVhgmXJktv7qovgFLuvP0m+zps8WrvoYId8hoCZtNaJ5uJq7w2zuUP4vkXmOW
         dhH+XglXzbDSNw7BQd/337pLOsWL0+n0VF/mLiRi2EBwigoOctL2nf0dHr1HvzIbzj
         4lcMlROazB7w45Pm60bZSSrqIDAEhzX667kvgrmE=
Date:   Mon, 14 Aug 2023 13:32:23 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-pages-scanned-metric.patch added to mm-unstable branch
Message-Id: <20230814203224.48269C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: add pages scanned metric
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-pages-scanned-metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-pages-scanned-metric.patch

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
Cc: David Hildenbrand <david@redhat.com>
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
 
@@ -2483,8 +2486,9 @@ static void ksm_do_scan(unsigned int sca
 {
 	struct ksm_rmap_item *rmap_item;
 	struct page *page;
+	unsigned int npages = scan_npages;
 
-	while (scan_npages-- && likely(!freezing(current))) {
+	while (npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
@@ -2492,6 +2496,8 @@ static void ksm_do_scan(unsigned int sca
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
 	}
+
+	ksm_pages_scanned += scan_npages - npages;
 }
 
 static int ksmd_should_run(void)
@@ -3332,6 +3338,13 @@ static ssize_t max_page_sharing_store(st
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
@@ -3440,6 +3453,7 @@ static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
 	&run_attr.attr,
+	&pages_scanned_attr.attr,
 	&pages_shared_attr.attr,
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
_

Patches currently in -mm which might be from shr@devkernel.io are

proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch
mm-ksm-add-pages-scanned-metric.patch

