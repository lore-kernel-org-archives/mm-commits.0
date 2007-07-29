From: akpm@linux-foundation.org
Subject: + make-oprofile-call-shutdown-only-once-per-session.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:47:12 -0700
Message-ID: <200707290647.l6T6lCek012313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759635AbXG2Grj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eranian@hpl.hp.com, ak@suse.de


The patch titled
     make Oprofile call shutdown() only once per session
has been added to the -mm tree.  Its filename is
     make-oprofile-call-shutdown-only-once-per-session.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make Oprofile call shutdown() only once per session
From: Stephane Eranian <eranian@hpl.hp.com>

Oprofile: call model->shutdown() only once to avoid calling release_ev*()
multiple times

Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/oprofile/nmi_int.c~make-oprofile-call-shutdown-only-once-per-session arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~make-oprofile-call-shutdown-only-once-per-session
+++ a/arch/i386/oprofile/nmi_int.c
@@ -269,7 +269,6 @@ static void nmi_cpu_shutdown(void * dumm
 	apic_write(APIC_LVTPC, saved_lvtpc[cpu]);
 	apic_write(APIC_LVTERR, v);
 	nmi_restore_registers(msrs);
-	model->shutdown(msrs);
 }
 
  
@@ -278,6 +277,7 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	model->shutdown(cpu_msrs);
 	free_msrs();
 }
 
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

make-oprofile-call-shutdown-only-once-per-session.patch
remove-unused-tif_notify_resume-flag.patch
