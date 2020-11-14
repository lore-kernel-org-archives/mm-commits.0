Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28714C5519F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D137222252
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwgrJYxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgKNGpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGpy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:45:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660482224E;
        Sat, 14 Nov 2020 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336353;
        bh=gdCS2opki9O+Owndne1iszbawfy+ojb/6Xce090drWo=;
        h=Date:From:To:Subject:From;
        b=PwgrJYxDmR7OVwsMam1759rKkCVIdG3APNZF8G8ADMPg6Ql3lHS5rrHlJckgJ/8DO
         maa33ntAPlEHqZWtVASGLyxKG+/7F2WNeY1n1goq/Dnun4iCRe8qWGZOSLl6ZuUEwZ
         cNahOzz9N0d0woE+Btmb5TwZGrUyX/eWTtDP+PVs=
Date:   Fri, 13 Nov 2020 22:45:52 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dhowells@redhat.com, ink@jurassic.park.msu.ru,
        lkp@intel.com, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rth@twiddle.net, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  [folded-merged]
 compilerh-fix-barrier_data-on-clang-fix.patch removed from -mm tree
Message-ID: <20201114064552.dfn96HQhB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: barrier.h: fix ALPHA builds when SMP is not enabled
has been removed from the -mm tree.  Its filename was
     compilerh-fix-barrier_data-on-clang-fix.patch

This patch was dropped because it was folded into compilerh-fix-barrier_data-on-clang.patch

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

compilerh-fix-barrier_data-on-clang.patch
procfs-delete-duplicated-words-other-fixes.patch

