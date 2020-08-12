Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB081C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 900512076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195962;
	bh=92NsGOsIPVPByGNhuasDUSAtQO3Ry+rzfhLJzKbgGd8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VuvUlI0pR0MUToynQd/7lkoYxoze0BekEyTgWI+y6kRpkSnRuB3iBemnM/1GolEke
	 hj4TI+Gckfqo+3g70rxCpWNFqDxLirRJ9w/6sgZKPdk+5qoOF9t7lCwTNUkEmksOj5
	 Gn4iOXPuJZUzcjxthHHt3l3sv2bXpWitFAXlOAJI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgHLBcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgHLBcm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B16206B2;
        Wed, 12 Aug 2020 01:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195961;
        bh=92NsGOsIPVPByGNhuasDUSAtQO3Ry+rzfhLJzKbgGd8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zh4nKDyK87D0pIWAJXVxAMxc8J2N+lKML7+fSfZSVvvINwARzIsBeA4u4DBm01X0m
         Q2/2LKhuy6OIq78uOJFwgCcJGvtHMTuL5EsPBBsvZUwgjp9FLs/vn5Hk7d44h913Mg
         MCUAwuBO5ZyG4Z9p4Nel7hCzaF667EJhJgmYtN/E=
Date:   Tue, 11 Aug 2020 18:32:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 045/165] include/linux/memcontrol.h: drop
 duplicate word and fix spello
Message-ID: <20200812013240.oItfe4_-m%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
