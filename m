From: akpm@linux-foundation.org
Subject: + comedi-jr3_pcic-add-required-includes.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:15:56 -0700
Message-ID: <200906301915.n5UJFuDu006831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbZF3TP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com


The patch titled
     comedi: jr3_pci.c: add required includes
has been added to the -mm tree.  Its filename is
     comedi-jr3_pcic-add-required-includes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: comedi: jr3_pci.c: add required includes
From: Alexander Beregalov <a.beregalov@gmail.com>

jr3_pci.c:739: error: 'jiffies' undeclared
jr3_pci.c:748: error: implicit declaration of function 'msecs_to_jiffies'
jr3_pci.c:763: error: implicit declaration of function 'add_timer'
jr3_pci.c:790: error: implicit declaration of function 'init_timer'
jr3_pci.c:951: error: implicit declaration of function 'del_timer_sync'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/jr3_pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/staging/comedi/drivers/jr3_pci.c~staging-comedi-jr3_pcic-add-required-includes drivers/staging/comedi/drivers/jr3_pci.c
--- a/drivers/staging/comedi/drivers/jr3_pci.c~staging-comedi-jr3_pcic-add-required-includes
+++ a/drivers/staging/comedi/drivers/jr3_pci.c
@@ -45,6 +45,8 @@ Devices: [JR3] PCI force sensor board (j
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
 #include "comedi_pci.h"
 #include "jr3_pci.h"
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
comedi-jr3_pcic-add-required-includes.patch

