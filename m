Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A85DC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2904D206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027198;
	bh=DfbtzeYltxi3pf7VzDb+fo2+iBetBU/EB/UfxR0pdRg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TbKFKL6lHwBDRKOhOW1M9VhX1voQn+Nyt7Br5vdIus1zpJogDkj+bFV+3O0Bufo3v
	 +cYYtgWm5ZlPPuT1EQeQkhy80IEbt4s+KDrRqEsiTxIfJTe214XYlB9PJ7t+V3gmpf
	 9tLhrQBHquBN82O6uRs0RZrhKwhQVhKdTcYsZzTQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCj5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1D362065D;
        Mon, 10 Aug 2020 02:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027196;
        bh=DfbtzeYltxi3pf7VzDb+fo2+iBetBU/EB/UfxR0pdRg=;
        h=Date:From:To:Subject:From;
        b=nUbtHhF8jJbPwETicJdqUbdRQxpo/v5zxFeGQFBjqVnrDKfEN2GpZ5xisG0LwpRDy
         9bW6uIUkJ+mC0DlWOivwJoeHh/95cghjVTkJb6MLY2WA5sLEzastIzhzY2ZgmkmDJy
         WiAC6zc1sE09uL6wzIJgDOFCcSVi465kUGni2mIM=
Date:   Sun, 09 Aug 2020 19:39:56 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com,
        david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch removed from
 -mm tree
Message-ID: <20200810023956.9ZnzPsq3e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: document why shuffle_zone() is relevant
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: document why shuffle_zone() is relevant

It's not completely obvious why we have to shuffle the complete zone -
introduced in commit e900a918b098 ("mm: shuffle initial free memory to
improve memory-side-cache utilization") - because some sort of shuffling
is already performed when onlining pages via __free_one_page(), placing
MAX_ORDER-1 pages either to the head or the tail of the freelist.  Let's
document why we have to shuffle the complete zone when exposing larger,
contiguous physical memory areas to the buddy.

Link: http://lkml.kernel.org/r/20200624094741.9918-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-document-why-shuffle_zone-is-relevant
+++ a/mm/memory_hotplug.c
@@ -831,6 +831,14 @@ int __ref online_pages(unsigned long pfn
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
+	/*
+	 * When exposing larger, physically contiguous memory areas to the
+	 * buddy, shuffling in the buddy (when freeing onlined pages, putting
+	 * them either to the head or the tail of the freelist) is only helpful
+	 * for maintaining the shuffle, but not for creating the initial
+	 * shuffle. Shuffle the whole zone to make sure the just onlined pages
+	 * are properly distributed across the whole freelist.
+	 */
 	shuffle_zone(zone);
 
 	node_states_set_node(nid, &arg);
_

Patches currently in -mm which might be from david@redhat.com are


