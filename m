Return-Path: <SRS0=1Kf1=EE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05468C5DF9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4ED221F9
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603937088;
	bh=gp/EqRRTvbGzPTOb1nvCbH/RkaC7zg/d0WTnvnV2dA4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AHqmNzq5bc+RkI/2ZjW3V4AzwJkJOnOr+T6ov3iODGwGbcPM6QCisFyHnzChTW3IJ
	 a7L6sSEJ1w6QWo56AZ7iK6JxbxZ36VlcqJDB7iuThGBz6LV0mZWAZtptpRNb7rVNnB
	 b3HPJ7EHG3h1wukp5zO2slGBtrRb+5wm8S0VIKh8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgJ1Vsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgJ1VmX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:42:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA8124836;
        Wed, 28 Oct 2020 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603920191;
        bh=gp/EqRRTvbGzPTOb1nvCbH/RkaC7zg/d0WTnvnV2dA4=;
        h=Date:From:To:Subject:From;
        b=hoCUOvuAmxqEg7c00YnOXc3apoewckxmY/VdzPdAI0TG9ObJyAMXJ95NGNUqZi4cJ
         +ME+8p1OuMj0sNOTV2WuHAts0P1lzd959rGbdgO8WDlZeiM02tTZsQmGT/R4MW+aTq
         713HBqRe1RiU7YFBdUSsMhGE2I0OukUHI18V5Roo=
Date:   Wed, 28 Oct 2020 14:23:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com, glider@google.com,
        keescook@chromium.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-do-not-rely-on-the-order-of-page=5Fpoison?=
 =?US-ASCII?Q?-and-init=5Fon=5Falloc-free-parameters-fix.patch?= added to
 -mm tree
Message-ID: <20201028212309.x6ldc-X-X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix

fix init_mem_debugging() definition, per Mike

Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix
+++ a/mm/page_alloc.c
@@ -758,7 +758,7 @@ static inline void clear_page_guard(stru
  * order of appearance. So we need to first gather the full picture of what was
  * enabled, and then make decisions.
  */
-void init_mem_debugging()
+void init_mem_debugging(void)
 {
 	if (_init_on_alloc_enabled_early) {
 		if (page_poisoning_enabled()) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

