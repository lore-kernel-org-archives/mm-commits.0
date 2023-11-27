Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79499C0755A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 20:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjK0Ucu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 15:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjK0Ucu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 15:32:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640258E
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 12:32:56 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E4C433C8;
        Mon, 27 Nov 2023 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701117176;
        bh=0uH8l4WxeKd9Fig2X+D3LGDY5dBFEV20w9P0FJfmhsI=;
        h=Date:To:From:Subject:From;
        b=nAP8tNLFFB3ZkMnAsV8ru3BaAWBuX3bfNZweAIgldRpP5oyuRzp03ovXEIiHQYPRM
         SO0y0vYtjSjPk7e+C6xHgBzyjavXSWsrh6oDNoJiughn3tu3PPE8R2o3a6VUz+NAxz
         IQRlyLsoW4sNbA1S+aFVoHhexYiZ1q5qLASpp/2Y=
Date:   Mon, 27 Nov 2023 12:32:55 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, ddrokosov@salutedevices.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch added to mm-unstable branch
Message-Id: <20231127203255.F38E4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add reminder comment for the memcg v2 events
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

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
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: mm: memcg: add reminder comment for the memcg v2 events
Date: Thu, 23 Nov 2023 10:19:45 +0300

To maintain the correct state, it is important to ensure that events for
the memory cgroup v2 are aligned with the sample cgroup codes.

Link: https://lkml.kernel.org/r/20231123071945.25811-4-ddrokosov@salutedevices.com
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-add-reminder-comment-for-the-memcg-v2-events
+++ a/mm/memcontrol.c
@@ -6783,6 +6783,10 @@ static ssize_t memory_max_write(struct k
 	return nbytes;
 }
 
+/*
+ * Note: don't forget to update the 'samples/cgroup/memcg_event_listener'
+ * if any new events become available.
+ */
 static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 {
 	seq_printf(m, "low %lu\n", atomic_long_read(&events[MEMCG_LOW]));
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are

mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints.patch
mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch
samples-introduce-new-samples-subdir-for-cgroup.patch
samples-cgroup-introduce-memcg-memoryevents-listener.patch
mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

