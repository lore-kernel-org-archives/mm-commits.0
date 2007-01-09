From: akpm@osdl.org
Subject: + uml-remove-code-controlled-by-non-existent-config-option.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:58:05 -0800
Message-ID: <200701092058.l09Kw5a3015088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXAIU6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: remove code controlled by non-existent config option
has been added to the -mm tree.  Its filename is
     uml-remove-code-controlled-by-non-existent-config-option.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove code controlled by non-existent config option
From: Jeff Dike <jdike@addtoit.com>

CONFIG_HOST_TASK_SIZE doesn't exist any more.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/kernel/skas/mem.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/um/kernel/skas/mem.c~uml-remove-code-controlled-by-non-existent-config-option arch/um/kernel/skas/mem.c
--- a/arch/um/kernel/skas/mem.c~uml-remove-code-controlled-by-non-existent-config-option
+++ a/arch/um/kernel/skas/mem.c
@@ -14,13 +14,9 @@ unsigned long set_task_sizes_skas(unsign
 	unsigned long host_task_size = ROUND_4M((unsigned long)
 						&host_task_size);
 
-#ifdef CONFIG_HOST_TASK_SIZE
-	*host_size_out = ROUND_4M(CONFIG_HOST_TASK_SIZE);
-	*task_size_out = CONFIG_HOST_TASK_SIZE;
-#else
 	if (!skas_needs_stub)
 		*task_size_out = host_task_size;
 	else *task_size_out = CONFIG_STUB_START & PGDIR_MASK;
-#endif
+
 	return host_task_size;
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
