From: akpm@linux-foundation.org
Subject: + add-weak-for-creating-weak-asm-labels.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:35:52 -0700
Message-ID: <200710172135.l9HLZq4V009474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbXJQVf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, hpa@zytor.com, jeremy@xensource.com


The patch titled
     add WEAK() for creating weak asm labels
has been added to the -mm tree.  Its filename is
     add-weak-for-creating-weak-asm-labels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add WEAK() for creating weak asm labels
From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/linkage.h~add-weak-for-creating-weak-asm-labels include/linux/linkage.h
--- a/include/linux/linkage.h~add-weak-for-creating-weak-asm-labels
+++ a/include/linux/linkage.h
@@ -34,6 +34,12 @@
   name:
 #endif
 
+#ifndef WEAK
+#define WEAK(name)	   \
+	.weak name;	   \
+	name:
+#endif
+
 #define KPROBE_ENTRY(name) \
   .pushsection .kprobes.text, "ax"; \
   ENTRY(name)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
remove-unsafe-from-module-struct.patch
delay-creation-of-khcvd-thread.patch
hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
module-return-error-when-mod_sysfs_init-failed.patch
git-kvm.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
make-asm-x86-bootparamh-includable-from-userspace.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
