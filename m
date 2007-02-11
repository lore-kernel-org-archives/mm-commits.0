From: akpm@linux-foundation.org
Subject: - uml-locking-comments-in-startup-code.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:21 -0800
Message-ID: <200702112249.l1BMnLZw015731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59847 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXBKWtX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: locking comments in startup code
has been removed from the -mm tree.  Its filename was
     uml-locking-comments-in-startup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: locking comments in startup code
From: Jeff Dike <jdike@addtoit.com>

Add a couple of comments about some non-locked data.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/os-Linux/start_up.c~uml-locking-comments-in-startup-code arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-locking-comments-in-startup-code
+++ a/arch/um/os-Linux/start_up.c
@@ -133,6 +133,7 @@ static int stop_ptraced_child(int pid, v
 	return ret;
 }
 
+/* Changed only during early boot */
 int ptrace_faultinfo = 1;
 int ptrace_ldt = 1;
 int proc_mm = 1;
@@ -160,6 +161,7 @@ __uml_setup("mode=skas0", mode_skas0_cmd
 		"    specify mode=tt. Note that this was recently added - on \n"
 		"    older kernels you must use simply \"skas0\".\n\n");
 
+/* Changed only during early boot */
 static int force_sysemu_disabled = 0;
 
 static int __init nosysemu_cmd_param(char *str, int* add)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
