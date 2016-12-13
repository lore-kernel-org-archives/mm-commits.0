From: akpm@linux-foundation.org
Subject: [patch 053/123] mm: cma: make linux/cma.h standalone includible
Date: Mon, 12 Dec 2016 16:43:15 -0800
Message-ID: <584f4423.U/ABhpCa1UWH4pOx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbcLMAnQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, treding@nvidia.com

From: Thierry Reding <treding@nvidia.com>
Subject: mm: cma: make linux/cma.h standalone includible

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
