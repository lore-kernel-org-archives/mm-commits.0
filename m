From: akpm@linux-foundation.org
Subject: + kernel-sysctlc-avoid-overflow.patch added to -mm tree
Date: Tue, 14 Jun 2016 13:19:26 -0700
Message-ID: <576066ce.ud5f5/9Jr/nreAUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbcFNUTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 16:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: avoid overflow
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-avoid-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctlc-avoid-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctlc-avoid-overflow.patch

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
Subject: kernel/sysctl.c: avoid overflow

An undetected overflow may occur in do_proc_dointvec_minmax_conv_param.

Link: http://lkml.kernel.org/r/1465608788-4813-1-git-send-email-xypron.glpk@gmx.de
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-avoid-overflow kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-avoid-overflow
+++ a/kernel/sysctl.c
@@ -2302,7 +2302,17 @@ static int do_proc_dointvec_minmax_conv(
 {
 	struct do_proc_dointvec_minmax_conv_param *param = data;
 	if (write) {
-		int val = *negp ? -*lvalp : *lvalp;
+		int val;
+
+		if (*negp) {
+			if (*lvalp > (unsigned long) INT_MAX + 1)
+				return -EINVAL;
+			val = -*lvalp;
+		} else {
+			if (*lvalp > (unsigned long) INT_MAX)
+				return -EINVAL;
+			val = *lvalp;
+		}
 		if ((param->min && *param->min > val) ||
 		    (param->max && *param->max < val))
 			return -EINVAL;
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

kernel-sysctlc-avoid-overflow.patch

