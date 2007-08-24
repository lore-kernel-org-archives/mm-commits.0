From: akpm@linux-foundation.org
Subject: + paravirt-fix-preemptible-lazy-mode-bug.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:24:17 -0700
Message-ID: <200708242224.l7OMOHEU017812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760012AbXHXWY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au


The patch titled
     paravirt: fix preemptible lazy mode bug
has been added to the -mm tree.  Its filename is
     paravirt-fix-preemptible-lazy-mode-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt: fix preemptible lazy mode bug
From: Zachary Amsden <zach@vmware.com>

Since set_lazy_mode(LAZY_MODE_FLUSH) is now called from the page fault
handler, it can potentially happen in a preemptible state.  We therefore
must make all lazy mode paravirt-ops handlers non-preemptible.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c    |   14 ++++++++++----
 arch/i386/xen/enlighten.c |    4 +++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/vmi.c~paravirt-fix-preemptible-lazy-mode-bug arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt-fix-preemptible-lazy-mode-bug
+++ a/arch/i386/kernel/vmi.c
@@ -555,21 +555,27 @@ vmi_startup_ipi_hook(int phys_apicid, un
 static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
 	static DEFINE_PER_CPU(enum paravirt_lazy_mode, lazy_mode);
+	int cpu;
+	enum paravirt_lazy_mode cur_mode;
 
 	if (!vmi_ops.set_lazy_mode)
 		return;
 
+	cpu = get_cpu();
+	cur_mode = per_cpu(lazy_mode, cpu);
+
 	/* Modes should never nest or overlap */
-	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
-					     mode == PARAVIRT_LAZY_FLUSH));
+	BUG_ON(cur_mode && !(mode == PARAVIRT_LAZY_NONE ||
+			     mode == PARAVIRT_LAZY_FLUSH));
 
 	if (mode == PARAVIRT_LAZY_FLUSH) {
 		vmi_ops.set_lazy_mode(0);
-		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
+		vmi_ops.set_lazy_mode(cur_mode);
 	} else {
 		vmi_ops.set_lazy_mode(mode);
-		__get_cpu_var(lazy_mode) = mode;
+		per_cpu(lazy_mode, cpu) = mode;
 	}
+	put_cpu();
 }
 
 static inline int __init check_vmi_rom(struct vrom_header *rom)
diff -puN arch/i386/xen/enlighten.c~paravirt-fix-preemptible-lazy-mode-bug arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c~paravirt-fix-preemptible-lazy-mode-bug
+++ a/arch/i386/xen/enlighten.c
@@ -250,7 +250,7 @@ static void xen_halt(void)
 
 static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(preemptible());
+	get_cpu();
 
 	switch (mode) {
 	case PARAVIRT_LAZY_NONE:
@@ -266,11 +266,13 @@ static void xen_set_lazy_mode(enum parav
 		/* flush if necessary, but don't change state */
 		if (x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE)
 			xen_mc_flush();
+		put_cpu();
 		return;
 	}
 
 	xen_mc_flush();
 	x86_write_percpu(xen_lazy_mode, mode);
+	put_cpu();
 }
 
 static unsigned long xen_store_tr(void)
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
paravirt-fix-preemptible-lazy-mode-bug.patch
