From: akpm@linux-foundation.org
Subject: - documentation-when-to-bug-and-when-to-not-bug.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:50 -0800
Message-ID: <200901072215.n07MFoYf015574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbZAGWQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, arjan@infradead.org, hverkuil@xs4all.nl, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: when to BUG(), and when to not BUG()
has been removed from the -mm tree.  Its filename was
     documentation-when-to-bug-and-when-to-not-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -28,6 +28,17 @@ struct bug_entry {
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
@@ -39,6 +50,12 @@ struct bug_entry {
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
 extern void warn_slowpath(const char *file, const int line,
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
rtc-ds1307-remove-legacy-probe-checks.patch

