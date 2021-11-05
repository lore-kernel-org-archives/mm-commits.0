Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8295C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC55261357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhKEUrR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUrQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF09661288;
        Fri,  5 Nov 2021 20:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145076;
        bh=f1Hb9dh5T1kfv5Bilwovktw+IWTAU0b2YfU/nNtWtkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zqIheX0GLyIRw6PtXItOeB/GHhaYU2Rn9fGgRlu+/OhWaQ3a0rLXCZmrMD5HmZk4r
         YsGb0V/J7FWaFf3aHJ2FRJ4M7aI+tNAyN0AbdQ9Y7B4ZaQJJ991U1qDooYytGos3ii
         ZaVB9VqYTZuqtWeHxKRpCegR/qJVwDIQZba7ijAY=
Date:   Fri, 05 Nov 2021 13:44:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, osalvador@suse.de, paulus@samba.org,
        peterz@infradead.org, rafael@kernel.org, rppt@kernel.org,
        shuah@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 190/262] mm/memory_hotplug: remove stale function
 declarations
Message-ID: <20211105204435.9aBC2O7r5%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: remove stale function declarations

These functions no longer exist.

Link: https://lkml.kernel.org/r/20210929143600.49379-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-stale-function-declarations
+++ a/include/linux/memory_hotplug.h
@@ -98,9 +98,6 @@ static inline void zone_seqlock_init(str
 {
 	seqlock_init(&zone->span_seqlock);
 }
-extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
-extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
-extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 extern void adjust_present_page_count(struct page *page,
 				      struct memory_group *group,
 				      long nr_pages);
_
