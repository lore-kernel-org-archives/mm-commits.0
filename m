Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD59C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiD1X1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiD1X1U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B209BC870
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 862F7620C6
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB021C385AD;
        Thu, 28 Apr 2022 23:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651188243;
        bh=jn+23m+f4BmD+9DOg9iBwR++adqoVapI+7t2WbgMlKM=;
        h=Date:To:From:Subject:From;
        b=AXs5Vc3cTsWaQulD6VTveCdvXyXHzVdfYWdP7tBwAQTu6U7PeLdZ+wKI4UaYMnrji
         Dys3RTb3zKMA15UDSVi7FzSF5wGr4RCRywRP1FV7ATTgXd6tB2p4atROjnNcxR4Lwj
         YhPF0rEZF4IC49UfYOxS6k4lydahxJ+dRe6GNCnA=
Date:   Thu, 28 Apr 2022 16:24:03 -0700
To:     mm-commits@vger.kernel.org, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch added to -mm tree
Message-Id: <20220428232403.DB021C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: filter out vermagic as it is not relevant
has been added to the -mm tree.  Its filename is
     scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: scripts/bloat-o-meter: filter out vermagic as it is not relevant

Seeing it as a false positive increase at the top is just noise:

   linux-head$./scripts/bloat-o-meter ../pre/vmlinux ../post/vmlinux
   add/remove: 0/571 grow/shrink: 1/9 up/down: 20/-64662 (-64642)
   Function                                     old     new   delta
   vermagic                                      49      69     +20

Since it really doesn't "grow", it makes sense to filter it out.

Link: https://lkml.kernel.org/r/20220428035824.7934-1-paul.gortmaker@windriver.com
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant
+++ a/scripts/bloat-o-meter
@@ -36,6 +36,7 @@ def getsizes(file, format):
                 if name.startswith("__se_compat_sys"): continue
                 if name.startswith("__addressable_"): continue
                 if name == "linux_banner": continue
+                if name == "vermagic": continue
                 # statics and some other optimizations adds random .NUMBER
                 name = re_NUMBER.sub('', name)
                 sym[name] = sym.get(name, 0) + int(size, 16)
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch

