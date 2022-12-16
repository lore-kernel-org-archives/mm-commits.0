Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACD0C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLPAgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLPAgD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:36:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE65E0A6
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A77B61FB9
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23B3C433EF;
        Fri, 16 Dec 2022 00:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671150959;
        bh=XX9HCg+zeWJnA43GNJDhiBF/KmtaGRnLj/483jCaW+s=;
        h=Date:To:From:Subject:From;
        b=UD1L0y0/rolv22fSnFuTMgBvPgX+WYBW4pFQ1NrcM26yJ+BfmalAH8ARBQpffXhpw
         Z8++aYjZWHS21OktjEwd6kOoCOGLxV2HLJelT2ZDlF/mirBK4ZlwwTHprAeIMGbTGq
         sp0JFDCuj4qH4HEDICfAQO9NXMTsW4K5pZuZe0mQ=
Date:   Thu, 15 Dec 2022 16:35:58 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        mhiramat@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + error-injection-remove-ei_etype_none-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221216003558.E23B3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: error-injection-remove-ei_etype_none-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     error-injection-remove-ei_etype_none-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/error-injection-remove-ei_etype_none-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: error-injection-remove-ei_etype_none-fix
Date: Thu Dec 15 04:33:32 PM PST 2022

include/linux/error-injection.h needs errno.h
lib/error-inject.c

Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/error-injection.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/error-injection.h~error-injection-remove-ei_etype_none-fix
+++ a/include/linux/error-injection.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <asm-generic/error-injection.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

error-injection-remove-ei_etype_none-fix.patch

