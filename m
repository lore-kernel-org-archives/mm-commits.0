From: akpm@linux-foundation.org
Subject: + documentation-when-to-bug-and-when-to-not-bug.patch added to -mm tree
Date: Tue, 02 Dec 2008 15:42:50 -0800
Message-ID: <200812022342.mB2Ngob1015165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbYLBXnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 18:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, arjan@infradead.org, hverkuil@xs4all.nl, mingo@elte.hu, randy.dunlap@oracle.com


The patch titled
     documentation: when to BUG(), and when to not BUG()
has been added to the -mm tree.  Its filename is
     documentation-when-to-bug-and-when-to-not-bug.patch

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
Subject: documentation: when to BUG(), and when to not BUG()
From: David Brownell <dbrownell@users.sourceforge.net>

Provide some basic advice about when to use BUG()/BUG_ON(): never, unless
there's really no better option.

This matches my understanding of the standard policy ...  which seems not
to be written down so far, outside of LKML messages that I haven't
bookmarked.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN include/asm-generic/bug.h~documentation-when-to-bug-and-when-to-not-bug include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~documentation-when-to-bug-and-when-to-not-bug
+++ a/include/asm-generic/bug.h
@@ -20,6 +20,17 @@ struct bug_entry {
 #define BUGFLAG_WARNING	(1<<0)
 #endif	/* CONFIG_GENERIC_BUG */
 
+/*
+ * Don't use BUG() or BUG_ON() unless there's really no way out; one
+ * example might be detecting data structure corruption in the middle
+ * of an operation that can't be backed out of.  If the (sub)system
+ * can somehow continue operating, perhaps with reduced functionality,
+ * it's probably not BUG-worthy.
+ *
+ * If you're tempted to BUG(), think again:  is completely giving up
+ * really the *only* solution?  There are usually better options, where
+ * users don't need to reboot ASAP and can mostly shut down cleanly.
+ */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
@@ -31,6 +42,12 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
+/*
+ * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
+ * significant issues that need prompt attention if they should ever
+ * appear at runtime.  Use the versions with printk format strings
+ * to provide better diagnostics.
+ */
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch

