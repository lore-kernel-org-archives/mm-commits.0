From: akpm@linux-foundation.org
Subject: - uml-remove-code-controlled-by-non-existent-config-option.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:13 -0800
Message-ID: <200702112249.l1BMnDhs015705@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbXBKWtP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: remove code controlled by non-existent config option
has been removed from the -mm tree.  Its filename was
     uml-remove-code-controlled-by-non-existent-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove code controlled by non-existent config option
From: Jeff Dike <jdike@addtoit.com>

CONFIG_HOST_TASK_SIZE doesn't exist any more.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/mem.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

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

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
