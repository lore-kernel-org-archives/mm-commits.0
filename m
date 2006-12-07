From: akpm@osdl.org
Subject: - uml-include-stddefh-correctly.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:07 -0800
Message-ID: <200612072300.kB7N07Gn029610@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163594AbWLGXAK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: include stddef.h correctly
has been removed from the -mm tree.  Its filename was
     uml-include-stddefh-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: include stddef.h correctly
From: Jeff Dike <jdike@addtoit.com>

We were not including stddef.h in files that used offsetof.

One file was also including linux/stddef.h for no perciptible reason.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/sys-i386/ldt.c          |    1 -
 arch/um/sys-i386/ptrace_user.c  |    2 +-
 arch/um/sys-i386/user-offsets.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/um/sys-i386/ldt.c~uml-include-stddefh-correctly arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-include-stddefh-correctly
+++ a/arch/um/sys-i386/ldt.c
@@ -3,7 +3,6 @@
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
 #include "linux/sched.h"
 #include "linux/slab.h"
 #include "linux/types.h"
diff -puN arch/um/sys-i386/ptrace_user.c~uml-include-stddefh-correctly arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-include-stddefh-correctly
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -4,9 +4,9 @@
  */
 
 #include <stdio.h>
+#include <stddef.h>
 #include <errno.h>
 #include <unistd.h>
-#include <linux/stddef.h>
 #include "ptrace_user.h"
 /* Grr, asm/user.h includes asm/ptrace.h, so has to follow ptrace_user.h */
 #include <asm/user.h>
diff -puN arch/um/sys-i386/user-offsets.c~uml-include-stddefh-correctly arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-include-stddefh-correctly
+++ a/arch/um/sys-i386/user-offsets.c
@@ -2,7 +2,7 @@
 #include <signal.h>
 #include <asm/ptrace.h>
 #include <asm/user.h>
-#include <linux/stddef.h>
+#include <stddef.h>
 #include <sys/poll.h>
 
 #define DEFINE(sym, val) \
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch
tty-switch-to-ktermios-uml-fix.patch

