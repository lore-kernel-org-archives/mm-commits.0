Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7574ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiILAkz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiILAkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:40:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1407B1BE9A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:40:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C124EB80B06
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F4BC433C1;
        Mon, 12 Sep 2022 00:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943251;
        bh=gguT+51VpF5/kdaUUqWojAlcS/mD/ZqOmxEdZ2fy5VA=;
        h=Date:To:From:Subject:From;
        b=qaRABPYowf6wSezBAqI3XV16DP5wsgMSplVvYeT0OH+OkgMqdq1dQmx40Co4S1eIE
         1a9tn5dw1UcZ2BhPUSMfxycjohBWMneWlIk1d4Pfd/ST84lMXg9qcj2fKEMlArKVaV
         5tformlHKTsFmsRBEM2EamDYVqth6eEyf2dALWFM=
Date:   Sun, 11 Sep 2022 17:40:50 -0700
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        vbabka@suse.cz, sjpark@amazon.de, sieberf@amazon.com,
        shakeelb@google.com, quic_pkondeti@quicinc.com,
        pasha.tatashin@soleen.com, minchan@google.com, mhocko@suse.com,
        david@redhat.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch removed from -mm tree
Message-Id: <20220912004051.79F4BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5
has been removed from the -mm tree.  Its filename was
     mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch

This patch was dropped because it was folded into mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5
Date: Fri, 26 Aug 2022 12:26:33 +0530

rename label `loop' to `ext_put_continue' per David

Link: https://lkml.kernel.org/r/1661496993-11473-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavan Kondeti <quic_pkondeti@quicinc.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_owner.c~mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5
+++ a/mm/page_owner.c
@@ -326,7 +326,7 @@ void pagetypeinfo_showmixedcount_print(s
 				continue;
 
 			if (!test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags))
-				goto loop;
+				goto ext_put_continue;
 
 			page_owner = get_page_owner(page_ext);
 			page_mt = gfp_migratetype(page_owner->gfp_mask);
@@ -341,7 +341,7 @@ void pagetypeinfo_showmixedcount_print(s
 				break;
 			}
 			pfn += (1UL << page_owner->order) - 1;
-loop:
+ext_put_continue:
 			page_ext_put(page_ext);
 		}
 	}
@@ -561,14 +561,14 @@ read_page_owner(struct file *file, char
 		 * because we don't hold the zone lock.
 		 */
 		if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
-			goto loop;
+			goto ext_put_continue;
 
 		/*
 		 * Although we do have the info about past allocation of free
 		 * pages, it's not relevant for current memory usage.
 		 */
 		if (!test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags))
-			goto loop;
+			goto ext_put_continue;
 
 		page_owner = get_page_owner(page_ext);
 
@@ -577,7 +577,7 @@ read_page_owner(struct file *file, char
 		 * would inflate the stats.
 		 */
 		if (!IS_ALIGNED(pfn, 1 << page_owner->order))
-			goto loop;
+			goto ext_put_continue;
 
 		/*
 		 * Access to page_ext->handle isn't synchronous so we should
@@ -585,7 +585,7 @@ read_page_owner(struct file *file, char
 		 */
 		handle = READ_ONCE(page_owner->handle);
 		if (!handle)
-			goto loop;
+			goto ext_put_continue;
 
 		/* Record the next PFN to read in the file offset */
 		*ppos = (pfn - min_low_pfn) + 1;
@@ -594,7 +594,7 @@ read_page_owner(struct file *file, char
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
 				&page_owner_tmp, handle);
-loop:
+ext_put_continue:
 		page_ext_put(page_ext);
 	}
 
@@ -654,13 +654,13 @@ static void init_pages_in_zone(pg_data_t
 
 			/* Maybe overlapping zone */
 			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
-				goto loop;
+				goto ext_put_continue;
 
 			/* Found early allocated page */
 			__set_page_owner_handle(page_ext, early_handle,
 						0, 0);
 			count++;
-loop:
+ext_put_continue:
 			page_ext_put(page_ext);
 		}
 		cond_resched();
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-page_ext-remove-unused-variable-in-offline_page_ext.patch
mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch
mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

