From: akpm@linux-foundation.org
Subject: + kernel-add-panic_on_warn-v7.patch added to -mm tree
Date: Tue, 04 Nov 2014 14:43:43 -0800
Message-ID: <5459569f.nvSZzh0ZkveJbisH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDWnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 17:43:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@linux.intel.com, corbet@lwn.net, fabf@skynet.be, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-panic_on_warn-v7
has been added to the -mm tree.  Its filename is
     kernel-add-panic_on_warn-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-panic_on_warn-v7.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-panic_on_warn-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: kernel-add-panic_on_warn-v7

swithch to core param, and remove change from v6

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/panic.c~kernel-add-panic_on_warn-v7 kernel/panic.c
--- a/kernel/panic.c~kernel-add-panic_on_warn-v7
+++ a/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/crash_dump.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -435,7 +436,7 @@ static void warn_slowpath_common(const c
 		 * from panicking the system.
 		 */
 		panic_on_warn = 0;
-		panic("panic_on_warn set ... \n");
+		panic("panic_on_warn set ...\n");
 	}
 
 	print_modules();
@@ -495,6 +496,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+core_param(panic_on_warn, panic_on_warn, int, 0644);
 
 static int __init setup_crash_kexec_post_notifiers(char *s)
 {
@@ -512,10 +514,3 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
