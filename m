From: akpm@linux-foundation.org
Subject: [patch 14/18] sparc: support static_key usage in non-module
 __exit sections
Date: Wed, 03 Aug 2016 13:46:27 -0700
Message-ID: <57a25823.e8ezxOQfCuGJZIxw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbcHCUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jbaron@akamai.com, a.p.zijlstra@chello.nl, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@mellanox.com, davem@davemloft.net, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com

From: Jason Baron <jbaron@akamai.com>
Subject: sparc: support static_key usage in non-module __exit sections

The jump table can reference text found in an __exit section. Thus,
instead of discarding it at build/link time, include EXIT_TEXT as part
of __init and release it at system boot time.

Without this patch the link fails with:

    `.exit.text' referenced in section `__jump_table' of xxx.o:
    defined in discarded section `.exit.text' of xxx.o

Link: http://lkml.kernel.org/r/d822da427ab07a02a394602eca687104ff682f83.1467837322.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/vmlinux.lds.S |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/sparc/kernel/vmlinux.lds.S~sparc-support-static_key-usage-in-non-module-__exit-sections arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~sparc-support-static_key-usage-in-non-module-__exit-sections
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -150,6 +150,13 @@ SECTIONS
 	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
+#ifdef CONFIG_JUMP_LABEL
+	. = ALIGN(PAGE_SIZE);
+	.exit.text : {
+		EXIT_TEXT
+	}
+#endif
+
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	BSS_SECTION(0, 0, 0)
_
