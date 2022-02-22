Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423A1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiBVDm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:42:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240125AbiBVDmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:42:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5511022B20
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1B36CE1292
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A570C340E8;
        Tue, 22 Feb 2022 03:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645501348;
        bh=/ij7eWnNthsK6VXpko58cULwaW29AEqx18Ro6evmfg8=;
        h=Date:To:From:Subject:From;
        b=hEbNa6CQBowLQc0jcaOdowoxU2Fa7TFEwt0dDcqKI8h4kECbV00GYn2KjI2czsndW
         zMpBCLoIUEAcRwnGqu027RCvNMM/BNgGxXr8Tq9Lrq4KMYs2aEJb0ePYqqkgDD0VRc
         8ISyRcYtg6gfGShmBvg+iePiKBxkeBqYBoZ3f8CE=
Date:   Mon, 21 Feb 2022 19:42:27 -0800
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        i.zhbanov@omprussia.ru, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + inith-improve-__setup-and-early_param-documentation.patch added to -mm tree
Message-Id: <20220222034228.0A570C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init.h: improve __setup and early_param documentation
has been added to the -mm tree.  Its filename is
     inith-improve-__setup-and-early_param-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/inith-improve-__setup-and-early_param-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/inith-improve-__setup-and-early_param-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: init.h: improve __setup and early_param documentation

Igor noted in [1] that there are quite a few __setup() handling functions
that return incorrect values.  Doing this can be harmless, but it can also
cause strings to be added to init's argument or environment list,
polluting them.

Since __setup() handling and return values are not documented, first add
documentation for that.  Also add more documentation for early_param()
handling and return values.

For __setup() functions, returning 0 (not handled) has questionable
value if it is just a malformed option value, as in
  rodata=junk
since returning 0 would just cause "rodata=junk" to be added to init's
environment unnecessarily:
  Run /sbin/init as init process
    with arguments:
      /sbin/init
    with environment:
      HOME=/
      TERM=linux
      splash=native
      rodata=junk

Also, there are no recommendations on whether to print a warning when an
unknown parameter value is seen.  I am not addressing that here.

[1] lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru

Link: https://lkml.kernel.org/r/20220221050852.1147-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/init.h~inith-improve-__setup-and-early_param-documentation
+++ a/include/linux/init.h
@@ -320,12 +320,19 @@ struct obs_kernel_param {
 		__aligned(__alignof__(struct obs_kernel_param))		\
 		= { __setup_str_##unique_id, fn, early }
 
+/*
+ * NOTE: __setup functions return values:
+ * @fn returns 1 (or non-zero) if the option argument is "handled"
+ * and returns 0 if the option argument is "not handled".
+ */
 #define __setup(str, fn)						\
 	__setup_param(str, fn, fn, 0)
 
 /*
- * NOTE: fn is as per module_param, not __setup!
- * Emits warning if fn returns non-zero.
+ * NOTE: @fn is as per module_param, not __setup!
+ * I.e., @fn returns 0 for no error or non-zero for error
+ * (possibly @fn returns a -errno value, but it does not matter).
+ * Emits warning if @fn returns non-zero.
  */
 #define early_param(str, fn)						\
 	__setup_param(str, fn, fn, 1)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

