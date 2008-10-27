From: akpm@linux-foundation.org
Subject: + cpqarry-fix-return-value-of-cpqarray_init.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:42:47 -0700
Message-ID: <200810270442.m9R4gloQ018984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYJ0EnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, dvgevers@xs4all.nl, gregkh@suse.de, jens.axboe@oracle.com


The patch titled
     cpqarry: fix return value of cpqarray_init()
has been added to the -mm tree.  Its filename is
     cpqarry-fix-return-value-of-cpqarray_init.patch

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
Subject: cpqarry: fix return value of cpqarray_init()
From: Andrey Borzenkov <arvidjaar@mail.ru>

As reported by Dick Gevers on Compaq ProLiant:

Oct 13 18:06:51 dvgcpl kernel: Compaq SMART2 Driver (v 2.6.0)
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: 'cpqarray'->init
suspiciously returned 1, it should follow 0/-E convention
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: loading module anyway...
Oct 13 18:06:51 dvgcpl kernel: Pid: 315, comm: modprobe Not tainted
2.6.27-desktop-0.rc8.2mnb #1
Oct 13 18:06:51 dvgcpl kernel:  [<c0380612>] ? printk+0x18/0x1e
Oct 13 18:06:51 dvgcpl kernel:  [<c0158f85>] sys_init_module+0x155/0x1c0
Oct 13 18:06:51 dvgcpl kernel:  [<c0103f06>] syscall_call+0x7/0xb
Oct 13 18:06:51 dvgcpl kernel:  =======================


Make it return 0 on success and -ENODEV if no array was found.

Reported-by: Dick Gevers <dvgevers@xs4all.nl>
Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/block/cpqarray.c~cpqarry-fix-return-value-of-cpqarray_init drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarry-fix-return-value-of-cpqarray_init
+++ a/drivers/block/cpqarray.c
@@ -567,7 +567,12 @@ static int __init cpqarray_init(void)
 			num_cntlrs_reg++;
 	}
 
-	return(num_cntlrs_reg);
+	if (num_cntlrs_reg)
+		return 0;
+	else {
+		pci_unregister_driver(&cpqarray_pci_driver);
+		return -ENODEV;
+	}
 }
 
 /* Function to find the first free pointer into our hba[] array */
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

cpqarry-fix-return-value-of-cpqarray_init.patch

