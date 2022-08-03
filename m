Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1231BC00140
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 00:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiHCAmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Aug 2022 20:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiHCAl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2022 20:41:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA4F3134D
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 17:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02D9EB82010
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 00:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0846C433D6;
        Wed,  3 Aug 2022 00:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659487315;
        bh=VoMLZlu0jhw2d5y22MmWaO4CPVb9apkaeHeY/VQ2O60=;
        h=Date:To:From:Subject:From;
        b=AUw62KxYXgpwZ8CWMCWwCs3edKfNIGhmmtximGVJS8nW27SirG8SIgJnadYds01k9
         FBxIXLYjx486dW9fm33NM8XuDMUqy+T7QhZlFAGxDnneGCv8v32jEO5LVXqkaA9Nz9
         XD0mD06c6su065QMUJxdVTG9XQMYxm3Pv0Qec/W0=
Date:   Tue, 02 Aug 2022 17:41:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        quic_pkondeti@quicinc.com, mhocko@suse.com, hannes@cmpxchg.org,
        anshuman.khandual@arm.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-remove-unused-variable-in-offline_page_ext.patch added to mm-unstable branch
Message-Id: <20220803004155.A0846C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: remove unused variable in offline_page_ext
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-remove-unused-variable-in-offline_page_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-remove-unused-variable-in-offline_page_ext.patch

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

mm-page_ext-remove-unused-variable-in-offline_page_ext.patch

