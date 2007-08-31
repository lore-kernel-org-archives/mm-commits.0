From: akpm@linux-foundation.org
Subject: - userns-dont-leak-root-user.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:21 -0700
Message-ID: <200708311656.l7VGuLWq017478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965391AbXHaROC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, clg@fr.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     userns: don't leak root user
has been removed from the -mm tree.  Its filename was
     userns-dont-leak-root-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: userns: don't leak root user
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/user_namespace.c~userns-dont-leak-root-user kernel/user_namespace.c
--- a/kernel/user_namespace.c~userns-dont-leak-root-user
+++ a/kernel/user_namespace.c
@@ -81,6 +81,7 @@ void free_user_ns(struct kref *kref)
 	struct user_namespace *ns;
 
 	ns = container_of(kref, struct user_namespace, kref);
+	free_uid(ns->root_user);
 	kfree(ns);
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
consolidate-ptrace_detach.patch
git-kbuild.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
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
single_open-seq_release-leak-diagnostics.patch
