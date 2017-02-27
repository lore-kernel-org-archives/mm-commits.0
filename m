From: akpm@linux-foundation.org
Subject: [merged]
 memblock-also-dump-physmem-list-within-__memblock_dump_all.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:24:25 -0800
Message-ID: <58b48af9.AyVSjILDh7rQrEar%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdB0UYp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: also dump physmem list within __memblock_dump_all
has been removed from the -mm tree.  Its filename was
     memblock-also-dump-physmem-list-within-__memblock_dump_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: memblock: also dump physmem list within __memblock_dump_all

Since commit 70210ed950b5 ("mm/memblock: add physical memory list")
the memblock structure knows about a physical memory list.

The physical memory list should also be dumped if memblock_dump_all()
is called in case memblock_debug is switched on. This makes debugging
a bit easier.

Link: http://lkml.kernel.org/r/20170120123456.46508-3-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~memblock-also-dump-physmem-list-within-__memblock_dump_all mm/memblock.c
--- a/mm/memblock.c~memblock-also-dump-physmem-list-within-__memblock_dump_all
+++ a/mm/memblock.c
@@ -1732,6 +1732,9 @@ void __init_memblock __memblock_dump_all
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+	memblock_dump(&memblock.physmem, "physmem");
+#endif
 }
 
 void __init memblock_allow_resize(void)
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are


