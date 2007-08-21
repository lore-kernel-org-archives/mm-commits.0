From: akpm@linux-foundation.org
Subject: - make-oprofile-call-shutdown-only-once-per-session.patch removed from -mm tree
Date: Mon, 20 Aug 2007 22:29:21 -0700
Message-ID: <200708210529.l7L5TLlt008674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXHUF3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 01:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eranian@hpl.hp.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     make Oprofile call shutdown() only once per session
has been removed from the -mm tree.  Its filename was
     make-oprofile-call-shutdown-only-once-per-session.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
