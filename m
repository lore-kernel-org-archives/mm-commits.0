Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D6C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 21:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1D520768
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595970062;
	bh=4u88W983JaNxFXw0xNcnbCZNxA3qOLOY5kOeIxMcJw4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VtLWSfnNrFkhpAjK6l0sM3j4eHIvMJTOJlZ5JOu/AJKPiEabDa02xpqtuS6hFDQSw
	 UQ9UAwVmosq4PQsfbPTZ+bMdLpLNHW+aiyPQIUhgiVTuz+NmHxWhkPLz1drLWFkdle
	 IC5/Qp+XWs5uGYGIOsJfXO60VN3R+hLmZVR5nPOw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgG1VBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 17:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgG1VBB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 17:01:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63292075D;
        Tue, 28 Jul 2020 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595970060;
        bh=4u88W983JaNxFXw0xNcnbCZNxA3qOLOY5kOeIxMcJw4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E9W3+RjEQJhv82lEPAovC4cEqonZrFBC7TRr60tDC/hNS81deI3vVrSdL9gEAK1N7
         n9MCBAo5y/K9Hux+NOLpuf09SAV9hb8ZWtUKcOTJhqfX2ZMzuqKAZFc5ut1iKaBGir
         hBUOOStz87YMfpHW81BrS1oHSxFsw8GpQG/LP000=
Date:   Tue, 28 Jul 2020 14:01:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch
 added to -mm tree
Message-ID: <20200728210100.2xDwI8tcE%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: restore proper dirty throttling when memory.high changes
has been added to the -mm tree.  Its filename is
     mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: restore proper dirty throttling when memory.high changes

Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
memory.high") inadvertently removed a callback to recalculate the
writeback cache size in light of a newly configured memory.high limit.

Without letting the writeback cache know about a potentially heavily
reduced limit, it may permit too many dirty pages, which can cause
unnecessary reclaim latencies or even avoidable OOM situations.

This was spotted while reading the code, it hasn't knowingly caused any
problems in practice so far.

Link: http://lkml.kernel.org/r/20200728135210.379885-1-hannes@cmpxchg.org
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes
+++ a/mm/memcontrol.c
@@ -6283,6 +6283,8 @@ static ssize_t memory_high_write(struct
 
 	page_counter_set_high(&memcg->memory, high);
 
+	memcg_wb_domain_size_changed(memcg);
+
 	return nbytes;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-decouple-reference-counting-from-page-accounting.patch
mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch
mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch

