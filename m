Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F1DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9EC1207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266162;
	bh=RwqWivEzaZJZhkUutu0ocku5wdg9by+3tanHEwPE440=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=P+PvjCBn8BEJw+c6nr0dOSNazhC02i+J+dvKlgn+FbhiTly6Pv7D6VTuYFhVSFBn2
	 F/h91MOZwYhf15FdhgAQBI4elqTTR1Nk2+NkFpvikiXy4hC/2ZV2HWDDdOSkDu/D6C
	 4oKSgQgA0vluFFyTPuKLDApZBuu6s69suInmn2kA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgHLVCm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B1F20838;
        Wed, 12 Aug 2020 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266161;
        bh=RwqWivEzaZJZhkUutu0ocku5wdg9by+3tanHEwPE440=;
        h=Date:From:To:Subject:From;
        b=PDbKUOPYcYqw0Es4zg81Pa9nib3+/vJxGzg1Te6EWKGy6p5ZnwlwEZlS+rOUhqoH3
         FhRyYdkzuUTp8wuRUv6mgjH/yP0fkoI3LkJHQYDVfgcArXYIBaF7/NmZH+YrNMWmlr
         CcyO6eKJ41qu4r9GlvallW1hdg9ohuq8P9QjwmAQ=
Date:   Wed, 12 Aug 2020 14:02:41 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
 removed from -mm tree
Message-ID: <20200812210241.Kr457wRlz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memcontrol.h: drop duplicate word and fix spello
has been removed from the -mm tree.  Its filename was
     memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/memcontrol.h: drop duplicate word and fix spello

Drop the doubled word "for" in a comment.
Fix spello of "incremented".

Link: http://lkml.kernel.org/r/b04aa2e4-7c95-12f0-599d-43d07fb28134@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -65,8 +65,8 @@ struct mem_cgroup_id {
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremated by the number of pages. This counter is used for
- * for trigger some periodic events. This is straightforward and better
+ * it will be incremented by the number of pages. This counter is used
+ * to trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
 enum mem_cgroup_events_target {
_

Patches currently in -mm which might be from rdunlap@infradead.org are


