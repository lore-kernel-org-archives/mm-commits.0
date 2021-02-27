Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDFCC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B020B64F36
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhB0C36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhB0C3x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7713364F33;
        Sat, 27 Feb 2021 02:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392948;
        bh=f0ygv88PgY0VBrTJMUOYHLkH9uByq4m0dKL4uyzIm+Y=;
        h=Date:From:To:Subject:From;
        b=C+bqvQRs50pX6vOhVUjvXmFbbwUNU+CnOb2Ry5dv7Ni4GFz5YBCd6I5iZQhQnq9AW
         z+TDyu3wc0ws7HVdjcpYpAOX4cBOcZuIp8Mjg14YVkj/jHLpMW83lOVEvS8YveU7A2
         1XUHRwk29/rbmi8iZfSmv5Wyz8hGigksfGSvOg+w=
Date:   Fri, 26 Feb 2021 18:29:08 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch removed
 from -mm tree
Message-ID: <20210227022908.EfGwOQhgq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: add some comments on internal storage of byte items
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are


