From: akpm@linux-foundation.org
Subject: + lindent-handle-missing-indent-gracefully.patch added to -mm
 tree
Date: Fri, 10 Jul 2015 14:38:04 -0700
Message-ID: <55a03b3c.MXaWNHwDaTEm/1bB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbGJViE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/Lindent: handle missing indent gracefully
has been added to the -mm tree.  Its filename is
     lindent-handle-missing-indent-gracefully.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lindent-handle-missing-indent-gracefully.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lindent-handle-missing-indent-gracefully.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: scripts/Lindent: handle missing indent gracefully

If indent is not found, bail out immediately instead of spitting random
shell script error messages.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Lindent |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/Lindent~lindent-handle-missing-indent-gracefully scripts/Lindent
--- a/scripts/Lindent~lindent-handle-missing-indent-gracefully
+++ a/scripts/Lindent
@@ -1,6 +1,9 @@
 #!/bin/sh
 PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
 RES=`indent --version`
+if [ "$RES" = "" ]; then
+	exit 1
+fi
 V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
 V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
 V3=`echo $RES | cut -d' ' -f3 | cut -d'.' -f3`
_

Patches currently in -mm which might be from jdelvare@suse.de are

fs-proc-add-help-for-config_proc_children.patch
lindent-handle-missing-indent-gracefully.patch
linux-next.patch

