Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CB6C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9C521702
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291613;
	bh=3oXXU0DKrUThDNz3MMlm0/Tvom7UUcuhtkLH/TaWhrQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QNnjsZVkoLB0kRRwXY1MsRRUaTt1FA1y9mub+JWNm/hTy+zQOx6YyuTcFUhihH45R
	 QXlhsBioYzyY2CXcYuJo/rJzKC/HXn+arpEIc+sTZ410P1iwO/zLdHiDnVbQ552exv
	 S8To8RWK7P7QhOOOBvxrBrsHRmBxck4jy2YyMtfE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGUAdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgGUAdc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:33:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A850F2080D;
        Tue, 21 Jul 2020 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291611;
        bh=3oXXU0DKrUThDNz3MMlm0/Tvom7UUcuhtkLH/TaWhrQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xhEiz4kDlux5Kn3D+XJ/OxVcX8uHowdRPesZsl74NuPR0gCmtgTqw0ZzvFxdYrSqz
         wMVblUNIMmlfuSKvI3nxGdngyzsvljdY8GxF7S/a3trli2PKxfdaKN/hG4NwwE+dac
         cEVoFsrQxXE+YxUET/NHrWQXw0vkrIYbX8CtaaIQ=
Date:   Mon, 20 Jul 2020 17:33:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        vdavydov.dev@gmail.com
Subject:  +
 memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
 added to -mm tree
Message-ID: <20200721003331.W5hwfUraO%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memcontrol.h: drop duplicate word and fix spello
has been added to the -mm tree.  Its filename is
     memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -72,8 +72,8 @@ struct mem_cgroup_id {
 
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

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
autofs-fix-doubled-word.patch

