From: akpm@linux-foundation.org
Subject: - tweak-proc-ipmi-removal.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:14 -0700
Message-ID: <200710180655.l9I6tEtU030591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619AbXJRHRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     Tweak /proc/ipmi removal
has been removed from the -mm tree.  Its filename was
     tweak-proc-ipmi-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Tweak /proc/ipmi removal
From: Alexey Dobriyan <adobriyan@sw.ru>

Driver does
	proc_mkdir("ipmi", NULL);
but
	remove_proc_entry(proc_ipmi_root->name, &proc_root);

This is OK and working if only slightly inconsistent.  Also changing
proc_root to NULL will help OpenVZ which has multiple proc roots and, as we
now know, requires matching parents in such cases.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~tweak-proc-ipmi-removal drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~tweak-proc-ipmi-removal
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -4136,7 +4136,7 @@ static __exit void cleanup_ipmi(void)
 	del_timer_sync(&ipmi_timer);
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry(proc_ipmi_root->name, &proc_root);
+	remove_proc_entry(proc_ipmi_root->name, NULL);
 #endif /* CONFIG_PROC_FS */
 
 	driver_unregister(&ipmidriver);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
add-kernel-notifierc-fix-2-fix-3.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch
