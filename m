From: akpm@linux-foundation.org
Subject: + kprobes-list-all-active-probes-in-the-system-fix.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:18:00 -0800
Message-ID: <200702130718.l1D7I07L024800@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57441 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXBMHSO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com


The patch titled
     kprobes-list-all-active-probes-in-the-system fix
has been added to the -mm tree.  Its filename is
     kprobes-list-all-active-probes-in-the-system-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kprobes-list-all-active-probes-in-the-system fix
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Fix kprobes compilation breakage on sparc64 caused due to
kprobes-list-all-active-probes-in-the-system.patch

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-fix
+++ a/kernel/kprobes.c
@@ -780,6 +780,12 @@ int __kprobes register_kretprobe(struct 
 	return -ENOSYS;
 }
 
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	return 0;
+}
+
 #endif /* ARCH_SUPPORTS_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-list-all-active-probes-in-the-system.patch
kprobes-list-all-active-probes-in-the-system-fix.patch
