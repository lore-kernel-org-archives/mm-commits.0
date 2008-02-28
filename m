From: akpm@linux-foundation.org
Subject: + kconfig-cleanup-block-kconfigiosched-help-descriptions.patch added to -mm tree
Date: Wed, 27 Feb 2008 22:32:43 -0800
Message-ID: <200802280632.m1S6WhEP019592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbYB1GdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 01:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick@nick-andrew.net, jens.axboe@oracle.com


The patch titled
     Kconfig: cleanup block/Kconfig.iosched help descriptions
has been added to the -mm tree.  Its filename is
     kconfig-cleanup-block-kconfigiosched-help-descriptions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kconfig: cleanup block/Kconfig.iosched help descriptions
From: Nick Andrew <nick@nick-andrew.net>

Modify the help descriptions of block/Kconfig.iosched for clarity, accuracy
and consistency.

More information is added to each of the I/O scheduler choices and they are
also reordered to improve the flow of information to the user.

IOSCHED_CFQ is the default because it distributes the bandwidth fairly.  It's
also the place I decided to add the most help text, because it seems not
possible to add help text to the menu "IO Schedulers" itself.

So IOSCHED_CFQ is annotated with two things.  Firstly a hint about how to use
the prioritisation at runtime, i.e.  through the ionice(1) command.  Secondly,
a reference to Documentation/block/switching-sched.txt to show how to switch
the scheduler for block devices at runtime, and/or choose a new scheduler via
the 'elevator=' kernel parameter.

These schedulers can be compiled as modules (except for noop-iosched) so this
is mentioned in each case.  However the Kconfig won't allow a scheduler which
is built as a module to be chosen as the default scheduler, and I noted that.

The boilerplate "If unsure, say Y" was added to IOSCHED_CFQ, IOSCHED_AS
and IOSCHED_DEADLINE.

A 1-line help description was added to each of the 4 choices under "Default
I/O scheduler".  It won't explain anything, but it's friendlier than saying
nothing at all.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig.iosched |   74 +++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 16 deletions(-)

diff -puN block/Kconfig.iosched~kconfig-cleanup-block-kconfigiosched-help-descriptions block/Kconfig.iosched
--- a/block/Kconfig.iosched~kconfig-cleanup-block-kconfigiosched-help-descriptions
+++ a/block/Kconfig.iosched
@@ -2,15 +2,28 @@ if BLOCK
 
 menu "IO Schedulers"
 
-config IOSCHED_NOOP
-	bool
+config IOSCHED_CFQ
+	tristate "CFQ I/O scheduler"
 	default y
 	---help---
-	  The no-op I/O scheduler is a minimal scheduler that does basic merging
-	  and sorting. Its main uses include non-disk based block devices like
-	  memory devices, and specialised software or hardware environments
-	  that do their own scheduling and require only minimal assistance from
-	  the kernel.
+	  The CFQ I/O scheduler tries to distribute bandwidth equally
+	  among all processes in the system. It should provide a fair
+	  working environment, suitable for desktop systems.
+
+	  This is the default I/O scheduler.
+
+	  The CFQ I/O scheduler supports prioritisation for individual
+	  processes; see ionice(1) for details.
+
+	  See <file:Documentation/block/switching-sched.txt> for details
+	  on how to choose a default I/O scheduler at boot time and also
+	  on a per-device basis at run time.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called cfq-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
 
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
@@ -21,6 +34,15 @@ config IOSCHED_AS
 	  deadline I/O scheduler, it can also be slower in some cases
 	  especially some database loads.
 
+	  See <file:Documentation/block/as-iosched.txt> for detailed
+	  information on this scheduler.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called as-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
+
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
 	default y
@@ -31,14 +53,26 @@ config IOSCHED_DEADLINE
 	  a disk at any one time, its behaviour is almost identical to the
 	  anticipatory I/O scheduler and so is a good choice.
 
-config IOSCHED_CFQ
-	tristate "CFQ I/O scheduler"
+	  See <file:Documentation/block/deadline-iosched.txt> for detailed
+	  information on this scheduler.
+
+	  To compile this scheduler as a module, choose M here; the module
+	  will be called deadline-iosched. A scheduler built as a module cannot
+	  be chosen as default.
+
+	  If unsure, say Y.
+
+config IOSCHED_NOOP
+	bool
 	default y
 	---help---
-	  The CFQ I/O scheduler tries to distribute bandwidth equally
-	  among all processes in the system. It should provide a fair
-	  working environment, suitable for desktop systems.
-	  This is the default I/O scheduler.
+	  The no-op I/O scheduler is a minimal scheduler that does basic merging
+	  and sorting. Its main uses include non-disk based block devices like
+	  memory devices, and specialised software or hardware environments
+	  that do their own scheduling and require only minimal assistance from
+	  the kernel.
+
+	  If unsure, say Y.
 
 choice
 	prompt "Default I/O scheduler"
@@ -47,17 +81,25 @@ choice
 	  Select the I/O scheduler which will be used by default for all
 	  block devices.
 
+	config DEFAULT_CFQ
+		bool "CFQ" if IOSCHED_CFQ=y
+		help
+		  Choose the CFQ I/O scheduler as default.
+
 	config DEFAULT_AS
 		bool "Anticipatory" if IOSCHED_AS=y
+		help
+		  Choose the Anticipatory I/O scheduler as default.
 
 	config DEFAULT_DEADLINE
 		bool "Deadline" if IOSCHED_DEADLINE=y
-
-	config DEFAULT_CFQ
-		bool "CFQ" if IOSCHED_CFQ=y
+		help
+		  Choose the Deadline I/O scheduler as default.
 
 	config DEFAULT_NOOP
 		bool "No-op"
+		help
+		  Choose the No-op I/O scheduler as default.
 
 endchoice
 
_

Patches currently in -mm which might be from nick@nick-andrew.net are

documentation-i386-io-apictxt-fix-description.patch
kconfig-cleanup-block-kconfig-help-descriptions.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
