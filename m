From: akpm@linux-foundation.org
Subject: - kprobes-list-all-active-probes-in-the-system-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 13:25:36 -0800
Message-ID: <200702202127.l1KLR1bY020178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXBTV1H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 16:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes-list-all-active-probes-in-the-system fix
has been removed from the -mm tree.  Its filename was
     kprobes-list-all-active-probes-in-the-system-fix.patch

This patch was dropped because it was folded into kprobes-list-all-active-probes-in-the-system.patch

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
