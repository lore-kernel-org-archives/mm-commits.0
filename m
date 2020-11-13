Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957BFC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264A321D79
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1mWxLEBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKMA0L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMA0L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:26:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE1920A8B;
        Fri, 13 Nov 2020 00:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605227171;
        bh=l6Ck+iHljK/Jt/VUObnfgPKgtFcWILjexgPF0jP5p5w=;
        h=Date:From:To:Subject:From;
        b=1mWxLEBW/beChjW6RjK70yq+bDGeyd9D2s/2xiejWuiHUzaBr4nHgfExauyDS3DPd
         7A/c14J8z4kZQpKkxtcBP8zvYuWwOECEYYP9oQx4u9UBH2pl9nm/n9BKUCGSM5WL8a
         s/BRjOJDQn6ySxJYwstvJtl7Nf9O9CRjI+tCs/qg=
Date:   Thu, 12 Nov 2020 16:26:10 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  + kasan-split-out-shadowc-from-commonc-fix2.patch added
 to -mm tree
Message-ID: <20201113002610.x0DDQLyYq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-split-out-shadowc-from-commonc-fix2
has been added to the -mm tree.  Its filename is
     kasan-split-out-shadowc-from-commonc-fix2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-split-out-shadowc-from-commonc-fix2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-split-out-shadowc-from-commonc-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kasan-split-out-shadowc-from-commonc-fix2

mm/kasan/shadow.c needs linux/kfence.h

Link: https://lkml.kernel.org/r/20201111172043.6e56cc71@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/shadow.c~kasan-split-out-shadowc-from-commonc-fix2
+++ a/mm/kasan/shadow.c
@@ -14,6 +14,7 @@
 #include <linux/kasan.h>
 #include <linux/kernel.h>
 #include <linux/kmemleak.h>
+#include <linux/kfence.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/string.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-split-out-mathematical-helpers-fix.patch
kasan-split-out-shadowc-from-commonc-fix2.patch

