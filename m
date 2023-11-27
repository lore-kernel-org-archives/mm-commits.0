Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FD8C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 21:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjK0VBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 16:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjK0VA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 16:00:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120F1191
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 13:01:05 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C46CC433B8;
        Mon, 27 Nov 2023 21:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701118864;
        bh=bvba14KlPnmOvPRGAIlDKpivBPBHShXgp3C4FZgZ66E=;
        h=Date:To:From:Subject:From;
        b=RTsA2bj/kb06tQ+mThuKwrgfD2Lxibzh64UyBfyILruCaHr1FnuiPxLL7Fj7XL6yZ
         xPqQwriSVooOWkwUuix0EZHT7bwo1aoS+zcbLHjgJRFGPbg1y3UA9BXaoDNxA2R3/8
         mDI76+D7ojlFWk9K5rocQuE3se0pOpr7jJRMNKOw=
Date:   Mon, 27 Nov 2023 13:01:04 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, nphamcs@gmail.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch added to mm-unstable branch
Message-Id: <20231127210104.9C46CC433B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-shrinks-zswap-pool-based-on-memory-pressure-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-shrinks-zswap-pool-based-on-memory-pressure-fix
Date: Mon Nov 27 12:52:45 PM PST 2023

fix CONFIG_ZSWAP=n build

Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/zswap.h~zswap-shrinks-zswap-pool-based-on-memory-pressure-fix
+++ a/include/linux/zswap.h
@@ -54,6 +54,7 @@ static inline void zswap_swapon(int type
 static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_init(struct lruvec *lruvec) {}
+static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_lruvec_swapin(struct page *page) {}
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

