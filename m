From: akpm@linux-foundation.org
Subject: [patch 09/13] fault-inject: add /proc/<pid>/fail-nth
Date: Fri, 14 Jul 2017 14:50:00 -0700
Message-ID: <59693c88.n0n9+Mv8MtT/vMya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdGNVuB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com

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
@@ -2962,6 +2962,7 @@ static const struct pid_entry tgid_base_
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
+	REG("fail-nth", 0644, proc_fail_nth_operations),
 #endif
 #ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
_
