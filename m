From: akpm@linux-foundation.org
Subject: + tools-vm-fix-cross-compile-build.patch added to -mm
 tree
Date: Thu, 16 Apr 2020 21:45:30 -0700
Message-ID: <20200417044530.nwVTUpFRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEpc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, martin@martingkelly.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: tools/vm: fix cross-compile build
has been added to the -mm tree.  Its filename is
     tools-vm-fix-cross-compile-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-fix-cross-compile-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-fix-cross-compile-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: tools/vm: fix cross-compile build

7ed1c1901fe5 (tools: fix cross-compile var clobbering) moved the setup of
the CC variable to tools/scripts/Makefile.include to make the behavior
consistent across all the tools Makefiles.  As the vm tools missed the
include we end up with the wrong CC in a cross-compiling evironment.

Link: http://lkml.kernel.org/r/20200416104748.25243-1-l.stach@pengutronix.de
Fixes: 7ed1c1901fe5 (tools: fix cross-compile var clobbering)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Cc: Martin Kelly <martin@martingkelly.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/vm/Makefile~tools-vm-fix-cross-compile-build
+++ a/tools/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
+
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

tools-vm-fix-cross-compile-build.patch
