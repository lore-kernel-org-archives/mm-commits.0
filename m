Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78476C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 20:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbiCPUzr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 16:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiCPUzo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 16:55:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CF417079
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 13:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C72CE60B80
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 20:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A21C340E9;
        Wed, 16 Mar 2022 20:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647464068;
        bh=xLAIhtWl48lNPeAggF6nSD2h8uGFP9jdVZP8YtJyCUA=;
        h=Date:To:From:Subject:From;
        b=Suf2QhEc4bJYTUh9zw+9LXVUPVjj+S1RDmK16/q/gcXs4TFqSzmHrsl6nQ20lIJQv
         QZPdh0N1ez9nFhcuQZDS0QM6jSfIv5TCLUZU1swz2XZ1doupWrhcErcpUP6rlzX4Lt
         VOT1Qtsb+1/xtmahhqr8EUFtWyfyshjRGwwiDeaY=
Date:   Wed, 16 Mar 2022 13:54:27 -0700
To:     mm-commits@vger.kernel.org, guozhengkui@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-uninitialized_varcocci-warning.patch added to -mm tree
Message-Id: <20220316205428.25A21C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/glob.c: fix uninitialized_var.cocci warning
has been added to the -mm tree.  Its filename is
     lib-fix-uninitialized_varcocci-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-fix-uninitialized_varcocci-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-uninitialized_varcocci-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guo Zhengkui <guozhengkui@vivo.com>
Subject: lib/glob.c: fix uninitialized_var.cocci warning

Fix the following coccicheck warning:
lib/glob.c:48:40-41: WARNING this kind of initialization is deprecated.

`char const *back_str = back_str` has the same form of uninitialized_var()
macro.  I remove the redundant assignement.  It has been tested with gcc
(Debian 8.3.0-6) 8.3.0.

The patch which removed uninitialized_var() is:
https://lore.kernel.org/all/20121028102007.GA7547@gmail.com/
And there are very few "/* GCC */" comments in the Linux kernel code now.

Link: https://lkml.kernel.org/r/20220316072709.4746-1-guozhengkui@vivo.com
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-fix-uninitialized_varcocci-warning
+++ a/lib/glob.c
@@ -45,7 +45,7 @@ bool __pure glob_match(char const *pat,
 	 * (no exception for /), it can be easily proved that there's
 	 * never a need to backtrack multiple levels.
 	 */
-	char const *back_pat = NULL, *back_str = back_str;
+	char const *back_pat = NULL, *back_str;
 
 	/*
 	 * Loop over each token (character or class) in pat, matching
_

Patches currently in -mm which might be from guozhengkui@vivo.com are

userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch
lib-fix-uninitialized_varcocci-warning.patch

