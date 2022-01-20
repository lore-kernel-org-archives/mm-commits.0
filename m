Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F06C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347699AbiATV0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57940 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377751AbiATV0Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 229B3B81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2147C340E0;
        Thu, 20 Jan 2022 21:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713981;
        bh=713RCW+LkG74yKjOBESGcZ/PyDub0iwBp6tKrUQ8lww=;
        h=Date:From:To:Subject:From;
        b=nsqBiMiHq42rbC4h6F7an481ILphhcXriJa6aT7mMji+PQ3SlSaj0G8ynELxG0+xx
         RM9Dr4uAztCG1IcRC2p/J58kkzIn+tzBpuUzO+uEFLEfjX7Nzi+RkSZ3jsgvkKG29k
         r+aFvYqUO+UxrLapA1PSeveXDb+5C5MBL7+JDz6c=
Date:   Thu, 20 Jan 2022 13:26:21 -0800
From:   akpm@linux-foundation.org
To:     deng.changcheng@zte.com.cn, mm-commits@vger.kernel.org,
        zealci@zte.com.cn
Subject:  [merged] mm-fix-boolreturncocci-warning.patch removed
 from -mm tree
Message-ID: <20220120212621.a12MXsfrf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix boolreturn.cocci warning
has been removed from the -mm tree.  Its filename was
     mm-fix-boolreturncocci-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


