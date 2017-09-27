From: akpm@linux-foundation.org
Subject: +
 sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 14:47:37 -0700
Message-ID: <59cc1c79.ApmwLYY9i2xA0HYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdI0Vri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 17:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, dcb314@hotmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()
has been added to the -mm tree.  Its filename is
     sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()

do_proc_douintvec_conv() has two UINT_MAX checks, we can remove one.  This
has no functional changes other than fixing a compiler warning:

kernel/sysctl.c:2190]: (warning) Identical condition '*lvalp>UINT_MAX', second condition is always false

Fixes: 4f2fec00afa60 ("sysctl: simplify unsigned int support")
Link: http://lkml.kernel.org/r/20170919072918.12066-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: David Binderman <dcb314@hotmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv
+++ a/kernel/sysctl.c
@@ -2187,8 +2187,6 @@ static int do_proc_douintvec_conv(unsign
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		if (*lvalp > UINT_MAX)
-			return -EINVAL;
 		*valp = *lvalp;
 	} else {
 		unsigned int val = *valp;
_

Patches currently in -mm which might be from mcgrof@kernel.org are

sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch

