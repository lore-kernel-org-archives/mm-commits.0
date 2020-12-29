Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7ABC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291AA221F8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgL2VBD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 16:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2VBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 16:01:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9AFE21D1B;
        Tue, 29 Dec 2020 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609275622;
        bh=4+6hEsB2FaT6cjlohU3wxms1uMlJtrypj3ItcOs587o=;
        h=Date:From:To:Subject:From;
        b=O8BAP5SvEavZjV+bcSr/GFeVkfQbyv1DLc1upF7knwVgkJS8ai+7lofgoSGBMnGn+
         pixXexk07HWcwjp59ZiVwNjsncxEuNbWuHXd0CWCWzNvHfO0fBDMIeJmUkaPZOoWFo
         Qz66ylnjwpUX6d++TlMpgsh4iusnF94rEUtcQbYg=
Date:   Tue, 29 Dec 2020 13:00:22 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com,
        jannh@google.com
Subject:  +
 mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch added to
 -mm tree
Message-ID: <20201229210022.PoYQn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: consider rest of partial list if acquire_slab() fails
has been added to the -mm tree.  Its filename is
     mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm, slub: consider rest of partial list if acquire_slab() fails

acquire_slab() fails if there is contention on the freelist of the page
(probably because some other CPU is concurrently freeing an object from
the page).  In that case, it might make sense to look for a different page
(since there might be more remote frees to the page from other CPUs, and
we don't want contention on struct page).

However, the current code accidentally stops looking at the partial list
completely in that case.  Especially on kernels without CONFIG_NUMA set,
this means that get_partial() fails and new_slab_objects() falls back to
new_slab(), allocating new pages.  This could lead to an unnecessary
increase in memory fragmentation.

Link: https://lkml.kernel.org/r/20201228130853.1871516-1-jannh@google.com
Fixes: 7ced37197196 ("slub: Acquire_slab() avoid loop")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails
+++ a/mm/slub.c
@@ -1973,7 +1973,7 @@ static void *get_partial_node(struct kme
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
 		if (!t)
-			break;
+			continue; /* cmpxchg raced */
 
 		available += objects;
 		if (!object) {
_

Patches currently in -mm which might be from jannh@google.com are

mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch

