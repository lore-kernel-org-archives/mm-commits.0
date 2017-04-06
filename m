From: akpm@linux-foundation.org
Subject: + fault-inject-add-proc-pid-fail-nth.patch added to -mm tree
Date: Thu, 06 Apr 2017 15:56:46 -0700
Message-ID: <58e6c7ae.3UWWVoF1SMrWwfZX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdDFW4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 18:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: add /proc/<pid>/fail-nth
has been added to the -mm tree.  Its filename is
     fault-inject-add-proc-pid-fail-nth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-add-proc-pid-fail-nth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-add-proc-pid-fail-nth.patch

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
Subject: fault-inject: add /proc/<pid>/fail-nth

fail-nth interface is only created in /proc/self/task/<current-tid>/.
This change also adds it in /proc/<pid>/.

This makes shell based tool a bit simpler.

	$ bash -c "builtin echo 100 > /proc/self/fail-nth && exec ls /"

Link: http://lkml.kernel.org/r/1491490561-10485-6-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |    3 ++-
 fs/proc/base.c                                    |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-inject-add-proc-pid-fail-nth Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-inject-add-proc-pid-fail-nth
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -136,7 +136,8 @@ use the boot option:
 
 o proc entries
 
-- /proc/self/task/<current-tid>/fail-nth:
+- /proc/<pid>/fail-nth:
+- /proc/self/task/<tid>/fail-nth:
 
 	Write to this file of integer N makes N-th call in the task fail.
 	Read from this file returns a integer value. A value of '0' indicates
diff -puN fs/proc/base.c~fault-inject-add-proc-pid-fail-nth fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-add-proc-pid-fail-nth
+++ a/fs/proc/base.c
@@ -2955,6 +2955,7 @@ static const struct pid_entry tgid_base_
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
+	REG("fail-nth", 0644, proc_fail_nth_operations),
 #endif
 #ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
fault-inject-make-fail-nth-read-write-interface-symmetric.patch
fault-inject-simplify-access-check-for-fail-nth.patch
fault-inject-add-proc-pid-fail-nth.patch

