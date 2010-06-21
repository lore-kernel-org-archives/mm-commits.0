From: akpm@linux-foundation.org
Subject: + taint-add-taint_hardware_unsupported-flag.patch added to -mm tree
Date: Mon, 21 Jun 2010 12:21:53 -0700
Message-ID: <201006211921.o5LJLrnL032272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab0FUTWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 15:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, dzickus@redhat.com, randy.dunlap@oracle.com


The patch titled
     taint: add TAINT_HARDWARE_UNSUPPORTED flag
has been added to the -mm tree.  Its filename is
     taint-add-taint_hardware_unsupported-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taint: add TAINT_HARDWARE_UNSUPPORTED flag
From: Prarit Bhargava <prarit@redhat.com>

Individual distributions may enable "generic" features such as X86
support, PPC support, and driver support.

Some of the features that are enabled by these "generic" feature flags may
not be considered supported by the individual distribution.

For example, a distribution may want to support PPC but not the Power5
chipset, or the e1000e driver but not a card with a specific DeviceID
because of known firmware issues.

Typically, one would push a config patch to enable and disable the feature
and patch the distribution.  However, in some cases this is not feasible
in order to preserve kabi and at the same time maintain parity with the
upstream kernel.  In some cases the distribution may want to allow booting
of these features but explicitly notify a user that they are not
"officially" supported.  It is also possible that the hardware is fixed
via a firmware update at a later date, making it supported again.

It would be useful for a distribution to notify the installer and bug
reporting applications, and notify users that the hardware they are using
is unsupported during panic, oops, BUG(), and WARN().

This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for
distributions to use.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    2 ++
 include/linux/kernel.h         |    1 +
 kernel/panic.c                 |    5 +++++
 3 files changed, 8 insertions(+)

diff -puN Documentation/oops-tracing.txt~taint-add-taint_hardware_unsupported-flag Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~taint-add-taint_hardware_unsupported-flag
+++ a/Documentation/oops-tracing.txt
@@ -263,6 +263,8 @@ characters, each representing a particul
  12: 'I' if the kernel is working around a severe bug in the platform
      firmware (BIOS or similar).
 
+ 13: 'H' if the hardware is unsupported by the distribution
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff -puN include/linux/kernel.h~taint-add-taint_hardware_unsupported-flag include/linux/kernel.h
--- a/include/linux/kernel.h~taint-add-taint_hardware_unsupported-flag
+++ a/include/linux/kernel.h
@@ -354,6 +354,7 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_HARDWARE_UNSUPPORTED	12
 
 extern void dump_stack(void) __cold;
 
diff -puN kernel/panic.c~taint-add-taint_hardware_unsupported-flag kernel/panic.c
--- a/kernel/panic.c~taint-add-taint_hardware_unsupported-flag
+++ a/kernel/panic.c
@@ -180,6 +180,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
+	{ TAINT_HARDWARE_UNSUPPORTED,	'H', ' ' },
 };
 
 /**
@@ -197,6 +198,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
+ *  'H' - Hardware is unsupported.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
@@ -243,6 +245,9 @@ void add_taint(unsigned flag)
 	 */
 	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	if (flag == TAINT_HARDWARE_UNSUPPORTED)
+		printk(KERN_CRIT
+		       "WARNING: This system's hardware is unsupported.\n");
 
 	set_bit(flag, &tainted_mask);
 }
_

Patches currently in -mm which might be from prarit@redhat.com are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
hpilo-fix-pointer-warning-in-ilo_ccb_setup.patch
taint-add-taint_hardware_unsupported-flag.patch
lib-decompress_bunzip2c-fix-checkstack-warning.patch

