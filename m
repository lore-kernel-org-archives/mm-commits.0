Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476A9CD484A
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 17:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjIVRtx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjIVRtn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 13:49:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A12CD2
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 10:49:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6923C433CB;
        Fri, 22 Sep 2023 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695404974;
        bh=PHUdEQ/U2wqVVFFLVCd277wTjiqzSjNTz1Io5kpe1SU=;
        h=Date:To:From:Subject:From;
        b=2Eqp/z2nnSutVX2fCmalYPtFhIzkEy0J3oW9qbhLCz7nu2ricCgBNORIGwAzuIygR
         yKG4NOO8PYO7vetaLWJMRxWf4XjMzHnzynQWy1Aa2gW7Yhj21jkmsS1bEK51hkwUf+
         Dp8ZUIjI54muve52kemo++1ZUo1CUxOGjQqZ5Co0=
Date:   Fri, 22 Sep 2023 10:49:34 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922174934.D6923C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: fix potential memory corruption on duplicate store
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: fix potential memory corruption on duplicate store
Date: Fri, 22 Sep 2023 19:22:11 +0200

While stress-testing zswap a memory corruption was happening when writing
back pages.  __frontswap_store used to check for duplicate entries before
attempting to store a page in zswap, this was because if the store fails
the old entry isn't removed from the tree.  This change removes duplicate
entries in zswap_store before the actual attempt.

Based on commit ce9ecca0238b ("Linux 6.6-rc2")

Link: https://lkml.kernel.org/r/20230922172211.1704917-1-cerasuolodomenico@gmail.com
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-potential-memory-corruption-on-duplicate-store
+++ a/mm/zswap.c
@@ -1219,6 +1219,19 @@ bool zswap_store(struct folio *folio)
 		return false;
 
 	/*
+	 * If this is a duplicate, it must be removed before attempting to store
+	 * it, otherwise, if the store fails the old page won't be removed from
+	 * the tree, and it might be written back overriding the new data.
+	 */
+	spin_lock(&tree->lock);
+	dupentry = zswap_rb_search(&tree->rbroot, offset);
+	if (dupentry) {
+		zswap_duplicate_entry++;
+		zswap_invalidate_entry(tree, dupentry);
+	}
+	spin_unlock(&tree->lock);
+
+	/*
 	 * XXX: zswap reclaim does not work with cgroups yet. Without a
 	 * cgroup-aware entry LRU, we will push out entries system-wide based on
 	 * local cgroup limits.
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch
zswap-make-shrinking-memcg-aware.patch

