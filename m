From: akpm@linux-foundation.org
Subject: + drivers-block-pktcdvdc-prevent-arbitrary-kernel-reads-in-ioctl.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:48:57 -0700
Message-ID: <201009282148.o8SLmv0E019874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab0I1VtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, stable@kernel.org


The patch titled
     drivers/block/pktcdvd.c: prevent arbitrary kernel reads in ioctl
has been added to the -mm tree.  Its filename is
     drivers-block-pktcdvdc-prevent-arbitrary-kernel-reads-in-ioctl.patch

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
Subject: drivers/block/pktcdvd.c: prevent arbitrary kernel reads in ioctl
From: Dan Rosenberg <drosenberg@vsecurity.com>

The PKT_CTRL_CMD_STATUS device ioctl retrieves a pointer to a
pktcdvd_device from the global pkt_devs array.  The index into this array
is provided directly by the user and is a signed integer, so the
comparison to ensure that it falls within the bounds of this array will
fail when provided with a negative index.

This can be used to read arbitrary kernel memory or cause a crash due to
an invalid pointer dereference.  This can be exploited by users with
permission to open /dev/pktcdvd/control (on many distributions, this is
readable by group "cdrom").  This patch fixes it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~drivers-block-pktcdvdc-prevent-arbitrary-kernel-reads-in-ioctl drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~drivers-block-pktcdvdc-prevent-arbitrary-kernel-reads-in-ioctl
+++ a/drivers/block/pktcdvd.c
@@ -2370,7 +2370,7 @@ static void pkt_release_dev(struct pktcd
 
 static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
-	if (dev_minor >= MAX_WRITERS)
+	if ((unsigned int)dev_minor >= MAX_WRITERS)
 		return NULL;
 	return pkt_devs[dev_minor];
 }
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch
sys_semctl-fix-kernel-stack-leakage.patch
drivers-block-pktcdvdc-prevent-arbitrary-kernel-reads-in-ioctl.patch
drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch

