From: akpm@linux-foundation.org
Subject: + sysctl-allow-for-strict-write-position-handling-fix-3.patch
 added to -mm tree
Date: Wed, 07 May 2014 12:23:29 -0700
Message-ID: <536a8831.UlROUXX8PlulEGZ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEGTXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org

Subject: + sysctl-allow-for-strict-write-position-handling-fix-3.patch added to -mm tree
To: keescook@chromium.org,akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:23:29 -0700


The patch titled
     Subject: sysctl: flip file position warning to pr_warn_once
has been added to the -mm tree.  Its filename is
     sysctl-allow-for-strict-write-position-handling-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-allow-for-strict-write-position-handling-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-allow-for-strict-write-position-handling-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: flip file position warning to pr_warn_once

To avoid dmesg flooding, use pr_warn_once instead of pr_warn.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-3 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-3
+++ a/kernel/sysctl.c
@@ -1783,10 +1783,9 @@ static int _proc_do_string(char *data, i
 
 static void warn_sysctl_write(struct ctl_table *table)
 {
-	pr_warn("write to %s by %s used a non-zero file position!\n",
-		table->procname, current->comm);
-	pr_warn("This will not be supported in the future.\n");
-	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
+	pr_warn_once("%s wrote to %s when file position was not 0!\n"
+		"This will not be supported in the future. To silence this\n"
+		"warning, set kernel.sysctl_writes_strict = -1\n",
 }
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
sysctl-clean-up-char-buffer-arguments.patch
sysctl-refactor-sysctl-string-writing-logic.patch
sysctl-allow-for-strict-write-position-handling.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
linux-next.patch

