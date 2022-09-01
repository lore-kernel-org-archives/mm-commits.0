Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8051AECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 23:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiIAX02 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 19:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiIAX00 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 19:26:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C443474FB
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 16:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B58B82966
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 23:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C6CC433D6;
        Thu,  1 Sep 2022 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662074783;
        bh=j/7fxBd2Wu53n2nWCMSejyGuEQ9PD/I8HAImoLKSfXg=;
        h=Date:To:From:Subject:From;
        b=rCZ/V5L98tmpVyDdV/pVAAEugKRHl8pZfgjjFGt60RlCDbuuNthLweCCErqt9NHFl
         pILaK9uapOcYFynDPkv3dAtxcL85TcQ9gXB1lEWHBYZ9g7FT/WG6h6uExZ0xwMZAaK
         t+ycHj62p74gY+7baMYIoKNL2q1LeYlDOOymuSPs=
Date:   Thu, 01 Sep 2022 16:26:22 -0700
To:     mm-commits@vger.kernel.org, kbusch@kernel.org, arnd@arndb.de,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch added to mm-nonmm-unstable branch
Message-Id: <20220901232623.73C6CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: make parameter types consistent in _unaligned_be48()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: asm-generic: make parameter types consistent in _unaligned_be48()
Date: Tue, 30 Aug 2022 20:27:13 +0300

There is a convention to use internal kernel types, so replace __u8 by u8.

Link: https://lkml.kernel.org/r/20220830172713.43686-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/unaligned.h~asm-generic-make-parameter-types-consisten-in-_unaligned_be48
+++ a/include/asm-generic/unaligned.h
@@ -126,7 +126,7 @@ static inline void put_unaligned_le24(co
 	__put_unaligned_le24(val, p);
 }
 
-static inline void __put_unaligned_be48(const u64 val, __u8 *p)
+static inline void __put_unaligned_be48(const u64 val, u8 *p)
 {
 	*p++ = val >> 40;
 	*p++ = val >> 32;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch

