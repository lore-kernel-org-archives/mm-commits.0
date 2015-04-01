From: akpm@linux-foundation.org
Subject: + sysctl-detect-overflows-when-converting-to-int.patch added to
 -mm tree
Date: Wed, 01 Apr 2015 12:20:29 -0700
Message-ID: <551c44fd.qYSYLAjFlvMrDkzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbDATUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 15:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: detect overflows when converting to int
has been added to the -mm tree.  Its filename is
     sysctl-detect-overflows-when-converting-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-detect-overflows-when-converting-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-detect-overflows-when-converting-to-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1980,7 +1980,15 @@ static int do_proc_dointvec_conv(bool *n
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

kernel-forkc-new-function-for-max_threads.patch
kernel-forkc-avoid-division-by-zero.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
kernel-sysctlc-threads-max-observe-limits.patch
doc-sysctl-kerneltxt-document-threads-max.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
sysctl-detect-overflows-when-converting-to-int.patch
linux-next.patch

