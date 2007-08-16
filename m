From: akpm@linux-foundation.org
Subject: + ia64-include-kconfigpreempt.patch added to -mm tree
Date: Thu, 16 Aug 2007 12:29:23 -0700
Message-ID: <200708161929.l7GJTN26003163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbXHPTaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 15:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, avi@qumranet.com, mingo@elte.hu, tony.luck@intel.com


The patch titled
     ia64: include Kconfig.preempt
has been added to the -mm tree.  Its filename is
     ia64-include-kconfigpreempt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: include Kconfig.preempt
From: Satyam Sharma <satyam@infradead.org>

arch/ia64/Kconfig failed to include kernel/Kconfig.preempt that meant it
did not support PREEMPT_VOLUNTARY and PREEMPT_BKL (inadvertently).  This
was recently noticed when the newly-added PREEMPT_NOTIFIERS in
Kconfig.preempt that was "select"ed from drivers/kvm/Kconfig (therefore)
started giving bogus warnings ('select' used by config symbol 'KVM' refers
to undefined symbol 'PREEMPT_NOTIFIERS') on ia64 builds.

So let's remove the open-coded definition of CONFIG_PREEMPT in
arch/ia64/Kconfig and replace it with just including Kconfig.preempt
instead, like the other archs do.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |   12 +-----------
 1 files changed, 1 insertion(+), 11 deletions(-)

diff -puN arch/ia64/Kconfig~ia64-include-kconfigpreempt arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-include-kconfigpreempt
+++ a/arch/ia64/Kconfig
@@ -327,17 +327,7 @@ config FORCE_CPEI_RETARGET
 	This option it useful to enable this feature on older BIOS's as well.
 	You can also enable this by using boot command line option force_cpei=1.
 
-config PREEMPT
-	bool "Preemptible Kernel"
-        help
-          This option reduces the latency of the kernel when reacting to
-          real-time or interactive events by allowing a low priority process to
-          be preempted even if it is in kernel mode executing a system call.
-          This allows applications to run more reliably even when the system is
-          under load.
-
-          Say Y here if you are building a kernel for a desktop, embedded
-          or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 source "mm/Kconfig"
 
_

Patches currently in -mm which might be from satyam@infradead.org are

ia64-include-kconfigpreempt.patch
git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
