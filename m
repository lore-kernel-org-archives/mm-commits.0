Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492CBC32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiIZRDJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIZRCw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4511F91D0D
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65B2460F4A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B871C433C1;
        Mon, 26 Sep 2022 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664208278;
        bh=8KkMojXJoEIk93bd3SqQF+8B49U72BsRYMML55DwHu0=;
        h=Date:To:From:Subject:From;
        b=rGnB8EbFp4wYRMQMRARTAjqoQ6pDMFjSHOOWTnMv7CAZaSP3I8uCAZ+sjBsLyk6ER
         iZCxCvB4/sTJQIJ0yEAM+tYuGaGr0T9vhCnnTYsHUQHq0FrmLa2qYV4wiE+qrRzIjs
         4hdsuSaRfy5LBsII1i3eukG/M5BZCWJLbWmoDS7M=
Date:   Mon, 26 Sep 2022 09:04:36 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch added to mm-unstable branch
Message-Id: <20220926160438.9B871C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: don't allocate cgroup swap arrays when memcg is disabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: don't allocate cgroup swap arrays when memcg is disabled
Date: Mon, 26 Sep 2022 09:57:01 -0400

Patch series "memcg swap fix & cleanups".


This patch (of 4):

Since commit 2d1c498072de ("mm: memcontrol: make swap tracking an integral
part of memory control"), the cgroup swap arrays are used to track memory
ownership at the time of swap readahead and swapoff, even if swap space
*accounting* has been turned off by the user via swapaccount=0 (which sets
cgroup_memory_noswap).

However, the patch was overzealous: by simply dropping the
cgroup_memory_noswap conditionals in the swapon, swapoff and uncharge
path, it caused the cgroup arrays being allocated even when the memory
controller as a whole is disabled.  This is a waste of that memory.

Restore mem_cgroup_disabled() checks, implied previously by
cgroup_memory_noswap, in the swapon, swapoff, and swap_entry_free
callbacks.

Link: https://lkml.kernel.org/r/20220926135704.400818-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20220926135704.400818-2-hannes@cmpxchg.org
Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled
+++ a/mm/memcontrol.c
@@ -7459,6 +7459,9 @@ void __mem_cgroup_uncharge_swap(swp_entr
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
--- a/mm/swap_cgroup.c~mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled
+++ a/mm/swap_cgroup.c
@@ -170,6 +170,9 @@ int swap_cgroup_swapon(int type, unsigne
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 
 	array = vcalloc(length, sizeof(void *));
@@ -204,6 +207,9 @@ void swap_cgroup_swapoff(int type)
 	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
 	map = ctrl->map;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch
mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch
mm-memcontrol-deprecate-swapaccounting=0-mode.patch
mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch
mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

