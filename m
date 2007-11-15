From: akpm@linux-foundation.org
Subject: + kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:28:42 -0800
Message-ID: <200711152228.lAFMSgPR019167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343AbXKOW2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com


The patch titled
     Kprobes: Build kretprobe samples only if arch supports kretprobes
has been added to the -mm tree.  Its filename is
     kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch
kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch
