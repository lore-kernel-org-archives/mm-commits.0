Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01728C43334
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiFXTUw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiFXTUv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F3679298
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8556B621CF
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74BFC34114;
        Fri, 24 Jun 2022 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656098449;
        bh=eu9QFYaaf9EHfMgTsVLoghPy1mfsiS9zs3VxpPef9R0=;
        h=Date:To:From:Subject:From;
        b=H5S5sHONj+86ck2TAKP971GKTeXXAtFG5Yna5EkVwz8GvtngwN1ibeXHAQn4g2hBt
         vnvRWFIo5VLPIFbI/oFCV0BaMPewCPpfJ0bWR0xNvhTIj7V94u++9F4kj0mIIXKOrd
         2P5v3sRyXr10r+bgP2s5bCSNtvuuA09r4+6b0eG8=
Date:   Fri, 24 Jun 2022 12:20:49 -0700
To:     mm-commits@vger.kernel.org, stefani@seibold.net,
        randy.dunlap@oracle.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-fix-kfifo_to_user-return-type.patch added to mm-nonmm-unstable branch
Message-Id: <20220624192049.D74BFC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix kfifo_to_user() return type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-fix-kfifo_to_user-return-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-fix-kfifo_to_user-return-type.patch

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
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: kfifo: fix kfifo_to_user() return type
Date: Fri, 24 Jun 2022 08:30:04 +0300

The kfifo_to_user() macro is supposed to return zero for success or
negative error codes.  Unfortunately, there is a signedness bug so it
returns unsigned int.  This only affects callers which try to save the
result in ssize_t and as far as I can see the only place which does that
is line6_hwdep_read().

TL;DR: s/_uint/_int/.

Link: https://lkml.kernel.org/r/YrVL3OJVLlNhIMFs@kili
Fixes: 144ecf310eb5 ("kfifo: fix kfifo_alloc() to return a signed int value")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kfifo.h~kfifo-fix-kfifo_to_user-return-type
+++ a/include/linux/kfifo.h
@@ -688,7 +688,7 @@ __kfifo_uint_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_to_user(fifo, to, len, copied) \
-__kfifo_uint_must_check_helper( \
+__kfifo_int_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

kfifo-fix-kfifo_to_user-return-type.patch

