Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DEEC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 23:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiEQX5z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 19:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiEQX5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 19:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80543CFFE
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 16:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E26B81D64
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 23:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3B5C385B8;
        Tue, 17 May 2022 23:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652831871;
        bh=evR204oeKxcFrRcH6GJ7msGR/edVT2kK0N/5U4C8Yj8=;
        h=Date:To:From:Subject:From;
        b=jMWBUQkFS1YGjl5AaLczgcJs8TKFIF6LHIedP6EqEr+wrUFa0YqHNkSAw/513bLka
         9iBvJRuopsPXIeYkh4HykrSAWuVt4fHW6BJ/o9eVXCEznAuOaQmt10+3uT/Nf2xtXG
         GyWLtVaJULb/aQx0njalpNE0Hlt8lyQxtsFc7tz0=
Date:   Tue, 17 May 2022 16:57:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vdavydov.dev@gmail.com, timmurray@google.com, surenb@google.com,
        mhocko@suse.com, liumartin@google.com, joaodias@google.com,
        hannes@cmpxchg.org, minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch added to mm-unstable branch
Message-Id: <20220517235751.0C3B5C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
Date: Wed, 4 May 2022 23:11:04 -0700

add comment, per Matthew

Link: https://lkml.kernel.org/r/YnNqeB5tUf6LZ57b@google.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: John Dias <joaodias@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_idle.c~mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
+++ a/mm/page_idle.c
@@ -87,6 +87,10 @@ static void page_idle_clear_pte_refs(str
 {
 	struct folio *folio = page_folio(page);
 
+       /*
+        * Since rwc.try_lock is unused, rwc is effectively immutable, so we
+        * can make it static to save some cycles and stack.
+        */
 	static struct rmap_walk_control rwc = {
 		.rmap_one = page_idle_clear_pte_refs_one,
 		.anon_lock = folio_lock_anon_vma_read,
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch
mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch

