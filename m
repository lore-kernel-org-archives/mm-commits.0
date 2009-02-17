From: akpm@linux-foundation.org
Subject: + kmemleak-fix-section-mismatch-in-kmemleakc.patch added to -mm tree
Date: Tue, 17 Feb 2009 15:52:52 -0800
Message-ID: <200902172352.n1HNqrXv030307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbZBQXxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 18:53:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, catalin.marinas@arm.com, mingo@elte.hu


The patch titled
     kmemleak: fix section mismatch in kmemleak.c
has been added to the -mm tree.  Its filename is
     kmemleak-fix-section-mismatch-in-kmemleakc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: fix section mismatch in kmemleak.c
From: Rakib Mullick <rakib.mullick@gmail.com>

The function kmemleak_alloc() is called from kernel allocators. 
kmemleak_alloc() calls log_early() but being log_early() marked as __init
it causes following section mismatches.  Being called from kernel
allocators, kmemleak_allock() will be called after freeing up the init
memory and log_early() will also called.  So, unmarking __init from
log_early() fixes the warning.  If anything else please notice.

  LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x4f371): Section mismatch in reference
from the function kmemleak_alloc() to the function
.init.text:log_early()
The function kmemleak_alloc() references
the function __init log_early().
This is often because kmemleak_alloc lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f470): Section mismatch in reference
from the function kmemleak_free() to the function
.init.text:log_early()
The function kmemleak_free() references
the function __init log_early().
This is often because kmemleak_free lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f56f): Section mismatch in reference
from the function kmemleak_not_leak() to the function
.init.text:log_early()
The function kmemleak_not_leak() references
the function __init log_early().
This is often because kmemleak_not_leak lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f66e): Section mismatch in reference
from the function kmemleak_ignore() to the function
.init.text:log_early()
The function kmemleak_ignore() references
the function __init log_early().
This is often because kmemleak_ignore lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f786): Section mismatch in reference
from the function kmemleak_scan_area() to the function
.init.text:log_early()
The function kmemleak_scan_area() references
the function __init log_early().
This is often because kmemleak_scan_area lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f885): Section mismatch in reference
from the function kmemleak_no_scan() to the function
.init.text:log_early()
The function kmemleak_no_scan() references
the function __init log_early().
This is often because kmemleak_no_scan lacks a __init
annotation or the annotation of log_early is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-fix-section-mismatch-in-kmemleakc mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-fix-section-mismatch-in-kmemleakc
+++ a/mm/kmemleak.c
@@ -230,8 +230,8 @@ struct early_log {
 };
 
 /* early logging buffer and current position */
-static struct early_log __initdata early_log[200];
-static int __initdata crt_early_log;
+static struct early_log early_log[200];
+static int crt_early_log;
 
 static void kmemleak_disable(void);
 
@@ -682,7 +682,7 @@ static void object_no_scan(unsigned long
  * Log an early kmemleak_* call to the early_log buffer. These calls will be
  * processed later once kmemleak is fully initialized.
  */
-static void __init log_early(int op_type, const void *ptr, size_t size,
+static void log_early(int op_type, const void *ptr, size_t size,
 			     int min_count,
 			     unsigned long offset, size_t length)
 {
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
kernel-auditscc-fix-warning.patch
kmemleak-fix-section-mismatch-in-kmemleakc.patch

