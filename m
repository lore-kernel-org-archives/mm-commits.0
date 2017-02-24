From: akpm@linux-foundation.org
Subject: [patch 008/124] memblock: also dump physmem list within
 __memblock_dump_all
Date: Fri, 24 Feb 2017 14:55:56 -0800
Message-ID: <58b0b9fc.gbq5+2qYVJZYrxWS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXWz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com

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
