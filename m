From: akpm@linux-foundation.org
Subject: [patch 007/124] memblock: let memblock_type_name know about
 physmem type
Date: Fri, 24 Feb 2017 14:55:54 -0800
Message-ID: <58b0b9fa.njQpsZATMwR8rR+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdBXWzz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: memblock: let memblock_type_name know about physmem type

Since commit 70210ed950b5 ("mm/memblock: add physical memory list")
the memblock structure knows about a physical memory list.

memblock_type_name() should return "physmem" instead of "unknown" if
the name of the physmem memblock_type is being asked for.

Link: http://lkml.kernel.org/r/20170120123456.46508-2-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memblock.c~memblock-let-memblock_type_name-know-about-physmem-type mm/memblock.c
--- a/mm/memblock.c~memblock-let-memblock_type_name-know-about-physmem-type
+++ a/mm/memblock.c
@@ -72,6 +72,10 @@ memblock_type_name(struct memblock_type
 		return "memory";
 	else if (type == &memblock.reserved)
 		return "reserved";
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+	else if (type == &memblock.physmem)
+		return "physmem";
+#endif
 	else
 		return "unknown";
 }
_
