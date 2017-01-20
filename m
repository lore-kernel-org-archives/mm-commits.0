From: akpm@linux-foundation.org
Subject: + memblock-let-memblock_type_name-know-about-physmem-type.patch
 added to -mm tree
Date: Fri, 20 Jan 2017 15:04:09 -0800
Message-ID: <58829769.I38b3ItcYt9yuU8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37778 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdATXEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 18:04:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: let memblock_type_name know about physmem type
has been added to the -mm tree.  Its filename is
     memblock-let-memblock_type_name-know-about-physmem-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-let-memblock_type_name-know-about-physmem-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-let-memblock_type_name-know-about-physmem-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

memblock-let-memblock_type_name-know-about-physmem-type.patch
memblock-also-dump-physmem-list-within-__memblock_dump_all.patch
memblock-embed-memblock-type-name-within-struct-memblock_type.patch

