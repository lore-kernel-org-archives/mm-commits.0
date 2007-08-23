From: akpm@linux-foundation.org
Subject: + move-preempt_notifiers-into-an-always-included-kconfig.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:53:21 -0700
Message-ID: <200708232353.l7NNrLLp000874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762981AbXHWXyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, geert@linux-m68k.org, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Move PREEMPT_NOTIFIERS into an always-included Kconfig
has been added to the -mm tree.  Its filename is
     move-preempt_notifiers-into-an-always-included-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move PREEMPT_NOTIFIERS into an always-included Kconfig
From: Avi Kivity <avi@qumranet.com>

Kconfig.preempt is not included on some archs (for example, m68k).  On those
archs, the Kconfig machinery complains that KVM selects an undefined symbol
PREEMPT_NOTIFIERS (which lives in Kconfig.preempt).

So move the offending symbol into a Kconfig file which is included by
everyone.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig           |    3 +++
 kernel/Kconfig.preempt |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~move-preempt_notifiers-into-an-always-included-kconfig init/Kconfig
--- a/init/Kconfig~move-preempt_notifiers-into-an-always-included-kconfig
+++ a/init/Kconfig
@@ -685,3 +685,6 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 
 source "block/Kconfig"
+
+config PREEMPT_NOTIFIERS
+	bool
diff -puN kernel/Kconfig.preempt~move-preempt_notifiers-into-an-always-included-kconfig kernel/Kconfig.preempt
--- a/kernel/Kconfig.preempt~move-preempt_notifiers-into-an-always-included-kconfig
+++ a/kernel/Kconfig.preempt
@@ -63,6 +63,3 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
-config PREEMPT_NOTIFIERS
-	bool
-
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
git-kvm.patch
time-simplify-smp_call_function_single-call-sequence.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
