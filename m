Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517B6C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A5B64E49
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhBBTZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239287AbhBBTXK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:23:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B250464E46;
        Tue,  2 Feb 2021 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612293749;
        bh=eCv+wToqhO8b4kaYY2i4cXouQdIyt21E83SDwsVl6CQ=;
        h=Date:From:To:Subject:From;
        b=C3Vo5SdbwXF6EGTdHf9aO4MauE/6hpYEQ3TFuzvdfcP1QiPYhAkOiWL9yoPAwD2NM
         X/b0YYBU+qKdbyei4FC0DwKNVflTmIanQys0/oN7a9P3uzcryvMR0JKlTyRwetGeuQ
         Am0iircoOGlmF86RkAiBfcY3TpHuO/wCsjCSeR0w=
Date:   Tue, 02 Feb 2021 11:22:29 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  +
 mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch added
 to -mm tree
Message-ID: <20210202192229.SO8s6n-RQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: add some comments on internal storage of byte items
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch
mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

