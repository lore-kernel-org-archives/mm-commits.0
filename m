Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BCAECAAD1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 20:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiHaUto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 16:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiHaUtn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 16:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965C8F241F
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 13:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D10A619CB
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 20:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DCCC433C1;
        Wed, 31 Aug 2022 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661978979;
        bh=3/KFjdsUS1mZfMWO1h4L+9EJ/PmMzvwk5601D5OASwA=;
        h=Date:To:From:Subject:From;
        b=vBT/SwIxqcAQAyL9/idXoud1+dqpmCnON7cm/fQTllpZxO47Az4s49jIEq2R0KoqV
         bNXFkgOs12HJVm1Egp5nB6Bz/53m0J7yI14rssyXahSQIiOJ6OnEVyce4jle0I7AZF
         Cup1VUGI72S+Ip9PdIoU/1LQ2T0GcdAjMdr3cyqE=
Date:   Wed, 31 Aug 2022 13:49:38 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch added to mm-unstable branch
Message-Id: <20220831204939.82DCCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch

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
From: Michal Hocko <mhocko@suse.com>
Subject: pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2
Date: Wed, 31 Aug 2022 09:58:35 +0200

fix build


lib/show_mem.c: In function '__show_mem':
lib/show_mem.c:17:9: error: too many arguments to function 'show_free_areas'
   17 |         show_free_areas(filter, nodemask, max_zone_idx);
      |         ^~~~~~~~~~~~~~~
In file included from lib/show_mem.c:8:
./include/linux/mm.h:1842:28: note: declared here
 1842 | static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodemask)

Link: https://lkml.kernel.org/r/Yw8Uq5rF19qVUQH+@dhcp22.suse.cz

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/show_mem.c~pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2
+++ a/lib/show_mem.c
@@ -14,7 +14,7 @@ void __show_mem(unsigned int filter, nod
 	unsigned long total = 0, reserved = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	show_free_areas(filter, nodemask, max_zone_idx);
+	__show_free_areas(filter, nodemask, max_zone_idx);
 
 	for_each_online_pgdat(pgdat) {
 		int zoneid;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-update.patch
pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch

