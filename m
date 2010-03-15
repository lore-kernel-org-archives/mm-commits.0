From: akpm@linux-foundation.org
Subject: [merged] documentation-remove-obsolete-voyagertxt-file.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:58 -0400
Message-ID: <201003150658.o2F6wV3S016456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935711Ab0COG6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: remove obsolete voyager.txt file
has been removed from the -mm tree.  Its filename was
     documentation-remove-obsolete-voyagertxt-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: remove obsolete voyager.txt file
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

x86/Voyager support has been removed a year ago.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Inspired-by: Jonathan Corbet <corbet@lwn.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/voyager.txt |   95 ------------------------------------
 1 file changed, 95 deletions(-)

diff -puN Documentation/voyager.txt~documentation-remove-obsolete-voyagertxt-file /dev/null
--- a/Documentation/voyager.txt
+++ /dev/null
@@ -1,95 +0,0 @@
-Running Linux on the Voyager Architecture
-=========================================
-
-For full details and current project status, see
-
-http://www.hansenpartnership.com/voyager
-
-The voyager architecture was designed by NCR in the mid 80s to be a
-fully SMP capable RAS computing architecture built around intel's 486
-chip set.  The voyager came in three levels of architectural
-sophistication: 3,4 and 5 --- 1 and 2 never made it out of prototype.
-The linux patches support only the Level 5 voyager architecture (any
-machine class 3435 and above).
-
-The Voyager Architecture
-------------------------
-
-Voyager machines consist of a Baseboard with a 386 diagnostic
-processor, a Power Supply Interface (PSI) a Primary and possibly
-Secondary Microchannel bus and between 2 and 20 voyager slots.  The
-voyager slots can be populated with memory and cpu cards (up to 4GB
-memory and from 1 486 to 32 Pentium Pro processors).  Internally, the
-voyager has a dual arbitrated system bus and a configuration and test
-bus (CAT).  The voyager bus speed is 40MHz.  Therefore (since all
-voyager cards are dual ported for each system bus) the maximum
-transfer rate is 320Mb/s but only if you have your slot configuration
-tuned (only memory cards can communicate with both busses at once, CPU
-cards utilise them one at a time).
-
-Voyager SMP
------------
-
-Since voyager was the first intel based SMP system, it is slightly
-more primitive than the Intel IO-APIC approach to SMP.  Voyager allows
-arbitrary interrupt routing (including processor affinity routing) of
-all 16 PC type interrupts.  However it does this by using a modified
-5259 master/slave chip set instead of an APIC bus.  Additionally,
-voyager supports Cross Processor Interrupts (CPI) equivalent to the
-APIC IPIs.  There are two routed voyager interrupt lines provided to
-each slot.
-
-Processor Cards
----------------
-
-These come in single, dyadic and quad configurations (the quads are
-problematic--see later).  The maximum configuration is 8 quad cards
-for 32 way SMP.
-
-Quad Processors
----------------
-
-Because voyager only supplies two interrupt lines to each Processor
-card, the Quad processors have to be configured (and Bootstrapped) in
-as a pair of Master/Slave processors.
-
-In fact, most Quad cards only accept one VIC interrupt line, so they
-have one interrupt handling processor (called the VIC extended
-processor) and three non-interrupt handling processors.
-
-Current Status
---------------
-
-The System will boot on Mono, Dyad and Quad cards.  There was
-originally a Quad boot problem which has been fixed by proper gdt
-alignment in the initial boot loader.  If you still cannot get your
-voyager system to boot, email me at:
-
-<J.E.J.Bottomley@HansenPartnership.com>
-
-
-The Quad cards now support using the separate Quad CPI vectors instead
-of going through the VIC mailbox system.
-
-The Level 4 architecture (3430 and 3360 Machines) should also work
-fine.
-
-Dump Switch
------------
-
-The voyager dump switch sends out a broadcast NMI which the voyager
-code intercepts and does a task dump.
-
-Power Switch
-------------
-
-The front panel power switch is intercepted by the kernel and should
-cause a system shutdown and power off.
-
-A Note About Mixed CPU Systems
-------------------------------
