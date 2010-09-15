From: akpm@linux-foundation.org
Subject: + drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:49:27 -0700
Message-ID: <201009151949.o8FJnRfR012027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab0IOTuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.rosenberg@gmail.com, grundler@parisc-linux.org, jeffm@suse.com


The patch titled
     drivers/net/tulip/de4x5.c: fix copy length in de4x5_ioctl()
has been added to the -mm tree.  Its filename is
     drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl.patch

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
Subject: drivers/net/tulip/de4x5.c: fix copy length in de4x5_ioctl()
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

The DE4X5_GET_REG device ioctl copies the "addr" member instead of the
intended "lval" member.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/de4x5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/tulip/de4x5.c~drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl drivers/net/tulip/de4x5.c
--- a/drivers/net/tulip/de4x5.c~drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl
+++ a/drivers/net/tulip/de4x5.c
@@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
 	tmp.lval[6] = inl(DE4X5_STRR); j+=4;
 	tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
 	ioc->len = j;
-	if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
+	if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
 	break;
 
 #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */
_

Patches currently in -mm which might be from dan.j.rosenberg@gmail.com are

linux-next.patch
sctp-prevent-reading-out-of-bounds-memory.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl.patch

