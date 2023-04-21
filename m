Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D6BC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjDUUq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 16:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjDUUq0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 16:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73A01FD2
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 13:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26C0F651E4
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 20:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D29C433D2;
        Fri, 21 Apr 2023 20:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682109983;
        bh=yXmQFFO/jAN6rAE15HYp8WQHOGZ7U0DjUYO//pjdFSw=;
        h=Date:To:From:Subject:From;
        b=NjwuMu0p5tNjs+pzbCOvB3XAhD/LfdfbNsDuRTZTHSOkP4jjdjzSZVPH85wXZOF03
         kCQcBoHMQl9Nrgxvggws/kksFDagBJ/PfQvlrE2lzQ+7k6dRKDQKkmaVtpW5TWvWQQ
         qjvUJVHByxQ9LTBlNl0B0s46VHbLkkURFKD3UoTU=
Date:   Fri, 21 Apr 2023 13:46:22 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jcmvbkbc@gmail.com,
        chris@zankel.net, arnd@arndb.de, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + libgcc-add-forward-declarations-for-generic-library-routines.patch added to mm-nonmm-unstable branch
Message-Id: <20230421204623.70D29C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libgcc: add forward declarations for generic library routines
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     libgcc-add-forward-declarations-for-generic-library-routines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/libgcc-add-forward-declarations-for-generic-library-routines.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: libgcc: add forward declarations for generic library routines
Date: Fri, 21 Apr 2023 16:54:24 +0200

With W=1 on platforms that use the generic gcc library routines
(csky/loongarch/mips/riscv/sh/xtensa):

    lib/ashldi3.c:9:19: warning: no previous prototype for '__ashldi3' [-Wmissing-prototypes]
	9 | long long notrace __ashldi3(long long u, word_type b)
	  |                   ^~~~~~~~~
      CC      lib/ashrdi3.o
    lib/ashrdi3.c:9:19: warning: no previous prototype for '__ashrdi3' [-Wmissing-prototypes]
	9 | long long notrace __ashrdi3(long long u, word_type b)
	  |                   ^~~~~~~~~
      CC      lib/cmpdi2.o
    lib/cmpdi2.c:9:19: warning: no previous prototype for '__cmpdi2' [-Wmissing-prototypes]
	9 | word_type notrace __cmpdi2(long long a, long long b)
	  |                   ^~~~~~~~
      CC      lib/lshrdi3.o
    lib/lshrdi3.c:9:19: warning: no previous prototype for '__lshrdi3' [-Wmissing-prototypes]
	9 | long long notrace __lshrdi3(long long u, word_type b)
	  |                   ^~~~~~~~~
      CC      lib/muldi3.o
    lib/muldi3.c:49:19: warning: no previous prototype for '__muldi3' [-Wmissing-prototypes]
       49 | long long notrace __muldi3(long long u, long long v)
	  |                   ^~~~~~~~
      CC      lib/ucmpdi2.o
    lib/ucmpdi2.c:8:19: warning: no previous prototype for '__ucmpdi2' [-Wmissing-prototypes]
	8 | word_type notrace __ucmpdi2(unsigned long long a, unsigned long long b)
	  |                   ^~~~~~~~~

Fix this by adding forward declarations to the common libgcc header
file.

Link: https://lkml.kernel.org/r/5cdbe08296693dd53849f199c3933e16e97b33c1.1682088593.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303272214.RxzpA6bP-lkp@intel.com/
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libgcc.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/libgcc.h~libgcc-add-forward-declarations-for-generic-library-routines
+++ a/include/linux/libgcc.h
@@ -27,4 +27,11 @@ typedef union {
 	long long ll;
 } DWunion;
 
+long long notrace __ashldi3(long long u, word_type b);
+long long notrace __ashrdi3(long long u, word_type b);
+word_type notrace __cmpdi2(long long a, long long b);
+long long notrace __lshrdi3(long long u, word_type b);
+long long notrace __muldi3(long long u, long long v);
+word_type notrace __ucmpdi2(unsigned long long a, unsigned long long b);
+
 #endif /* __ASM_LIBGCC_H */
_

Patches currently in -mm which might be from geert+renesas@glider.be are

libgcc-add-forward-declarations-for-generic-library-routines.patch

