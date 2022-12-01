Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F58C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiLAAGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiLAAEI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5BD8EE74
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED965B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0E9C433D6;
        Thu,  1 Dec 2022 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852912;
        bh=/wbwr8eeCxDze2N4iMBX7c/7uSrUV60dwCHQjFUcA6A=;
        h=Date:To:From:Subject:From;
        b=r5XMegAyBJckpvZVM/PhExr3oCBCi3XChcP33jAg66/KBMI+R6HevV6f2VuVrvHsZ
         hPEyxy7ZCm+46IESWm+bmAlpxF29E0WTUYkkI5B7G7NqxtXvk2mFwLBY1YRt3LnQ1F
         WpGJi7doviavXW8h/yU+ko9r0XSk4VaXI/5NW+fQ=
Date:   Wed, 30 Nov 2022 16:01:51 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, dchinner@redhat.com, tjmercier@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinkers-add-missing-includes-for-undeclared-types.patch removed from -mm tree
Message-Id: <20221201000152.8D0E9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shrinkers: add missing includes for undeclared types
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-add-missing-includes-for-undeclared-types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: shrinkers: add missing includes for undeclared types
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


