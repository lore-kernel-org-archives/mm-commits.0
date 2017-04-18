From: akpm@linux-foundation.org
Subject: + fault-inject-simplify-access-check-for-fail-nth-fix.patch added to -mm tree
Date: Tue, 18 Apr 2017 15:03:57 -0700
Message-ID: <58f68d4d.udE7e4daD5Oi7xkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdDRWD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 18:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: don't convert unsigned type value as signed int
has been added to the -mm tree.  Its filename is
     fault-inject-simplify-access-check-for-fail-nth-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-simplify-access-check-for-fail-nth-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-simplify-access-check-for-fail-nth-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: don't convert unsigned type value as signed int

This fixes fault-inject-simplify-access-check-for-fail-nth.patch in -mm
tree which by mistake partially reverts the change by fault-inject-
parse-as-natural-1-based-value-for-fail-nth-write-interface.patch.

Link: http://lkml.kernel.org/r/1492444483-9239-1-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth-fix fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth-fix
+++ a/fs/proc/base.c
@@ -1366,7 +1366,7 @@ static ssize_t proc_fail_nth_write(struc
 	int err;
 	unsigned int n;
 
-	err = kstrtoint_from_user(buf, count, 0, &n);
+	err = kstrtouint_from_user(buf, count, 0, &n);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
fault-inject-make-fail-nth-read-write-interface-symmetric.patch
fault-inject-simplify-access-check-for-fail-nth.patch
fault-inject-simplify-access-check-for-fail-nth-fix.patch
fault-inject-add-proc-pid-fail-nth.patch

