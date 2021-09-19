Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477C2C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA3361052
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhISWm1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 18:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhISWm1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 18:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE8161051;
        Sun, 19 Sep 2021 22:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632091261;
        bh=Kdwd95ZjgR/Va7xfDF+Mei+hXJlsx86hqHoR1v5Ci0Q=;
        h=Date:From:To:Subject:From;
        b=DdYFZYjp7kZYLrfeHpaJLVi05zDU+H1MnP9kEZz209p3xL/+4kY4HCIt8570/+fBq
         vT7cB9OlGJyk06TqJ3s6ugvziARLZuk+vWc6U4XJJDSzueqv20ArIqYj2ha2zcaHXy
         pBaGwyJgJjG9IZlKKi6UgSQcHlAgUxNX7SvYMZ2g=
Date:   Sun, 19 Sep 2021 15:41:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.com,
        mgorman@suse.de, sultan@kerneltoast.com
Subject:  + mm-mark-the-oom-reaper-thread-as-freezable.patch added to
 -mm tree
Message-ID: <20210919224100.m_MBy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark the OOM reaper thread as freezable
has been added to the -mm tree.  Its filename is
     mm-mark-the-oom-reaper-thread-as-freezable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mark-the-oom-reaper-thread-as-freezable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-the-oom-reaper-thread-as-freezable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sultan Alsawaf <sultan@kerneltoast.com>
Subject: mm: mark the OOM reaper thread as freezable

The OOM reaper thread uses wait_event_freezable() without actually being
marked as freezable.  Fix it by adding a set_freezable() call.

Link: https://lkml.kernel.org/r/20210918233920.9174-1-sultan@kerneltoast.com
Fixes: aac453635549 ("mm, oom: introduce oom reaper")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c~mm-mark-the-oom-reaper-thread-as-freezable
+++ a/mm/oom_kill.c
@@ -641,6 +641,8 @@ done:
 
 static int oom_reaper(void *unused)
 {
+	set_freezable();
+
 	while (true) {
 		struct task_struct *tsk = NULL;
 
_

Patches currently in -mm which might be from sultan@kerneltoast.com are

mm-mark-the-oom-reaper-thread-as-freezable.patch

