Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8864AEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjHUUrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjHUUr1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD49180
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD2164AFC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A56C433C7;
        Mon, 21 Aug 2023 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650837;
        bh=PhtZFRoOPOCGnPzBsXjxkp7YG/+VHj26dlqh28q1Yfk=;
        h=Date:To:From:Subject:From;
        b=x22GRA3Bt+VI6BG50jZEZ6OF2jfL2g8gXsR/SR/PmJv415vMuZHnB9kE+TKpHL3UA
         vrl+jDTzzZV1nBM8k8OFXQWg4vBpSCOIZ4N+/t/pleYwRZq8CgQuHtFL8p+BiB0MF5
         Am2CyueTsAo/OCxFgIZDoxFuEY9X1JJVVzOrfDGU=
Date:   Mon, 21 Aug 2023 13:47:16 -0700
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kstrtox-consistently-use-_tolower.patch removed from -mm tree
Message-Id: <20230821204717.73A56C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kstrtox: consistently use _tolower()
has been removed from the -mm tree.  Its filename was
     kstrtox-consistently-use-_tolower.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kstrtox: consistently use _tolower()
Date: Thu, 17 Aug 2023 17:59:19 +0300

We already use _tolower() in other places, so convert the one which open
codes it.

Link: https://lkml.kernel.org/r/20230817145919.543251-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~kstrtox-consistently-use-_tolower
+++ a/lib/kstrtox.c
@@ -59,7 +59,7 @@ unsigned int _parse_integer_limit(const
 	rv = 0;
 	while (max_chars--) {
 		unsigned int c = *s;
-		unsigned int lc = c | 0x20; /* don't tolower() this line */
+		unsigned int lc = _tolower(c);
 		unsigned int val;
 
 		if ('0' <= c && c <= '9')
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


