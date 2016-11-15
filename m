From: akpm@linux-foundation.org
Subject: + mm-cma-make-linux-cmah-standalone-includible.patch added to -mm tree
Date: Tue, 15 Nov 2016 15:43:18 -0800
Message-ID: <582b9d96.YRh2HPaM5VAL2KXY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcKOXnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: Make linux/cma.h standalone includible
has been added to the -mm tree.  Its filename is
     mm-cma-make-linux-cmah-standalone-includible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-make-linux-cmah-standalone-includible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-make-linux-cmah-standalone-includible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: mm: cma: Make linux/cma.h standalone includible

The header uses types and definitions from the linux/init.h as well as
linux/types.h headers without explicitly including them. This causes a
failure to compile if they are not implicitly pulled in by includers.

Link: http://lkml.kernel.org/r/20161115133235.13387-1-thierry.reding@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/cma.h~mm-cma-make-linux-cmah-standalone-includible include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-make-linux-cmah-standalone-includible
+++ a/include/linux/cma.h
@@ -1,6 +1,9 @@
 #ifndef __CMA_H__
 #define __CMA_H__
 
+#include <linux/init.h>
+#include <linux/types.h>
+
 /*
  * There is always at least global CMA area and a few optional
  * areas configured in kernel .config.
_

Patches currently in -mm which might be from treding@nvidia.com are

mm-cma-make-linux-cmah-standalone-includible.patch

