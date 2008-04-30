From: akpm@linux-foundation.org
Subject: - sysctl-allow-embedded-targets-to-disable-sysctl_checkc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:38 -0700
Message-ID: <200804300547.m3U5lcpT029721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759496AbYD3GMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hs4233@mail.mn-solutions.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: allow embedded targets to disable sysctl_check.c
has been removed from the -mm tree.  Its filename was
     sysctl-allow-embedded-targets-to-disable-sysctl_checkc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: allow embedded targets to disable sysctl_check.c
From: Holger Schurig <hs4233@mail.mn-solutions.de>

Disable sysctl_check.c for embedded targets. This saves about about 11 kB
in .text and another 11 kB in .data on a PXA255 embedded platform.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |   11 +++++++++++
 kernel/Makefile |    2 +-
 kernel/sysctl.c |   10 ++++++++--
 3 files changed, 20 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~sysctl-allow-embedded-targets-to-disable-sysctl_checkc init/Kconfig
--- a/init/Kconfig~sysctl-allow-embedded-targets-to-disable-sysctl_checkc
+++ a/init/Kconfig
@@ -550,6 +550,17 @@ config SYSCTL_SYSCALL
 
 	  If unsure say Y here.
 
+config SYSCTL_SYSCALL_CHECK
+	bool "Sysctl checks" if EMBEDDED
+	depends on SYSCTL_SYSCALL
+	default y
+	---help---
+	  sys_sysctl uses binary paths that have been found challenging
+	  to properly maintain and use. This enables checks that help
+	  you to keep things correct.
+
+	  If unsure say Y here.
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
 	 default y
diff -puN kernel/Makefile~sysctl-allow-embedded-targets-to-disable-sysctl_checkc kernel/Makefile
--- a/kernel/Makefile~sysctl-allow-embedded-targets-to-disable-sysctl_checkc
+++ a/kernel/Makefile
@@ -11,7 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o
 
-obj-$(CONFIG_SYSCTL) += sysctl_check.o
+obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
diff -puN kernel/sysctl.c~sysctl-allow-embedded-targets-to-disable-sysctl_checkc kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-embedded-targets-to-disable-sysctl_checkc
+++ a/kernel/sysctl.c
@@ -1592,9 +1592,13 @@ static void sysctl_set_parent(struct ctl
 
 static __init int sysctl_init(void)
 {
-	int err;
 	sysctl_set_parent(NULL, root_table);
-	err = sysctl_check_table(current->nsproxy, root_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+	{
+		int err;
+		err = sysctl_check_table(current->nsproxy, root_table);
+	}
+#endif
 	return 0;
 }
 
@@ -1721,10 +1725,12 @@ struct ctl_table_header *__register_sysc
 	header->unregistering = NULL;
 	header->root = root;
 	sysctl_set_parent(NULL, header->ctl_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	if (sysctl_check_table(namespaces, header->ctl_table)) {
 		kfree(header);
 		return NULL;
 	}
+#endif
 	spin_lock(&sysctl_lock);
 	header_list = lookup_header_list(root, namespaces);
 	list_add_tail(&header->ctl_entry, header_list);
_

Patches currently in -mm which might be from hs4233@mail.mn-solutions.de are

origin.patch

