Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E51C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiLVVoG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiLVVn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C87C275CE
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CC4DB81F79
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D425FC433D2;
        Thu, 22 Dec 2022 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745428;
        bh=tUSxh3ud+STOA1x/b0d34cAPVpxJfqr4+k444+sYkvg=;
        h=Date:To:From:Subject:From;
        b=KVn2V4MDvvri9yUWM5nuTKy7rr0Hmh3Lt8Ij1bml/2x5riWjB4DXHIlg5ZN1nBul/
         XGcoVZNgofiqYgku0oJzhJn0XtKTxO5rBTDksWjCKJawEaPF4oz0TO8r4iCTA8FOCJ
         7tDVxocABnUDyc2IEdTTQTFElP0CFr5G9rYw/KOM=
Date:   Thu, 22 Dec 2022 13:43:48 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, Michael@MichaelLarabel.com,
        mhocko@kernel.org, hannes@cmpxchg.org, corbet@lwn.net,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch added to mm-unstable branch
Message-Id: <20221222214348.D425FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: simplify arch_has_hw_pte_young() check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: simplify arch_has_hw_pte_young() check
Date: Wed, 21 Dec 2022 21:19:06 -0700

Scanning page tables when hardware does not set the accessed bit has
no real use cases.

Link: https://lkml.kernel.org/r/20221222041905.2431096-9-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check
+++ a/mm/vmscan.c
@@ -4428,7 +4428,7 @@ static bool try_to_inc_max_seq(struct lr
 	 * handful of PTEs. Spreading the work out over a period of time usually
 	 * is less efficient, but it avoids bursty page faults.
 	 */
-	if (!force_scan && !(arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))) {
+	if (!arch_has_hw_pte_young() || !get_cap(LRU_GEN_MM_WALK)) {
 		success = iterate_mm_list_nowalk(lruvec, max_seq);
 		goto done;
 	}
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-rename-lru_gen_struct-to-lru_gen_folio.patch
mm-multi-gen-lru-rename-lrugen-lists-to-lrugen-folios.patch
mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch
mm-multi-gen-lru-remove-aging-fairness-safeguard.patch
mm-multi-gen-lru-shuffle-should_run_aging.patch
mm-multi-gen-lru-per-node-lru_gen_folio-lists.patch
mm-multi-gen-lru-clarify-scan_control-flags.patch
mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

