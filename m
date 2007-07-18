From: akpm@linux-foundation.org
Subject: + add-sys-kernel-notes-fix.patch added to -mm tree
Date: Tue, 17 Jul 2007 23:57:56 -0700
Message-ID: <200707180702.l6I72M9n029454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbXGRHDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 03:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, paulus@samba.org, roland@redhat.com, rth@twiddle.net, schwidefsky@de.ibm.com


The patch titled
     add-sys-kernel-notes-fix
has been added to the -mm tree.  Its filename is
     add-sys-kernel-notes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-sys-kernel-notes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~add-sys-kernel-notes-fix kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-sys-kernel-notes-fix
+++ a/kernel/ksysfs.c
@@ -69,7 +69,7 @@ extern const char __start_notes __attrib
 extern const char __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
-static ssize_t notes_read(struct kobject *kobj,
+static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
 	memcpy(buf, &__start_notes + off, count);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
