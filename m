From: akpm@linux-foundation.org
Subject: +
 mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch added
 to -mm tree
Date: Wed, 31 May 2017 14:08:04 -0700
Message-ID: <592f30b4.W16g98555m/RVpyI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaVIF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 17:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garsilva@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: add NULL check to avoid potential NULL pointer dereference
has been added to the -mm tree.  Its filename is
     mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: mm/memory_hotplug.c: add NULL check to avoid potential NULL pointer dereference

NULL check at line 1226: if (!pgdat), implies that pointer pgdat
might be NULL.

rollback_node_hotadd() dereferences this pointer.  Add NULL check to avoid
a potential NULL pointer dereference.

Addresses-Coverity-ID: 1369133
Link: http://lkml.kernel.org/r/20170530212436.GA6195@embeddedgus
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-add-null-check-to-avoid-potential-null-pointer-dereference mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-null-check-to-avoid-potential-null-pointer-dereference
+++ a/mm/memory_hotplug.c
@@ -1273,7 +1273,7 @@ register_fail:
 
 error:
 	/* rollback pgdat allocation and others */
-	if (new_pgdat)
+	if (new_pgdat && pgdat)
 		rollback_node_hotadd(nid, pgdat);
 	memblock_remove(start, size);
 
_

Patches currently in -mm which might be from garsilva@embeddedor.com are

mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch

