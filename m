From: akpm@linux-foundation.org
Subject: - introduce-have_efficient_unaligned_access-kconfig-symbol.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:26 -0700
Message-ID: <200807252254.m6PMsQKM002818__40963.0137299702$1217026613$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbYGYWzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, linux-arch@vger.kernel.org, mingo@elte.hu, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig symbol
has been removed from the -mm tree.  Its filename was
     introduce-have_efficient_unaligned_access-kconfig-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>

In many cases, especially in networking, it can be beneficial to know at
compile time whether the architecture can do unaligned accesses efficiently. 
This patch introduces a new Kconfig symbol

	HAVE_EFFICIENT_UNALIGNED_ACCESS

for that purpose and adds it to the powerpc and x86 architectures.  Also add
some documentation about alignment and networking, and especially one intended
use of this symbol.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu> [x86 architecture part]
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/unaligned-memory-access.txt |   32 ++++++++++++++++++--
 arch/Kconfig                              |   19 +++++++++++
 arch/powerpc/Kconfig                      |    1 
 arch/x86/Kconfig                          |    1 
 4 files changed, 50 insertions(+), 3 deletions(-)

diff -puN Documentation/unaligned-memory-access.txt~introduce-have_efficient_unaligned_access-kconfig-symbol Documentation/unaligned-memory-access.txt
--- a/Documentation/unaligned-memory-access.txt~introduce-have_efficient_unaligned_access-kconfig-symbol
+++ a/Documentation/unaligned-memory-access.txt
@@ -218,9 +218,35 @@ If use of such macros is not convenient,
 where the source or destination (or both) are of type u8* or unsigned char*.
 Due to the byte-wise nature of this operation, unaligned accesses are avoided.
 
+
+Alignment vs. Networking
+========================
+
+On architectures that require aligned loads, networking requires that the IP
+header is aligned on a four-byte boundary to optimise the IP stack. For
+regular ethernet hardware, the constant NET_IP_ALIGN is used. On most
+architectures this constant has the value 2 because the normal ethernet
+header is 14 bytes long, so in order to get proper alignment one needs to
+DMA to an address which can be expressed as 4*n + 2. One notable exception
+here is powerpc which defines NET_IP_ALIGN to 0 because DMA to unaligned
+addresses can be very expensive and dwarf the cost of unaligned loads.
+
+For some ethernet hardware that cannot DMA to unaligned addresses like
+4*n+2 or non-ethernet hardware, this can be a problem, and it is then
+required to copy the incoming frame into an aligned buffer. Because this is
+unnecessary on architectures that can do unaligned accesses, the code can be
+made dependent on CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS like so:
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	skb = original skb
+#else
+	skb = copy skb
+#endif
+
 --
-Author: Daniel Drake <dsd@gentoo.org>
+Authors: Daniel Drake <dsd@gentoo.org>,
+         Johannes Berg <johannes@sipsolutions.net>
 With help from: Alan Cox, Avuton Olrich, Heikki Orsila, Jan Engelhardt,
-Johannes Berg, Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock,
-Uli Kunitz, Vadim Lobanov
+Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock, Uli Kunitz,
+Vadim Lobanov
 
diff -puN arch/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol arch/Kconfig
--- a/arch/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol
+++ a/arch/Kconfig
@@ -27,6 +27,25 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config HAVE_EFFICIENT_UNALIGNED_ACCESS
+	def_bool n
+	help
+	  Some architectures are unable to perform unaligned accesses
+	  without the use of get_unaligned/put_unaligned. Others are
+	  unable to perform such accesses efficiently (e.g. trap on
+	  unaligned access and require fixing it up in the exception
+	  handler.)
+
+	  This symbol should be selected by an architecture if it can
+	  perform unaligned accesses efficiently to allow different
+	  code paths to be selected for these cases. Some network
+	  drivers, for example, could opt to not fix up alignment
+	  problems with received packets if doing so would not help
+	  much.
+
+	  See Documentation/unaligned-memory-access.txt for more
+	  information on the topic of unaligned memory accesses.
+
 config KRETPROBES
 	def_bool y
 	depends on KPROBES && HAVE_KRETPROBES
diff -puN arch/powerpc/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol
+++ a/arch/powerpc/Kconfig
@@ -112,6 +112,7 @@ config PPC
 	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
diff -puN arch/x86/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol arch/x86/Kconfig
--- a/arch/x86/Kconfig~introduce-have_efficient_unaligned_access-kconfig-symbol
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 
 config ARCH_DEFCONFIG
 	string
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
input-bcm5974-055-smoother-motion-irq-simplification.patch
ath5k-fix-beacon-update-deadlock.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch

