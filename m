Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9405FC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67548224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgLODMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:11:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001866;
        bh=bbUTPz54ONPMlciSvW7da9cTCR3XEOaNnjLAxrnWSJM=;
        h=From:To:Subject:In-Reply-To:From;
        b=g5Uu3BL4ubjA3xahHjkxnjLLBhYEkjnjoPycloFnC8DCs9NPQeWlcNh9k66hV+M04
         +Ama7gcBABNlHc3RKRud0O+C54KTH+EMScdJCTaUHFouroQCeE4Lvdo2W4CVM3Zvog
         rmYC5Oj7Fbkw62NH5X2rR0aqfg9NogzvA6/uIELs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 131/200] mm/page-flags: fix comment
Message-ID: <20201215031105.OY7I_sH9Y%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-flags: fix comment

We haven't had 'dontuse' flags since 2002.  Replace this obsolete warning
with a hopefully more useful one.

Link: https://lkml.kernel.org/r/20201027025823.3704-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-fix-comment
+++ a/include/linux/page-flags.h
@@ -86,8 +86,7 @@
  */
 
 /*
- * Don't use the *_dontuse flags.  Use the macros.  Otherwise you'll break
- * locked- and dirty-page accounting.
+ * Don't use the pageflags directly.  Use the PageFoo macros.
  *
  * The page flags field is split into two parts, the main flags area
  * which extends from the low bits upwards, and the fields area which
_
