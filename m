Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B488C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 19:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349602AbiCPTkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 15:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344624AbiCPTkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 15:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D51C53E01
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 12:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A15360FA0
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 19:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B3DC340E9;
        Wed, 16 Mar 2022 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647459575;
        bh=KBY+mgu1MRCRnl7hK5r4HzJMZkkKVmPCc2c9lhlmWpU=;
        h=Date:To:From:Subject:From;
        b=jG0N8UNi4bwZqkOVWzYOyUtDWFaT9fmA23E/7Y18pZtB7F9XPTdI9EOj5HunGTVYJ
         1LtlcMiVbsl9nSIY0E7qRyC6hppODdj+1pdRcMCiru0TtzRI5w6oT/BCRB4yA+Vs7V
         SpU02ItHKfG9Dyisfs5lIRhGxZbJ+vTJMKxkjWwI=
Date:   Wed, 16 Mar 2022 12:39:35 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, mingo@kernel.org,
        akpm@linux-foundation.org, thunder.leizhen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + locking-refcount-use-refcount_warn-to-simplify-code.patch added to -mm tree
Message-Id: <20220316193935.96B3DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/refcount.c: use REFCOUNT_WARN() to simplify code
has been added to the -mm tree.  Its filename is
     locking-refcount-use-refcount_warn-to-simplify-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/locking-refcount-use-refcount_warn-to-simplify-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/locking-refcount-use-refcount_warn-to-simplify-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib/refcount.c: use REFCOUNT_WARN() to simplify code

To avoid the check "new > val" appears twice, and make the style
consistent with that in refcount_warn_saturate().

Link: https://lkml.kernel.org/r/20220316125114.1177-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/refcount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/refcount.c~locking-refcount-use-refcount_warn-to-simplify-code
+++ a/lib/refcount.c
@@ -84,7 +84,7 @@ bool refcount_dec_not_one(refcount_t *r)
 
 		new = val - 1;
 		if (new > val) {
-			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
+			REFCOUNT_WARN("underflow; use-after-free");
 			return true;
 		}
 
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

locking-refcount-use-refcount_warn-to-simplify-code.patch

