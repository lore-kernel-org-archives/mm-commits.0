From: akpm@linux-foundation.org
Subject: [patch 15/18] tile: support static_key usage in non-module __exit sections
Date: Wed, 03 Aug 2016 13:46:30 -0700
Message-ID: <57a25826.ugMVsZEnR2Qzu9Ib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbcHCUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, cmetcalf@mellanox.com, a.p.zijlstra@chello.nl, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, jbaron@akamai.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com

From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: tile: support static_key usage in non-module __exit sections

Previously, all the __exit sections were just dropped by the link phase. 
However, if there are static_key (jump label) constructs in __exit
sections that are not modules, the link fails with the message:

   `.exit.text' referenced in section `__jump_table' of xxx.o:
   defined in discarded section `.exit.text' of xxx.o

Support this usage by keeping the .exit.text sections in the final image
if JUMP_LABEL is defined, then discarding them once initialization is
complete.

Link: http://lkml.kernel.org/r/bfd7c107c610c30e992868ebfe2a5d796a097464.1467837322.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/vmlinux.lds.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN arch/tile/kernel/vmlinux.lds.S~tile-support-static_key-usage-in-non-module-__exit-sections arch/tile/kernel/vmlinux.lds.S
--- a/arch/tile/kernel/vmlinux.lds.S~tile-support-static_key-usage-in-non-module-__exit-sections
+++ a/arch/tile/kernel/vmlinux.lds.S
@@ -60,6 +60,18 @@ SECTIONS
   /* "Init" is divided into two areas with very different virtual addresses. */
   INIT_TEXT_SECTION(PAGE_SIZE)
 
+  /*
+   * Some things, like the __jump_table, may contain symbol references
+   * to __exit text, so include such text in the final image if so.
+   * In that case we also override the _einittext from INIT_TEXT_SECTION.
+   */
+#ifdef CONFIG_JUMP_LABEL
+  .exit.text : {
+    EXIT_TEXT
+    _einittext = .;
+  }
+#endif
+
   /* Now we skip back to PAGE_OFFSET for the data. */
   . = (. - TEXT_OFFSET + PAGE_OFFSET);
   #undef LOAD_OFFSET
_
