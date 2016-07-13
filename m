From: akpm@linux-foundation.org
Subject: + allow-kdump-with-crash_kexec_post_notifiers.patch added to -mm
 tree
Date: Wed, 13 Jul 2016 13:37:54 -0700
Message-ID: <5786a6a2.vfuyyQU+tbU2Ykb+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcGMUh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 16:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptesarik@suse.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, jgross@suse.com, josh@joshtriplett.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: allow kdump with crash_kexec_post_notifiers
has been added to the -mm tree.  Its filename is
     allow-kdump-with-crash_kexec_post_notifiers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/allow-kdump-with-crash_kexec_post_notifiers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/allow-kdump-with-crash_kexec_post_notifiers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: kexec: allow kdump with crash_kexec_post_notifiers

If a crash kernel is loaded, do not crash the running domain.  This is
needed if the kernel is loaded with crash_kexec_post_notifiers, because
panic notifiers are run before __crash_kexec() in that case, and this Xen
hook prevents its being called later.

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

 arch/x86/xen/enlighten.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers
+++ a/arch/x86/xen/enlighten.c
@@ -1325,7 +1325,8 @@ static void xen_crash_shutdown(struct pt
 static int
 xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
 {
-	xen_reboot(SHUTDOWN_crash);
+	if (!kexec_crash_loaded())
+		xen_reboot(SHUTDOWN_crash);
 	return NOTIFY_DONE;
 }
 
_

Patches currently in -mm which might be from ptesarik@suse.com are

add-a-kexec_crash_loaded-function.patch
allow-kdump-with-crash_kexec_post_notifiers.patch

