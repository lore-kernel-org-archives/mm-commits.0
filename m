Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABACC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjBCGnn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjBCGmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F021A48E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C5D61DB1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB35C4339B;
        Fri,  3 Feb 2023 06:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406300;
        bh=IwLtTMOZJZocttWx8SW2FMAryX/qQdOXnulDp49QR18=;
        h=Date:To:From:Subject:From;
        b=D6iYcbWp7RjtbqXkh3fXL8LoZH1IZ2LQQeDVdQOhxdaaSrQr1uwcYCBzKWq6uCTLl
         PoaNrKD57nIEJtoFJhvyUcYRjQ1Wm0rOQ8TyUmRcidFvoJ/oMC+5sjYgfDuvAlc0r7
         wKxO6mYWyIkmVmqRV3cOFdTrZeU5xOcjqv8KlXnI=
Date:   Thu, 02 Feb 2023 22:38:19 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        rientjes@google.com, mhocko@kernel.org, iamjoonsoo.kim@lge.com,
        david@redhat.com, 42.hyeyoo@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch removed from -mm tree
Message-Id: <20230203063820.0DB35C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_owner: record single timestamp value for high order allocations
has been removed from the -mm tree.  Its filename was
     mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/page_owner: record single timestamp value for high order allocations
Date: Sun, 22 Jan 2023 01:50:54 +0900

When allocating a high-order page, separate allocation timestamp is
recorded for each sub-page resulting in different timestamp values between
them.

This behavior is not consistent with the behavior when recording free
timestamp and caused confusion when analyzing memory dumps.  Record single
timestamp for the entire allocation, aligning with the behavior for free
timestamps.

Link: https://lkml.kernel.org/r/20230121165054.520507-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_owner.c~mm-page_owner-record-single-timestamp-value-for-high-order-allocations
+++ a/mm/page_owner.c
@@ -163,6 +163,7 @@ static inline void __set_page_owner_hand
 {
 	struct page_owner *page_owner;
 	int i;
+	u64 ts_nsec = local_clock();
 
 	for (i = 0; i < (1 << order); i++) {
 		page_owner = get_page_owner(page_ext);
@@ -172,7 +173,7 @@ static inline void __set_page_owner_hand
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
 		page_owner->tgid = current->tgid;
-		page_owner->ts_nsec = local_clock();
+		page_owner->ts_nsec = ts_nsec;
 		strscpy(page_owner->comm, current->comm,
 			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch

