From: akpm@linux-foundation.org
Subject: [patch 012/142] scripts/Lindent: clean up and optimize
Date: Wed, 22 Feb 2017 15:40:20 -0800
Message-ID: <58ae2164.Bz9BDyKoIJFebGRo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48006 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934011AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jdelvare@suse.de

From: Jean Delvare <jdelvare@suse.de>
Subject: scripts/Lindent: clean up and optimize

* Add a few blank lines to improve readability.
* Don't call cut 3 times when once is enough.
* Drop a useless semicolon.

Link: http://lkml.kernel.org/r/20170104140356.162abab2@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Lindent |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN scripts/Lindent~scripts-lindent-clean-up-and-optimize scripts/Lindent
--- a/scripts/Lindent~scripts-lindent-clean-up-and-optimize
+++ a/scripts/Lindent
@@ -1,21 +1,25 @@
 #!/bin/sh
+
 PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
-RES=`indent --version`
+
+RES=`indent --version | cut -d' ' -f3`
 if [ "$RES" = "" ]; then
 	exit 1
 fi
-V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
-V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
-V3=`echo $RES | cut -d' ' -f3 | cut -d'.' -f3`
+V1=`echo $RES | cut -d'.' -f1`
+V2=`echo $RES | cut -d'.' -f2`
+V3=`echo $RES | cut -d'.' -f3`
+
 if [ $V1 -gt 2 ]; then
   PARAM="$PARAM -il0"
 elif [ $V1 -eq 2 ]; then
   if [ $V2 -gt 2 ]; then
-    PARAM="$PARAM -il0";
+    PARAM="$PARAM -il0"
   elif [ $V2 -eq 2 ]; then
     if [ $V3 -ge 10 ]; then
       PARAM="$PARAM -il0"
     fi
   fi
 fi
+
 indent $PARAM "$@"
_
