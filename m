Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B0DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiBXEeg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXEef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:34:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8AE15C1AA
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41DB6B823FA
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E24C340E9;
        Thu, 24 Feb 2022 04:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677243;
        bh=/nEjELsuEb3nwhSnSgLcBAs1+LMpwEjG1hAbSIgdsNQ=;
        h=Date:To:From:Subject:From;
        b=v9VGXrJjwXzCr0Xkm8bXPxSGrtrTU1MNmzzhxkjtwD71NVFaA+r0OgCgJyxiTl00O
         ryBHuxIwwnVJpbjOpwc8HmGSpJsvJuNfnqWako5PSDhePJfgdPbYrht/uztKa1kG7Z
         6k6HB4KpODjatsqwQhdQK7LPTtWTjxl6tggjB/SY=
Date:   Wed, 23 Feb 2022 20:34:03 -0800
To:     mm-commits@vger.kernel.org, weizhenliang@huawei.com,
        skhan@linuxfoundation.org, rdunlap@infradead.org,
        georgi.djakov@linaro.org, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-vm-page_ownerrst-fix-commends.patch added to -mm tree
Message-Id: <20220224043403.D1E24C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: fix comments
has been added to the -mm tree.  Its filename is
     documentation-vm-page_ownerrst-fix-commends.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-page_ownerrst-fix-commends.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-page_ownerrst-fix-commends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: Documentation/vm/page_owner.rst: fix comments

There are some comments that need to be fixed.

Thanks for Shuah Khan's constructive suggestions.  The comments have been
fixed as follows.

a. So, if you'd like to use it, you need
to add "page_owner=on" into your boot cmdline.

Here, "into" has been replaced with "to".

b. ...page owner is disabled in runtime due to no
enabling, boot option, runtime overhead is marginal.

Here, "no" has been replaced with "not".

Link: https://lkml.kernel.org/r/20220223134104.2663-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-fix-commends
+++ a/Documentation/vm/page_owner.rst
@@ -26,9 +26,9 @@ fragmentation statistics can be obtained
 each page. It is already implemented and activated if page owner is
 enabled. Other usages are more than welcome.
 
-page owner is disabled in default. So, if you'd like to use it, you need
-to add "page_owner=on" into your boot cmdline. If the kernel is built
-with page owner and page owner is disabled in runtime due to no enabling
+page owner is disabled by default. So, if you'd like to use it, you need
+to add "page_owner=on" to your boot cmdline. If the kernel is built
+with page owner and page owner is disabled in runtime due to not enabling
 boot option, runtime overhead is marginal. If disabled in runtime, it
 doesn't require memory to store owner information, so there is no runtime
 memory overhead. And, page owner inserts just two unlikely branches into
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
documentation-vm-page_ownerrst-fix-commends.patch
mm-page_ownerc-record-tgid.patch
tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

