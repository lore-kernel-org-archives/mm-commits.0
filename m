Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FC2C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3ABA2078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597800638;
	bh=kU4q2O2dd7q2Wgv84Q/pNG2MW1V/2195uJhbPPd/1hA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nwbU90vdkdRSUMtrVcVSvmNCS1FjYDY7GxOfNBfhJ+imK8fali5STELEB2BOnZTtM
	 v7RjrkkBwhgGYu+C+wUhjBdwFkYl+t9/kIvUMYuF5BaGagM4YGyHbJdZJLApbYsPUr
	 UizAIQ3sv2CD/elMFOk0mtMrHPt1CWF+aNFXVWfE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHSBai (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgHSBah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:30:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D002E20657;
        Wed, 19 Aug 2020 01:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597800637;
        bh=kU4q2O2dd7q2Wgv84Q/pNG2MW1V/2195uJhbPPd/1hA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z4B+pLfmSg+S0HxRIOF5rz4i+GmpNya+gNOc4Oue12UlN3pWWg2R9mt+rnBOrTrjW
         zdRLV8CbDT9TWgVwMQjtgq2dTIfiRjOCbH2Ioy9wl9ggTQ+Nn+A92xe2wcvyytG9P0
         9JTb7zOSBOZF9EAEKjIaY0uEcNjhyjhWAI0dhlpU=
Date:   Tue, 18 Aug 2020 18:30:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alexander.h.duyck@linux.intel.com, david@redhat.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com
Subject:  +
 mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
 added to -mm tree
Message-ID: <20200819013036.kGxDiLzNy%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting.c: drop stale list head check in page_reporting_cycle
has been added to the -mm tree.  Its filename is
     mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_reporting.c: drop stale list head check in page_reporting_cycle

list_for_each_entry_safe() guarantees that we will never stumble over the
list head; "&page->lru != list" will always evaluate to true.  Let's
simplify.

[david@redhat.com: Changelog refinements]
Link: http://lkml.kernel.org/r/20200818084448.33969-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle
+++ a/mm/page_reporting.c
@@ -178,7 +178,7 @@ page_reporting_cycle(struct page_reporti
 		 * the new head of the free list before we release the
 		 * zone lock.
 		 */
-		if (&page->lru != list && !list_is_first(&page->lru, list))
+		if (!list_is_first(&page->lru, list))
 			list_rotate_to_front(&page->lru, list);
 
 		/* release lock before waiting on report processing */
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch

