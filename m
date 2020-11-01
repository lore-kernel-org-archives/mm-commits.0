Return-Path: <SRS0=QWLf=EH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBD4C388F2
	for <mm-commits@archiver.kernel.org>; Sun,  1 Nov 2020 23:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5A62231B
	for <mm-commits@archiver.kernel.org>; Sun,  1 Nov 2020 23:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604274283;
	bh=i18HIPYOstgnoEJE4rDhhgYh4SsXYU4FpCz6uyHrLXI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oWeD4q6EZA+i+hl/Z3SU44XJ2sst8kZFLjd/NQpb4a/BfnVuswZYifi9vdGSMLfIR
	 kmqDOWfKPHTriuHXZfTzMdoSdsNzxODixtr5sJan2g38zESTkwcnjgVJW/GZOK0HXq
	 KO9SHsbB37R5qsG1NQWXLeMEYJJBhpNqtWYYYYsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgKAXon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 18:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgKAXom (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 18:44:42 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59D9222EA;
        Sun,  1 Nov 2020 23:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604274282;
        bh=i18HIPYOstgnoEJE4rDhhgYh4SsXYU4FpCz6uyHrLXI=;
        h=Date:From:To:Subject:From;
        b=LZN2CeXW3jHmx7wzC208hyl0bWlk0Fwz3d9UjDIRVTIfbW7m8mSQjXiHBx4mfLK6G
         hTZcsT0M91VofgC432d1SdgMok7R+G8nm3tOzrd+Uq9yJd+7S4+vId2iUOsUSuOpGJ
         L79ofWikyJXrtFuHDMaIta7Uqjlzaxwutcrmq4p8=
Date:   Sun, 01 Nov 2020 15:44:41 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dhowells@redhat.com, ink@jurassic.park.msu.ru,
        lkp@intel.com, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rth@twiddle.net, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  + compilerh-fix-barrier_data-on-clang-fix.patch added to
 -mm tree
Message-ID: <20201101234441.FjZjSdCQ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: barrier.h: fix ALPHA builds when SMP is not enabled
has been added to the -mm tree.  Its filename is
     compilerh-fix-barrier_data-on-clang-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compilerh-fix-barrier_data-on-clang-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compilerh-fix-barrier_data-on-clang-fix.patch

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
Subject: asm-generic: barrier.h: fix ALPHA builds when SMP is not enabled

<asm-generic/barrier.h> uses barrier() but needs to #include
<linux/compiler.h> to get a generic definition of it to fix
build errors in arch/alpha/ builds when CONFIG_SMP is not enabled.

Fixes build errors like this (there are several like this):
[49 in the kernel config that was supplied by the 0day bot]

In file included from ../arch/alpha/include/asm/barrier.h:21,
                 from ../arch/alpha/include/asm/atomic.h:6,
                 from ../include/linux/atomic.h:7,
                 from ../include/linux/dcache.h:5,
                 from ../fs/proc/util.c:1:
../arch/alpha/include/asm/atomic.h: In function 'atomic_add_return_relaxed':
../include/asm-generic/barrier.h:78:18: error: implicit declaration of function 'barrier' [-Werror=implicit-function-declaration]
   78 | #define smp_mb() barrier()
      |                  ^~~~~~~

Link: https://lkml.kernel.org/r/20201101231835.4589-1-rdunlap@infradead.org
Fixes: 885df91ca357 ("Create asm-generic/barrier.h")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/barrier.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/barrier.h~compilerh-fix-barrier_data-on-clang-fix
+++ a/include/asm-generic/barrier.h
@@ -13,6 +13,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
 #include <asm/rwonce.h>
 
 #ifndef nop
_

Patches currently in -mm which might be from rdunlap@infradead.org are

compilerh-fix-barrier_data-on-clang-fix.patch
procfs-delete-duplicated-words-other-fixes.patch

