From: akpm@linux-foundation.org
Subject: + mm-avoid-section-mismatch-warning-for-memblock_type_name.patch added to -mm tree
Date: Mon, 01 Oct 2012 13:08:25 -0700
Message-ID: <20121001200826.D2C1720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54308 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2JAUI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 16:08:29 -0400
Received: by eaaq10 with SMTP id q10so344942eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 13:08:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rprabhu@wnohang.net, benh@kernel.crashing.org, tj@kernel.org


The patch titled
     Subject: mm: evoid section mismatch warning for memblock_type_name.
has been added to the -mm tree.  Its filename is
     mm-avoid-section-mismatch-warning-for-memblock_type_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: mm: evoid section mismatch warning for memblock_type_name.

Following section mismatch warning is thrown during build;

    WARNING: vmlinux.o(.text+0x32408f): Section mismatch in reference from the function memblock_type_name() to the variable .meminit.data:memblock
    The function memblock_type_name() references
    the variable __meminitdata memblock.
    This is often because memblock_type_name lacks a __meminitdata
    annotation or the annotation of memblock is wrong.

This is because memblock_type_name makes reference to memblock variable
with attribute __meminitdata.  Hence, the warning (even if the function is
inline).

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-avoid-section-mismatch-warning-for-memblock_type_name mm/memblock.c
--- a/mm/memblock.c~mm-avoid-section-mismatch-warning-for-memblock_type_name
+++ a/mm/memblock.c
@@ -41,7 +41,8 @@ static int memblock_memory_in_slab __ini
 static int memblock_reserved_in_slab __initdata_memblock = 0;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
-static inline const char *memblock_type_name(struct memblock_type *type)
+static inline __init_memblock
+		const char *memblock_type_name(struct memblock_type *type)
 {
 	if (type == &memblock.memory)
 		return "memory";
_

Patches currently in -mm which might be from rprabhu@wnohang.net are

mm-avoid-section-mismatch-warning-for-memblock_type_name.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch

