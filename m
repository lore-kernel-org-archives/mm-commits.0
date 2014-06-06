From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysctl-allow-for-strict-write-position-handling-fix-3.patch removed from
 -mm tree
Date: Fri, 06 Jun 2014 14:07:19 -0700
Message-ID: <53922d87.V+rYEeKsywyCxebV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaFFVHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org

Subject: [folded-merged] sysctl-allow-for-strict-write-position-handling-fix-3.patch removed from -mm tree
To: keescook@chromium.org,akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:07:19 -0700


The patch titled
     Subject: sysctl: flip file position warning to pr_warn_once
has been removed from the -mm tree.  Its filename was
     sysctl-allow-for-strict-write-position-handling-fix-3.patch

This patch was dropped because it was folded into sysctl-allow-for-strict-write-position-handling.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: flip file position warning to pr_warn_once

To avoid dmesg flooding, use pr_warn_once instead of pr_warn.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-3 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-3
+++ a/kernel/sysctl.c
@@ -1783,10 +1783,10 @@ static int _proc_do_string(char *data, i
 
 static void warn_sysctl_write(struct ctl_table *table)
 {
-	pr_warn("write to %s by %s used a non-zero file position!\n",
-		table->procname, current->comm);
-	pr_warn("This will not be supported in the future.\n");
-	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
+	pr_warn_once("%s wrote to %s when file position was not 0!\n"
+		"This will not be supported in the future. To silence this\n"
+		"warning, set kernel.sysctl_writes_strict = -1\n",
+ 		current->comm, table->procname);
 }
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
sysctl-clean-up-char-buffer-arguments.patch
sysctl-refactor-sysctl-string-writing-logic.patch
sysctl-allow-for-strict-write-position-handling.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch

