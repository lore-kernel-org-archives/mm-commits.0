From: akpm@linux-foundation.org
Subject: [patch 13/17] tools/slabinfo-gnuplot: force to use bash shell
Date: Thu, 14 Dec 2017 15:33:05 -0800
Message-ID: <5a330a31.e+UOrSU1o3K7bgU1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbdLNXdH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changcheng.liu@intel.com, sergey.senozhatsky@gmail.com

From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: tools/slabinfo-gnuplot: force to use bash shell

On some linux distributions, the default link of sh
is dash which deoesn't support split array like
${var//,/ }
It's better to force to use bash shell directly.

Link: http://lkml.kernel.org/r/20171208093751.GA175471@sofia
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo-gnuplot.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/slabinfo-gnuplot.sh~tools-slabinfo-gnuplot-force-to-use-bash-shell tools/vm/slabinfo-gnuplot.sh
--- a/tools/vm/slabinfo-gnuplot.sh~tools-slabinfo-gnuplot-force-to-use-bash-shell
+++ a/tools/vm/slabinfo-gnuplot.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # Sergey Senozhatsky, 2015
 # sergey.senozhatsky.work@gmail.com
_
