Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6929BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 20:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbiF0UGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 16:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238913AbiF0UGv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 16:06:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAFF1DA76
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 13:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F68CCE1D53
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 20:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF91C34115;
        Mon, 27 Jun 2022 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656360405;
        bh=gbE8wTvk0pKri3nr2/Qf9pX3hA2CBpjUiBCunbXfQ8M=;
        h=Date:To:From:Subject:From;
        b=t7DNSyApAXY+/1FlLIRUWe5ytHm8ioLi0X7eVxojL7Dvd+Jeza/4TQq/Hp7d+eR4G
         kdEn3PnripuE0KTWubMtz7PbjJtan7uslLN/MecZtguZKbod6hCBFdYYHylGEqU8yV
         PYih0sDqzTTHNNgJQWoQXAED3Ioyw+WPboD0zI88=
Date:   Mon, 27 Jun 2022 13:06:44 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-notify-about-global-mem_cgroup_id-space-depletion.patch added to mm-unstable branch
Message-Id: <20220627200645.5DF91C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: notify about global mem_cgroup_id space depletion
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-notify-about-global-mem_cgroup_id-space-depletion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-notify-about-global-mem_cgroup_id-space-depletion.patch

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
From: Vasily Averin <vvs@openvz.org>
Subject: memcg: notify about global mem_cgroup_id space depletion
Date: Mon, 27 Jun 2022 05:11:26 +0300

Currently, the host owner is not informed about the exhaustion of the
global mem_cgroup_id space.  When this happens, systemd cannot start a new
service and receives a unique -ENOSPC error code.  However, this can
happen inside this container, persist in the log file of the local
container, and may not be noticed by the host owner if he did not try to
start any new services.

Link: https://lkml.kernel.org/r/97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-notify-about-global-mem_cgroup_id-space-depletion
+++ a/mm/memcontrol.c
@@ -5286,6 +5286,8 @@ static struct mem_cgroup *mem_cgroup_all
 				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
+		if (error == -ENOSPC)
+			pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from vvs@openvz.org are

memcg-notify-about-global-mem_cgroup_id-space-depletion.patch

