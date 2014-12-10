From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-add-panic_on_warn-v9.patch removed from
 -mm tree
Date: Wed, 10 Dec 2014 15:20:25 -0800
Message-ID: <5488d539.CefMPuNzPvvEDpY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbaLJXU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-panic_on_warn-v9
has been removed from the -mm tree.  Its filename was
     kernel-add-panic_on_warn-v9.patch

This patch was dropped because it was folded into kernel-add-panic_on_warn.patch

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
@@ -423,8 +422,7 @@ static void warn_slowpath_common(const c
 {
 	disable_trace_on_warning();
 
-	if (!panic_on_warn)
-		pr_warn("------------[ cut here ]------------\n");
+	pr_warn("------------[ cut here ]------------\n");
 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
@@ -433,8 +431,10 @@ static void warn_slowpath_common(const c
 
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

