Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD30C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224D220767
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401643;
	bh=uq5YB4+fti01yV2UZmKwpBktFwzr847Db4Btw746kzc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wtvivVPEy9afh9FcKZzwcJhwqB1raOJzTr4ToRuxfkheDYCgsgwNRaX6UK+PXS2OI
	 uUGX17NeBBVqC6p4fX+g7sraD68oNTCu55kZrdgfypSGPgoNZQSX3OuWKMRM8cj9wv
	 etxo51YHS3hbyL1KJm9Vz/iffEKJBa5jE3A7fzyM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHZA1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHZA1W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:27:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D282075E;
        Wed, 26 Aug 2020 00:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401642;
        bh=uq5YB4+fti01yV2UZmKwpBktFwzr847Db4Btw746kzc=;
        h=Date:From:To:Subject:From;
        b=MtLG/50lTgBQDxnzOLGVvZiXKCfHFRrkAEZiTJjXZrkhvzyDXhW/xCczgKsCklQG/
         2mS3oehg7SQ1Y9kS0WjwNY6j2nNsU0xeN0seg1JMq3QZlOZuXsmAeqOU6MBF0meFIi
         rEoWEEVaQW0AoHC7G66Beg8lv3fMxom2rIsk8B6g=
Date:   Tue, 25 Aug 2020 17:27:21 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mmhwpoison-refactor-soft=5Foffline=5Fhuge=5Fpage-and-=5F?=
 =?US-ASCII?Q?=5Fsoft=5Foffline=5Fpage-fix.patch?= added to -mm tree
Message-ID: <20200826002721.1PudimrNs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch

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
Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix

fix bogus conflict resolution

Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
+++ a/mm/memory-failure.c
@@ -1762,8 +1762,6 @@ static bool isolate_page(struct page *pa
 
 		if (isolated)
 			list_add(&page->lru, pagelist);
-
-		return -EBUSY;
 	}
 
 	if (isolated && lru)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

