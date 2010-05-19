From: akpm@linux-foundation.org
Subject: [merged] drivers-edac-introduce-missing-kfree.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:53 -0400
Message-ID: <201005191733.o4JHXJn1025806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab0ESRdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-edac-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Doug Thompson <norsk5@yahoo.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i7core_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i7core_edac.c~drivers-edac-introduce-missing-kfree drivers/edac/i7core_edac.c
--- a/drivers/edac/i7core_edac.c~drivers-edac-introduce-missing-kfree
+++ a/drivers/edac/i7core_edac.c
@@ -1215,8 +1215,10 @@ int i7core_get_onedevice(struct pci_dev 
 			return -ENOMEM;
 		i7core_dev->pdev = kzalloc(sizeof(*i7core_dev->pdev) * n_devs,
 					   GFP_KERNEL);
-		if (!i7core_dev->pdev)
+		if (!i7core_dev->pdev) {
+			kfree(i7core_dev);
 			return -ENOMEM;
+		}
 		i7core_dev->socket = socket;
 		i7core_dev->n_devs = n_devs;
 		list_add_tail(&i7core_dev->list, &i7core_edac_list);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
arch-x86-pci-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch

