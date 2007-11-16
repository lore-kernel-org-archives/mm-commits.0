From: akpm@linux-foundation.org
Subject: - kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch removed from -mm tree
Date: Thu, 15 Nov 2007 18:16:46 -0800
Message-ID: <200711160216.lAG2GkrT027473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXKPCRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 21:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: Build kretprobe samples only if arch supports kretprobes
has been removed from the -mm tree.  Its filename was
     kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch

This patch was dropped because Mathieu destroyed it

------------------------------------------------------
Subject: Kprobes: Build kretprobe samples only if arch supports kretprobes
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch builds samples/kprobes/kretprobe_example.c only on archs that
support kretprobes.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/Makefile |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN samples/kprobes/Makefile~kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes samples/kprobes/Makefile
--- a/samples/kprobes/Makefile~kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes
+++ a/samples/kprobes/Makefile
@@ -1,5 +1,8 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
-		kretprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+
+ifeq ($(CONFIG_ARCH_SUPPORTS_KRETPROBES),y)
+obj-$(CONFIG_SAMPLE_KPROBES) += kretprobe_example.o
+endif
_

Patches currently in -mm which might be from ananth@in.ibm.com are

move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch
