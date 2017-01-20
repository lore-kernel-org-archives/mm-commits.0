From: akpm@linux-foundation.org
Subject: +
 memblock-also-dump-physmem-list-within-__memblock_dump_all.patch added to
 -mm tree
Date: Fri, 20 Jan 2017 15:04:11 -0800
Message-ID: <5882976b.9Ck46W4wQ7zBvVEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdATXEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 18:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: also dump physmem list within __memblock_dump_all
has been added to the -mm tree.  Its filename is
     memblock-also-dump-physmem-list-within-__memblock_dump_all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-also-dump-physmem-list-within-__memblock_dump_all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-also-dump-physmem-list-within-__memblock_dump_all.patch

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

memblock-let-memblock_type_name-know-about-physmem-type.patch
memblock-also-dump-physmem-list-within-__memblock_dump_all.patch
memblock-embed-memblock-type-name-within-struct-memblock_type.patch

