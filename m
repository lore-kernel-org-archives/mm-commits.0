Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7139DC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiILD2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiILD2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2433B25C6B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C61D0B80C6D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2CBC433B5;
        Mon, 12 Sep 2022 03:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953300;
        bh=4V8y0bWLayYbm9/u/dTiNDa6lMxIEnLT042tpF4UJoQ=;
        h=Date:To:From:Subject:From;
        b=TWcG71IMpk2KKwEgVdOO7ne0X7A4ncqftMUl9YMNIz7KUZc/For6wxMiM1WXLdvDX
         Psj73D/2MvbiaP6eJLwiJb/c7Jab+y3Xn6t8cxHyBP/dft6+ZuE2COGs7yCJJ+tUrg
         lBALz880spvx4WStIMeKtepv12uxjiplqMBXKboc=
Date:   Sun, 11 Sep 2022 20:28:19 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        quic_pkondeti@quicinc.com, mhocko@suse.com, hannes@cmpxchg.org,
        anshuman.khandual@arm.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-remove-unused-variable-in-offline_page_ext.patch removed from -mm tree
Message-Id: <20220912032820.7B2CBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: remove unused variable in offline_page_ext
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-unused-variable-in-offline_page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm/page_ext: remove unused variable in offline_page_ext
Date: Mon, 1 Aug 2022 10:36:37 +0530

Remove unused variable 'nid' in offline_page_ext().  This is not used
since the page_ext code inception.

Link: https://lkml.kernel.org/r/1659330397-11817-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pavan Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-remove-unused-variable-in-offline_page_ext
+++ a/mm/page_ext.c
@@ -336,7 +336,7 @@ static int __meminit online_page_ext(uns
 }
 
 static int __meminit offline_page_ext(unsigned long start_pfn,
-				unsigned long nr_pages, int nid)
+				unsigned long nr_pages)
 {
 	unsigned long start, end, pfn;
 
@@ -362,11 +362,11 @@ static int __meminit page_ext_callback(s
 		break;
 	case MEM_OFFLINE:
 		offline_page_ext(mn->start_pfn,
-				mn->nr_pages, mn->status_change_nid);
+				mn->nr_pages);
 		break;
 	case MEM_CANCEL_ONLINE:
 		offline_page_ext(mn->start_pfn,
-				mn->nr_pages, mn->status_change_nid);
+				mn->nr_pages);
 		break;
 	case MEM_GOING_OFFLINE:
 		break;
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

