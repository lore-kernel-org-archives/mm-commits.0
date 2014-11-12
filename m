From: akpm@linux-foundation.org
Subject: + kernel-add-panic_on_warn-v9.patch added to -mm tree
Date: Wed, 12 Nov 2014 15:11:32 -0800
Message-ID: <5463e924.aUwQirA16KB5FqZ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaKLXLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 18:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-panic_on_warn-v9
has been added to the -mm tree.  Its filename is
     kernel-add-panic_on_warn-v9.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-panic_on_warn-v9.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-panic_on_warn-v9.patch

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
Subject: kernel-add-panic_on_warn-v9

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/panic.c~kernel-add-panic_on_warn-v9 kernel/panic.c
--- a/kernel/panic.c~kernel-add-panic_on_warn-v9
+++ a/kernel/panic.c
@@ -23,7 +23,6 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
-#include <linux/crash_dump.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -422,8 +421,7 @@ static void warn_slowpath_common(const c
 {
 	disable_trace_on_warning();
 
-	if (!panic_on_warn)
-		pr_warn("------------[ cut here ]------------\n");
+	pr_warn("------------[ cut here ]------------\n");
 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
@@ -432,8 +430,10 @@ static void warn_slowpath_common(const c
 
 	if (panic_on_warn) {
 		/*
-		 * A flood of WARN()s may occur.  Prevent further WARN()s
-		 * from panicking the system.
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
 		 */
 		panic_on_warn = 0;
 		panic("panic_on_warn set ...\n");
_

Patches currently in -mm which might be from prarit@redhat.com are

kernel-add-panic_on_warn.patch
kernel-add-panic_on_warn-v7.patch
kernel-add-panic_on_warn-v9.patch
linux-next.patch

