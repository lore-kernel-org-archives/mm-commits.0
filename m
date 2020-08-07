Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD82C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE4422CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781537;
	bh=mz0iVPQNAmzNjhnKvF1Rki2AjfVQU0fJyJHJJy9oo2Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=llz2eEUZD+SSElbSsDTLdakkLqBrPRhzKRSQDCS8MBmIo2Rq1ZmuWyibSohjAZCfz
	 Y+QQB+isiOOtGRe3dp6sJPM7TrGxtth66z0VAQXFg80bKig/vcMCEnsze6wx3N62wO
	 MMhQDhbdMIYNveMvbLH4Tgl32I5QxmIpsGUs3Ex8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A06822CAE;
        Fri,  7 Aug 2020 06:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781536;
        bh=mz0iVPQNAmzNjhnKvF1Rki2AjfVQU0fJyJHJJy9oo2Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c856eejnSmUJdk82d5aZxVYwtG936NlR1Ioa7oacxnhnJNarv4tHvvz9wy/Bu27MN
         oQAPiJsbImqcQ7CEiwssuhtlY2+h8AC+wBmHZft8mEDgz2Q1SJVJfa9L8M7sny7nVC
         8d9SgeTzkmBLPnAgy1wMkXroVReARy1OrLmpXYOU=
Date:   Thu, 06 Aug 2020 23:25:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 146/163] mm/memory_hotplug: document why
 shuffle_zone() is relevant
Message-ID: <20200807062535.uWDghNgg2%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
