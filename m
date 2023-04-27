Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAB0C77B73
	for <mm-commits@archiver.kernel.org>; Thu, 27 Apr 2023 20:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344364AbjD0Uqi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 16:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344336AbjD0UqV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 16:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7E14EC3
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 13:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B9863FC0
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC46C433EF;
        Thu, 27 Apr 2023 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682628363;
        bh=QUplRqYND67LN8uI36ngmOsxgnntw6Rua9wdX1hhYec=;
        h=Date:To:From:Subject:From;
        b=mB2SEUAdQmnQxg6F9Y3J5i3nVvGm3DAQqAzxgrrw7ZfsViiVovBky9tDYiYHdsXfL
         iATU5HoQzkGN0/mxQNdN9G9uIVoT0jTM1jCjOf2RYoOyMYl9XzcIIKsQ6jPGiPD+FZ
         06Jl8ef06oJDWetm98sj/C+8fchaGcBUNAQO8oX0=
Date:   Thu, 27 Apr 2023 13:46:02 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jcmvbkbc@gmail.com,
        chris@zankel.net, arnd@arndb.de, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] libgcc-add-forward-declarations-for-generic-library-routines.patch removed from -mm tree
Message-Id: <20230427204603.5DC46C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: libgcc: add forward declarations for generic library routines
has been removed from the -mm tree.  Its filename was
     libgcc-add-forward-declarations-for-generic-library-routines.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


