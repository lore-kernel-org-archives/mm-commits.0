From: akpm@linux-foundation.org
Subject: [merged] lindent-handle-missing-indent-gracefully.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:01:48 -0700
Message-ID: <55ef228c.2o5QIF2es126Rzx5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/Lindent: handle missing indent gracefully
has been removed from the -mm tree.  Its filename was
     lindent-handle-missing-indent-gracefully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


