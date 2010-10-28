From: akpm@linux-foundation.org
Subject: + rapidio-use-resource_size.patch added to -mm tree
Date: Thu, 28 Oct 2010 16:02:52 -0700
Message-ID: <201010282302.o9SN2qLq026387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab0J1XDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 19:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, alexandre.bounine@idt.com


The patch titled
     rapidio: use resource_size()
has been added to the -mm tree.  Its filename is
     rapidio-use-resource_size.patch

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
Subject: rapidio: use resource_size()
From: Dan Carpenter <error27@gmail.com>

The size calculation is done incorrectly here because it should include
both the start and end (end - start + 1).  It's easiest to just use
resource_size() which does the right thing.

I was worried there was something non-standard going on because the
printk() subtracts "end - 1", but the rest of the file uses the normal
resource size calculations.  This function is only called from
fsl_rio_setup() in arch/powerpc/sysdev/fsl_rio.c and the calculation
there is also:

	port->iores.start = law_start;
	port->iores.end = law_start + law_size - 1;

So I think this is the correct fix.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-use-resource_size drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-use-resource_size
+++ a/drivers/rapidio/rio.c
@@ -1159,11 +1159,11 @@ int __devinit rio_init_mports(void)
 
 	list_for_each_entry(port, &rio_mports, node) {
 		if (!request_mem_region(port->iores.start,
-					port->iores.end - port->iores.start,
+					resource_size(&port->iores),
 					port->name)) {
 			printk(KERN_ERR
 			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end - 1);
+			       (u64)port->iores.start, (u64)port->iores.end);
 			rc = -ENOMEM;
 			goto out;
 		}
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
rapidio-use-resource_size.patch
linux-next.patch

