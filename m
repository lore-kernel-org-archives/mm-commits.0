Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09BDECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiH0DUQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiH0DUP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED516587
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 137FFB83388
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BBCC433C1;
        Sat, 27 Aug 2022 03:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570406;
        bh=ITMbX88tOo6mn3I4c4T7QCsxEyDC0fqwIxgsXhxTvnk=;
        h=Date:To:From:Subject:From;
        b=yUKVVoXKOLjtKsAy4riCbQsULWC/ZRT+Ucv7lQAltyoasxt7peDTg1YTyeWkXtk2+
         6YUWDxA+Q2Wi6kpU/Ytlc7aiKq5NSWVYmM8aUqSsiucj91+WA6K9Ikba6qYuRTbQUn
         TREX6zc/WvLT6jtD7Csz5PMUBCWa9JiUn7ZSTvmc=
Date:   Fri, 26 Aug 2022 20:20:05 -0700
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        vbabka@suse.cz, sjpark@amazon.de, sieberf@amazon.com,
        shakeelb@google.com, quic_pkondeti@quicinc.com,
        pasha.tatashin@soleen.com, minchan@google.com, mhocko@suse.com,
        david@redhat.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch added to mm-unstable branch
Message-Id: <20220827032006.B1BBCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch

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
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch
mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch
mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline-v5.patch

