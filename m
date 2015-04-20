From: akpm@linux-foundation.org
Subject: [merged] sysctl-detect-overflows-when-converting-to-int.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:00 -0700
Message-ID: <55355160.btihHl/qVROMZY/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbbDTTNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: detect overflows when converting to int
has been removed from the -mm tree.  Its filename was
     sysctl-detect-overflows-when-converting-to-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: kernel/sysctl.c: detect overflows when converting to int

When converting unsigned long to int overflows may occur.  These currently
are not detected when writing to the sysctl file system.

E.g. on a system where int has 32 bits and long has 64 bits
  echo 0x800001234 > /proc/sys/kernel/threads-max
has the same effect as
  echo 0x1234 > /proc/sys/kernel/threads-max

The patch adds the missing check in do_proc_dointvec_conv.

With the patch an overflow will result in an error EINVAL when writing to
the the sysctl file system.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-detect-overflows-when-converting-to-int kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-detect-overflows-when-converting-to-int
+++ a/kernel/sysctl.c
@@ -1981,7 +1981,15 @@ static int do_proc_dointvec_conv(bool *n
 				 int write, void *data)
 {
 	if (write) {
-		*valp = *negp ? -*lvalp : *lvalp;
+		if (*negp) {
+			if (*lvalp > (unsigned long) INT_MAX + 1)
+				return -EINVAL;
+			*valp = -*lvalp;
+		} else {
+			if (*lvalp > (unsigned long) INT_MAX)
+				return -EINVAL;
+			*valp = *lvalp;
+		}
 	} else {
 		int val = *valp;
 		if (val < 0) {
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

origin.patch

