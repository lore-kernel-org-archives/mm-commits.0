From: akpm@linux-foundation.org
Subject: [merged] kprobes-silence-debug_strict_user_copy_checks=y-warning.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:25 -0800
Message-ID: <20120113203126.26AF320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64132 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab2AMUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:28 -0500
Received: by eaad12 with SMTP id d12so25335eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, masami.hiramatsu.pt@hitachi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
has been removed from the -mm tree.  Its filename was
     kprobes-silence-debug_strict_user_copy_checks=y-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: kprobes: silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from kernel/kprobes.c:55:
In function 'copy_from_user',
    inlined from 'write_enabled_file_bool' at
    kernel/kprobes.c:2191:
arch/x86/include/asm/uaccess_64.h:65:
warning: call to 'copy_from_user_overflow' declared with
attribute warning: copy_from_user() buffer size is not provably
correct

presumably due to buf_size being signed causing GCC to fail to see that
buf_size can't become negative.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-silence-debug_strict_user_copy_checks=y-warning kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-silence-debug_strict_user_copy_checks=y-warning
+++ a/kernel/kprobes.c
@@ -2198,7 +2198,7 @@ static ssize_t write_enabled_file_bool(s
 	       const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
debugobjects-fix-selftest-for-static-warnings.patch
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch

