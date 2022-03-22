Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6F2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiCVVo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiCVVoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731435F4D4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D47B81DB1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AADC340EE;
        Tue, 22 Mar 2022 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985347;
        bh=+jM+T2Xr+b7Pjmhh1FKJbinEX4Z6x00Ku09S6Q0DdpA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=x+Z1IgL+D9OaavxQCvteIOAmxOihuq7OzFRE4Nm4EVLlFaNkdvAH+dTk/3Qg8nrCe
         2up1LRVApKC5hdASVWFqz/m+6az/iBtBtEYSCTfZlUUE4bEG3e+KjfaRZn8K0TmV5u
         uFpgDf47Fkvs1/uyqxHw5U/QprCVoHRSe/sN6YHs=
Date:   Tue, 22 Mar 2022 14:42:27 -0700
To:     i.zhbanov@omprussia.ru, hughd@google.com, rdunlap@infradead.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 077/227] mm/mmap: return 1 from stack_guard_gap __setup() handler
Message-Id: <20220322214227.D8AADC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/mmap: return 1 from stack_guard_gap __setup() handler

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).  This prevents:

  Unknown kernel command line parameters \
  "BOOT_IMAGE=/boot/bzImage-517rc5 stack_guard_gap=100", will be \
  passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     stack_guard_gap=100

Return 1 to indicate that the boot option has been handled.

Note that there is no warning message if someone enters:
	stack_guard_gap=anything_invalid
and 'val' and stack_guard_gap are both set to 0 due to the use of
simple_strtoul(). This could be improved by using kstrtoxxx() and
checking for an error.

It appears that having stack_guard_gap == 0 is valid (if unexpected) since
using "stack_guard_gap=0" on the kernel command line does that.

Link: https://lkml.kernel.org/r/20220222005817.11087-1-rdunlap@infradead.org
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 1be7107fbe18e ("mm: larger stack guard gap, between vmas")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-return-1-from-stack_guard_gap-__setup-handler
+++ a/mm/mmap.c
@@ -2557,7 +2557,7 @@ static int __init cmdline_parse_stack_gu
 	if (!*endptr)
 		stack_guard_gap = val << PAGE_SHIFT;
 
-	return 0;
+	return 1;
 }
 __setup("stack_guard_gap=", cmdline_parse_stack_guard_gap);
 
_
