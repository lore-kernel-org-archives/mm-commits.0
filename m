From: akpm@linux-foundation.org
Subject: +
 kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch added to -mm tree
Date: Tue, 17 Sep 2013 15:40:40 -0700
Message-ID: <5238da68.yUaRanP22lgRXg0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IQWkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 18:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, gang.chen@asianux.com

Subject: + kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch added to -mm tree
To: gang.chen@asianux.com,ebiederm@xmission.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 15:40:40 -0700


The patch titled
     Subject: kernel/sysctl.c: check return value after call proc_put_char() in __do_proc_doulongvec_minmax()
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/sysctl.c: check return value after call proc_put_char() in __do_proc_doulongvec_minmax()

Need to check the return value of proc_put_char(), as was done in
__do_proc_doulongvec_minmax().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax
+++ a/kernel/sysctl.c
@@ -2214,8 +2214,11 @@ static int __do_proc_doulongvec_minmax(v
 			*i = val;
 		} else {
 			val = convdiv * (*i) / convmul;
-			if (!first)
+			if (!first) {
 				err = proc_put_char(&buffer, &left, '\t');
+				if (err)
+					break;
+			}
 			err = proc_put_long(&buffer, &left, val, false);
 			if (err)
 				break;
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch

