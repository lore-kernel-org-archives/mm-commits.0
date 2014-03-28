From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch added to -mm tree
Date: Fri, 28 Mar 2014 15:11:50 -0700
Message-ID: <5335f3a6.Z0C6cLnikxe8ew31%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaC1WLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yasutake.koichi@jp.panasonic.com, tony.luck@intel.com, tglx@linutronix.de, takata@linux-m32r.org, starvik@axis.com, schwidefsky@de.ibm.com, paulus@samba.org, monstr@monstr.eu, mingo@redhat.com, liqin.linux@gmail.com, linux@arm.linux.org.uk, lennox.wu@gmail.com, jesper.nilsson@axis.com, hpa@zytor.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, dhowells@redhat.com, benh@kernel.crashing.org, JBottomley@parallels.com, lauraa@codeaurora.org

Subject: + lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch added to -mm tree
To: lauraa@codeaurora.org,JBottomley@parallels.com,benh@kernel.crashing.org,dhowells@redhat.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,hpa@zytor.com,jesper.nilsson@axis.com,lennox.wu@gmail.com,linux@arm.linux.org.uk,liqin.linux@gmail.com,mingo@redhat.com,monstr@monstr.eu,paulus@samba.org,schwidefsky@de.ibm.com,starvik@axis.com,takata@linux-m32r.org,tglx@linutronix.de,tony.luck@intel.com,yasutake.koichi@jp.panasonic.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:11:50 -0700


The patch titled
     Subject: lib/scatterlist: clean up useless architecture versions of scatterlist.h
has been added to the -mm tree.  Its filename is
     lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: lib/scatterlist: clean up useless architecture versions of scatterlist.h

There's no need to have an architecture version of scatterlist.h if the
only thing the file does is include asm-generic/scatterlist.h.  Switch to
the asm-generic versions directly.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Chen Liqin <liqin.linux@gmail.com>,
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/Kbuild             |    1 +
 arch/alpha/include/asm/scatterlist.h      |    6 ------
 arch/cris/include/asm/Kbuild              |    1 +
 arch/cris/include/asm/scatterlist.h       |    6 ------
 arch/frv/include/asm/Kbuild               |    1 +
 arch/frv/include/asm/scatterlist.h        |    6 ------
 arch/m32r/include/asm/Kbuild              |    1 +
 arch/m32r/include/asm/scatterlist.h       |    6 ------
 arch/microblaze/include/asm/Kbuild        |    1 +
 arch/microblaze/include/asm/scatterlist.h |    1 -
 arch/mn10300/include/asm/Kbuild           |    1 +
 arch/mn10300/include/asm/scatterlist.h    |   16 ----------------
 arch/score/include/asm/Kbuild             |    2 +-
 arch/score/include/asm/scatterlist.h      |    6 ------
 14 files changed, 7 insertions(+), 48 deletions(-)

diff -puN arch/alpha/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/alpha/include/asm/Kbuild
--- a/arch/alpha/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/alpha/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff -puN arch/alpha/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/alpha/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ALPHA_SCATTERLIST_H
-#define _ALPHA_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(_ALPHA_SCATTERLIST_H) */
diff -puN arch/cris/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/cris/include/asm/Kbuild
@@ -14,3 +14,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += scatterlist.h
diff -puN arch/cris/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/cris/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_CRIS_SCATTERLIST_H
-#define __ASM_CRIS_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(__ASM_CRIS_SCATTERLIST_H) */
diff -puN arch/frv/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/frv/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff -puN arch/frv/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/frv/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !_ASM_SCATTERLIST_H */
diff -puN arch/m32r/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/m32r/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
diff -puN arch/m32r/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/m32r/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_SCATTERLIST_H
-#define _ASM_M32R_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_M32R_SCATTERLIST_H */
diff -puN arch/microblaze/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/microblaze/include/asm/Kbuild
--- a/arch/microblaze/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/microblaze/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += trace_clock.h
+generic-y += scatterlist.h
 generic-y += syscalls.h
 generic-y += preempt.h
diff -puN arch/microblaze/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/microblaze/include/asm/scatterlist.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/scatterlist.h>
diff -puN arch/mn10300/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/mn10300/include/asm/Kbuild
--- a/arch/mn10300/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/mn10300/include/asm/Kbuild
@@ -3,5 +3,6 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
diff -puN arch/mn10300/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/mn10300/include/asm/scatterlist.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* MN10300 Scatterlist definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_SCATTERLIST_H */
diff -puN arch/score/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth
+++ a/arch/score/include/asm/Kbuild
@@ -7,4 +7,4 @@ generic-y += hash.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
-
+generic-y += scatterlist.h
diff -puN arch/score/include/asm/scatterlist.h~lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth /dev/null
--- a/arch/score/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SCATTERLIST_H
-#define _ASM_SCORE_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
