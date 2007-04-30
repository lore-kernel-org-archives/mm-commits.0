From: akpm@linux-foundation.org
Subject: - kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:24:41 -0700
Message-ID: <200704302024.l3UKOft4014156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946776AbXD3UYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes-the-on-off-knob-thru-debugfs-updated s390 fix
has been removed from the -mm tree.  Its filename was
     kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch

This patch was dropped because it was folded into kprobes-the-on-off-knob-thru-debugfs-updated.patch

------------------------------------------------------
Subject: kprobes-the-on-off-knob-thru-debugfs-updated s390 fix
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Add the missing arch_trampoline_kprobe() for s390.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/kprobes.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix
+++ a/arch/s390/kernel/kprobes.c
@@ -662,3 +662,10 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
+		return 1;
+	return 0;
+}
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
