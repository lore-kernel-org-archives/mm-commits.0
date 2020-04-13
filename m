From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-drop-redundant-generic-y-=-hardirqh.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 13:11:12 -0700
Message-ID: <20200413201112.TO8aq_xnZ%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgDMULN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 16:11:13 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, gerg@linux-m68k.org, masahiroy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: drop redundant generic-y += hardirq.h
has been added to the -mm tree.  Its filename is
     m68k-drop-redundant-generic-y-=-hardirqh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-drop-redundant-generic-y-%3D-hardirqh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-drop-redundant-generic-y-%3D-hardirqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m68k: drop redundant generic-y += hardirq.h

The cleanup in commit 630f289b7114c0e6 ("asm-generic: make more
kernel-space headers mandatory") did not take into account the recently
added line for hardirq.h in commit acc45648b9aefa90 ("m68k: Switch to
asm-generic/hardirq.h"), leading to the following message during the
build:

    scripts/Makefile.asm-generic:25: redundant generic-y found in arch/m68k/include/asm/Kbuild: hardirq.h

Fix this by dropping the now redundant line.

Link: http://lkml.kernel.org/r/20200413093552.25102-1-geert@linux-m68k.org
Fixes: 630f289b7114c0e6 ("asm-generic: make more kernel-space headers mandatory")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/Kbuild |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/m68k/include/asm/Kbuild~m68k-drop-redundant-generic-y-=-hardirqh
+++ a/arch/m68k/include/asm/Kbuild
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 generated-y += syscall_table.h
 generic-y += extable.h
-generic-y += hardirq.h
 generic-y += kvm_para.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-drop-redundant-generic-y-=-hardirqh.patch
