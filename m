Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B67BC32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiIZVFr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiIZVFo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:05:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1F3659CF
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE3586142E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C41CC433D6;
        Mon, 26 Sep 2022 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226342;
        bh=I2fNHwDky0NbScZn73165JPIkHh5fEEQz5CNyojngM8=;
        h=Date:To:From:Subject:From;
        b=Vc0aMkVdCDMPgYRoVn57WjlSbNLBvZ6XmuqFNP2mqs69vF2bUyO44v+j31c9Z0GgP
         avaT9XXierbk15nAlk9l09T1M1Gg30iHEU41tj5tfFZvE97eshjZw742R0LsaN+ufn
         am6ZyNLNS7Rj9HjPdVd6USGjkEfm5IgSlh5IyWAw=
Date:   Mon, 26 Sep 2022 14:05:41 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch removed from -mm tree
Message-Id: <20220926210542.0C41CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2
has been removed from the -mm tree.  Its filename was
     pc-mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix-2.patch

This patch was dropped because it was folded into mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch

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

