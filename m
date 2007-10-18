From: akpm@linux-foundation.org
Subject: - sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:49:17 -0700
Message-ID: <200710180849.l9I8nHb7002887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbXJRItT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: update sysctl_check to handle compiled out code.
has been removed from the -mm tree.  Its filename was
     sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch

This patch was dropped because it was folded into sysctl-update-sysctl_check_table.patch

------------------------------------------------------
Subject: sysctl: update sysctl_check to handle compiled out code.
From: ebiederm@xmission.com (Eric W. Biederman)

Currently sysctl_check_table will complain if a strategy routine
is missing when we have sys_sysctl compiled out, or a proc_handler
is missing when we have procfs compiled out.  At least some
of the custom handlers actually expand to NULL when this is the
case so the warning is actually a problem.

Valdis.Kletnieks@vt.edu writes:
> As far as "something else wrong", I'm still seeing these in -rc3-mm1
>
> [    0.628000] sysctl table check failed: /kernel/ostype .1.1 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/osrelease .1.2 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/version .1.4 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/hostname .1.7 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/domainname .1.8 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmax .1.34 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmall .1.41 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmni .1.45 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmax .1.35 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmni .1.42 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmnb .1.36 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/sem .1.43 Missing strategy

So don't worry about missing strategy routines, or missing proc_handler
routines when they will never be called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN kernel/sysctl_check.c~sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code
+++ a/kernel/sysctl_check.c
@@ -1534,14 +1534,18 @@ int sysctl_check_table(struct ctl_table 
 						set_fail(&fail, table, "No max");
 				}
 			}
+#ifdef CONFIG_SYSCTL_SYSCALL
 			if (table->ctl_name && !table->strategy)
 				set_fail(&fail, table, "Missing strategy");
+#endif
 #if 0
 			if (!table->ctl_name && table->strategy)
 				set_fail(&fail, table, "Strategy without ctl_name");
 #endif
+#ifdef CONFIG_PROC_FS
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
+#endif
 #if 0
 			if (!table->procname && table->proc_handler)
 				set_fail(&fail, table, "proc_handler without procname");
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
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
sysctl-parport-remove-binary-paths.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
