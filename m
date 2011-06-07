From: akpm@linux-foundation.org
Subject: + kprobes-silence-debug_strict_user_copy_checks=y-warning.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:43:47 -0700
Message-ID: <201106072343.p57Nhl5F002515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976Ab1FGXn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, masami.hiramatsu.pt@hitachi.com


The patch titled
     kprobes: silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
has been added to the -mm tree.  Its filename is
     kprobes-silence-debug_strict_user_copy_checks=y-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
From: Stephen Boyd <sboyd@codeaurora.org>

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
@@ -2185,7 +2185,7 @@ static ssize_t write_enabled_file_bool(s
 	       const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
lpfc-silence-debug_strict_user_copy_checks=y-warning.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch

