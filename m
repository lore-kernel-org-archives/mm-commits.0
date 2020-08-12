Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8FDC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288902078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266178;
	bh=sCWIvSaUGYQBHu5qwqRrL8JvnZCU6IgoVS0z2v8bK6A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=anEjZEVX9OIPBQaFC9NYfLazi7umvOdeSMMhQD+pCy0SsGuvPjPaJq2zRsJNj/YGl
	 jjKLNF10KR2RRJwjqeGiaiFKc2d7OxPoHJX6kTHl9LExw1Yvro5C6f0xuDj/G9gyZz
	 +VKMyYobsgqa9NAs1cw9m0/gDk3gvX6jUk1u1tG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLVC5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7108620774;
        Wed, 12 Aug 2020 21:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266177;
        bh=sCWIvSaUGYQBHu5qwqRrL8JvnZCU6IgoVS0z2v8bK6A=;
        h=Date:From:To:Subject:From;
        b=FoNLf1CkbOueRysZw2BBTCvxvABlYjXopSf7FINoAhayZMjuXzfh3MRpiMq8W7203
         k7nMix4FEYr+EPw9sSrC37VYs2BmOb+aS5CXWUPimQFmv2v4AfR+mLtq3ghZGpy65x
         OSzonkIYniGdF7NEg8TN5xLSQZxM0zp8VrhlL1iU=
Date:   Wed, 12 Aug 2020 14:02:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-memoryc-delete-duplicated-words.patch removed
 from -mm tree
Message-ID: <20200812210257.5tDlXeYEr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: delete duplicated words
has been removed from the -mm tree.  Its filename was
     mm-memoryc-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory.c: delete duplicated words

Drop the repeated word "to" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-7-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memoryc-delete-duplicated-words
+++ a/mm/memory.c
@@ -1800,7 +1800,7 @@ out_unlock:
  * @pfn: source kernel pfn
  * @pgprot: pgprot flags for the inserted page
  *
- * This is exactly like vmf_insert_pfn(), except that it allows drivers to
+ * This is exactly like vmf_insert_pfn(), except that it allows drivers
  * to override pgprot on a per-page basis.
  *
  * This only makes sense for IO mappings, and it makes no sense for
@@ -1936,7 +1936,7 @@ static vm_fault_t __vm_insert_mixed(stru
  * @pfn: source kernel pfn
  * @pgprot: pgprot flags for the inserted page
  *
- * This is exactly like vmf_insert_mixed(), except that it allows drivers to
+ * This is exactly like vmf_insert_mixed(), except that it allows drivers
  * to override pgprot on a per-page basis.
  *
  * Typically this function should be used by drivers to set caching- and
_

Patches currently in -mm which might be from rdunlap@infradead.org are


