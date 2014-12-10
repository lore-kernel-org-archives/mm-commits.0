From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-add-panic_on_warn-v7.patch removed from
 -mm tree
Date: Wed, 10 Dec 2014 15:20:23 -0800
Message-ID: <5488d537.BlvMtinTX2eWfcyk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbaLJXUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@linux.intel.com, corbet@lwn.net, fabf@skynet.be, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-panic_on_warn-v7
has been removed from the -mm tree.  Its filename was
     kernel-add-panic_on_warn-v7.patch

This patch was dropped because it was folded into kernel-add-panic_on_warn.patch

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
@@ -436,7 +437,7 @@ static void warn_slowpath_common(const c
 		 * from panicking the system.
 		 */
 		panic_on_warn = 0;
-		panic("panic_on_warn set ... \n");
+		panic("panic_on_warn set ...\n");
 	}
 
 	print_modules();
@@ -496,6 +497,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+core_param(panic_on_warn, panic_on_warn, int, 0644);
 
 static int __init setup_crash_kexec_post_notifiers(char *s)
 {
@@ -513,10 +515,3 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
