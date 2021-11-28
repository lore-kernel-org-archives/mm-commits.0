Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8459CC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhK1AHn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:07:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhK1AFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:05:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6740660F56
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B174CC53FAD;
        Sun, 28 Nov 2021 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638057747;
        bh=vn29qr75qhK//+Ehmkqxiuarjk6fuXWdH4vyx6L/RrQ=;
        h=Date:From:To:Subject:From;
        b=bibFToMsZ6o0klIFU3o30UW7LNmkqwCgJPoiIv5oX6SN7o2ACI8jJ98Z1d5AZOdEg
         LUQCqtcqI6VV0THCnFbzo1iDCb/MiMhZIt25yhIEP9lEA9SjhzdMjHYcERTL3HLL7B
         B8Y9ofNQd58vX5hORSLpmiA+Yvdz7uwN6WbxtNW0=
Date:   Sat, 27 Nov 2021 16:02:27 -0800
From:   akpm@linux-foundation.org
To:     deng.changcheng@zte.com.cn, mm-commits@vger.kernel.org,
        zealci@zte.com.cn
Subject:  + mm-fix-boolreturncocci-warning.patch added to -mm tree
Message-ID: <20211128000227.0ePQ4ZlCI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix boolreturn.cocci warning
has been added to the -mm tree.  Its filename is
     mm-fix-boolreturncocci-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-boolreturncocci-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-boolreturncocci-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changcheng Deng <deng.changcheng@zte.com.cn>
Subject: mm: fix boolreturn.cocci warning

Return statements in functions returning bool should use true/false
instead of 1/0.

Link: https://lkml.kernel.org/r/20211126073327.74815-1-deng.changcheng@zte.com.cn
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-fix-boolreturncocci-warning
+++ a/include/linux/page-flags.h
@@ -383,7 +383,7 @@ static __always_inline int TestClearPage
 	TESTCLEARFLAG(uname, lname, policy)
 
 #define TESTPAGEFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_##lname(const struct folio *folio) { return 0; } \
+static inline bool folio_test_##lname(const struct folio *folio) { return false; } \
 static inline int Page##uname(const struct page *page) { return 0; }
 
 #define SETPAGEFLAG_NOOP(uname, lname)					\
_

Patches currently in -mm which might be from deng.changcheng@zte.com.cn are

mm-fix-boolreturncocci-warning.patch

