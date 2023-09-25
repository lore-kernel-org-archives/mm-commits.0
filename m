Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91A9CE7A95
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjIYPFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjIYPFh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:05:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D540D101
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:05:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2C7C433C7;
        Mon, 25 Sep 2023 15:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695654330;
        bh=AjrBnkbyFXjs+YiiXsBLUbqIA+8zQl6cheAut8bH/tE=;
        h=Date:To:From:Subject:From;
        b=QbLJjCkSA7IObjL7QZ1LbZ0ZgUem2kjZ4xAO1wYB2OYozvHealnlmCkUrK5DLbGkq
         NLwhgXGq4bO+VsaJX7HI2aGFKWn3OcvejSyW0BBo6EZryCzIp4c6ugBoejByg7xSp8
         bpwDxTiDWk65JW13UiB5FcFgbfTq+dP5KNXtcPv0=
Date:   Mon, 25 Sep 2023 08:05:29 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20230925150530.6B2C7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch

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
Subject: mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
Date: Mon, 25 Sep 2023 15:00:02 +0200

add a warning and a comment to the second duplicates check in
zswap_store() (Johannes).

Link: https://lkml.kernel.org/r/20230925130002.1929369-1-cerasuolodomenico@gmail.com
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
+++ a/mm/zswap.c
@@ -1346,7 +1346,14 @@ insert_entry:
 
 	/* map */
 	spin_lock(&tree->lock);
+	/*
+	 * A duplicate entry should have been removed at the beginning of this
+	 * function. Since the swap entry should be pinned, if a duplicate is
+	 * found again here it means that something went wrong in the swap
+	 * cache.
+	 */
 	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
+		WARN_ON(1);
 		zswap_duplicate_entry++;
 		zswap_invalidate_entry(tree, dupentry);
 	}
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch
mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch
zswap-make-shrinking-memcg-aware.patch

