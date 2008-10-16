From: akpm@linux-foundation.org
Subject: + fix-documentation-of-sysrq-q.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:08:07 -0700
Message-ID: <200810161908.m9GJ87rs004626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103AbYJPTIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:08:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Fix documentation of sysrq-q
has been added to the -mm tree.  Its filename is
     fix-documentation-of-sysrq-q.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix documentation of sysrq-q
From: Andi Kleen <andi@firstfloor.org>

I fell into the trap recently that it only dumps hrtimers instead of
all timers. Fix the documentation.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    3 ++-
 drivers/char/sysrq.c    |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/sysrq.txt~fix-documentation-of-sysrq-q Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~fix-documentation-of-sysrq-q
+++ a/Documentation/sysrq.txt
@@ -95,7 +95,8 @@ On all -  write a character to /proc/sys
 
 'p'     - Will dump the current registers and flags to your console.
 
-'q'     - Will dump a list of all running timers.
+'q'     - Will dump a list of all running hrtimers.
+	  WARNING: Does not cover any other timers
 
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
diff -puN drivers/char/sysrq.c~fix-documentation-of-sysrq-q drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~fix-documentation-of-sysrq-q
+++ a/drivers/char/sysrq.c
@@ -168,7 +168,7 @@ static void sysrq_handle_show_timers(int
 static struct sysrq_key_op sysrq_show_timers_op = {
 	.handler	= sysrq_handle_show_timers,
 	.help_msg	= "show-all-timers(Q)",
-	.action_msg	= "Show Pending Timers",
+	.action_msg	= "Show pending hrtimers (no others)",
 };
 
 static void sysrq_handle_mountro(int key, struct tty_struct *tty)
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
make-taint-bit-reliable-v3.patch
taint-fix-kernel-doc.patch
submittingpatches-add-a-reference-to-andis-ols-paper.patch
add-kerneldoc-documentation-for-new-printk-format-extensions.patch
pnp-make-the-resource-type-an-unsigned-long.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
fix-documentation-of-sysrq-q.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
acpi-use-bcd2bin-bin2bcd.patch
profile-likely-unlikely-macros.patch

