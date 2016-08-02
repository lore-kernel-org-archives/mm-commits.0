From: akpm@linux-foundation.org
Subject: [patch 086/111] kexec: allow kdump with
 crash_kexec_post_notifiers
Date: Tue, 02 Aug 2016 14:06:19 -0700
Message-ID: <57a10b4b.t3vNWWurYcrncw1n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbcHBVXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ptesarik@suse.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, jgross@suse.com, josh@joshtriplett.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com

From: Petr Tesarik <ptesarik@suse.com>
Subject: kexec: allow kdump with crash_kexec_post_notifiers

If a crash kernel is loaded, do not crash the running domain.  This is
needed if the kernel is loaded with crash_kexec_post_notifiers, because
panic notifiers are run before __crash_kexec() in that case, and this Xen
hook prevents its being called later.

[akpm@linux-foundation.org: build fix: unconditionally include kexec.h]
Link: http://lkml.kernel.org/r/20160713122000.14969.99963.stgit@hananiah.suse.cz
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers
+++ a/arch/x86/xen/enlighten.c
@@ -34,9 +34,7 @@
 #include <linux/edd.h>
 #include <linux/frame.h>
 
-#ifdef CONFIG_KEXEC_CORE
 #include <linux/kexec.h>
-#endif
 
 #include <xen/xen.h>
 #include <xen/events.h>
@@ -1334,7 +1332,8 @@ static void xen_crash_shutdown(struct pt
 static int
 xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
 {
-	xen_reboot(SHUTDOWN_crash);
+	if (!kexec_crash_loaded())
+		xen_reboot(SHUTDOWN_crash);
 	return NOTIFY_DONE;
 }
 
_
