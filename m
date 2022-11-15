Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A369AC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 01:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKOBU1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 20:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiKOBUW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 20:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95231C90D
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 17:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E99BB8163D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 01:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D0FC433D6;
        Tue, 15 Nov 2022 01:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668475217;
        bh=sOq2sPEbEIQFf+wm939pBhSiih2sv31u5YN5/x3B+2c=;
        h=Date:To:From:Subject:From;
        b=UmeJBxCe0tVO1BLD+r/YzutKC7KAtApEaAPgmRGGzJJd7rbhlpqEFo71c/NwxSEoP
         bgiVWFSCKbCkZhP+GQ39NKoeTji7ezgR4GezFFR3UTQxW+ddEbhUVXmfI2uUD6wHny
         NFbcQMj4veedg6+29KYZyTYYxaGKnpFhI2g1rMiw=
Date:   Mon, 14 Nov 2022 17:20:16 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, dchinner@redhat.com, tjmercier@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-add-missing-includes-for-undeclared-types.patch added to mm-unstable branch
Message-Id: <20221115012017.47D0FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: Add missing includes for undeclared types
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-add-missing-includes-for-undeclared-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-add-missing-includes-for-undeclared-types.patch

This patch will later appear in the mm-unstable branch at
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
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: shrinkers: Add missing includes for undeclared types
Date: Mon, 14 Nov 2022 23:59:49 +0000

The shrinker.h header depends on a user including other headers before it
for types used by shrinker.h.  Fix this by including the appropriate
headers in shrinker.h.

./include/linux/shrinker.h:13:9: error: unknown type name `gfp_t'
   13 |         gfp_t gfp_mask;
      |         ^~~~~
./include/linux/shrinker.h:71:26: error: field `list' has incomplete type
   71 |         struct list_head list;
      |                          ^~~~
./include/linux/shrinker.h:82:9: error: unknown type name `atomic_long_t'
   82 |         atomic_long_t *nr_deferred;
      |

Link: https://lkml.kernel.org/r/20221114235949.201749-1-tjmercier@google.com
Fixes: 83aeeada7c69 ("vmscan: use atomic-long for shrinker batching")
Fixes: b0d40c92adaf ("superblock: introduce per-sb cache shrinker infrastructure")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/shrinker.h~mm-shrinkers-add-missing-includes-for-undeclared-types
+++ a/include/linux/shrinker.h
@@ -2,6 +2,9 @@
 #ifndef _LINUX_SHRINKER_H
 #define _LINUX_SHRINKER_H
 
+#include <linux/atomic.h>
+#include <linux/types.h>
+
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
  * We consolidate the values for easier extension later.
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-shrinkers-add-missing-includes-for-undeclared-types.patch

