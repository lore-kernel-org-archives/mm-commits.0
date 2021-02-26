Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0CEC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F0564F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBZBRg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhBZBRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A7864F03;
        Fri, 26 Feb 2021 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302212;
        bh=eXy8vO4itDYN5MUfc4uV2DiZdadEtVemdC7JXXQ2rcc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bAyk94YIIWhEW9RhY56mTqAjtuHR6+Ssbib//ildQeT0TMd02iuee3ftnEupKJ/i4
         MoVRHko7ex61QR8yhVwQfk27b2zh26C79GajIaCs+B3wO4FbA1nOjNc9Y6zEP8AZJr
         vCG8X35jpIdjHYSQvvLNP/4RIyl9aKdXSrVCDH3U=
Date:   Thu, 25 Feb 2021 17:16:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 024/118] mm: vmstat: add some comments on internal
 storage of byte items
Message-ID: <20210226011651.UY-aB_mq-%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: add some comments on internal storage of byte items

Byte-accounted items are used for slab object accounting at the cgroup
level, because the objects in a slab page can belong to different cgroups.
At the global level these items always change in multiples of whole slab
pages.  The vmstat code exploits this and stores these items as pages
internally, which allows for more compact per-cpu data.

This optimization isn't self-evident from the asserts and the division in
the stat update functions.  Provide the reader with some context.

Link: https://lkml.kernel.org/r/20210202184411.118614-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 ++++++
 mm/vmstat.c            |   12 ++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/vmstat.h~mm-vmstat-add-some-comments-on-internal-storage-of-byte-items
+++ a/include/linux/vmstat.h
@@ -313,6 +313,12 @@ static inline void __mod_node_page_state
 			enum node_stat_item item, int delta)
 {
 	if (vmstat_item_in_bytes(item)) {
+		/*
+		 * Only cgroups use subpage accounting right now; at
+		 * the global level, these items still change in
+		 * multiples of whole pages. Store them as pages
+		 * internally to keep the per-cpu counters compact.
+		 */
 		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
 		delta >>= PAGE_SHIFT;
 	}
--- a/mm/vmstat.c~mm-vmstat-add-some-comments-on-internal-storage-of-byte-items
+++ a/mm/vmstat.c
@@ -342,6 +342,12 @@ void __mod_node_page_state(struct pglist
 	long t;
 
 	if (vmstat_item_in_bytes(item)) {
+		/*
+		 * Only cgroups use subpage accounting right now; at
+		 * the global level, these items still change in
+		 * multiples of whole pages. Store them as pages
+		 * internally to keep the per-cpu counters compact.
+		 */
 		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
 		delta >>= PAGE_SHIFT;
 	}
@@ -551,6 +557,12 @@ static inline void mod_node_state(struct
 	long o, n, t, z;
 
 	if (vmstat_item_in_bytes(item)) {
+		/*
+		 * Only cgroups use subpage accounting right now; at
+		 * the global level, these items still change in
+		 * multiples of whole pages. Store them as pages
+		 * internally to keep the per-cpu counters compact.
+		 */
 		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
 		delta >>= PAGE_SHIFT;
 	}
_
