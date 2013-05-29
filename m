From: akpm@linux-foundation.org
Subject: + pktcdvd-silence-static-checker-warning.patch added to -mm tree
Date: Wed, 29 May 2013 15:29:35 -0700
Message-ID: <51a6814f.YJkuO8Q+IESydyrf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935320Ab3E2W3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:29:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, dan.carpenter@oracle.com

Subject: + pktcdvd-silence-static-checker-warning.patch added to -mm tree
To: dan.carpenter@oracle.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:29:35 -0700


The patch titled
     Subject: pktcdvd: silence static checker warning
has been added to the -mm tree.  Its filename is
     pktcdvd-silence-static-checker-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: pktcdvd: silence static checker warning

Static checkers complain about widening the binary "not" operations here
because sectors are u64 and "(pd)->settings.size" is unsigned int.  It
unintentionally clears the high 32 bits of the sector.  This means that
the driver won't work for devices with over 2TB of space.  Since this is a
DVD drive, we're unlikely to reach that limit, but we may as well silence
the warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-silence-static-checker-warning drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-silence-static-checker-warning
+++ a/drivers/block/pktcdvd.c
@@ -83,7 +83,8 @@
 
 #define MAX_SPEED 0xffff
 
-#define ZONE(sector, pd) (((sector) + (pd)->offset) & ~((pd)->settings.size - 1))
+#define ZONE(sector, pd) (((sector) + (pd)->offset) & \
+			~(sector_t)((pd)->settings.size - 1))
 
 static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
configfs-use-capped-length-for-store_attribute.patch
errh-is_err-can-accept-__user-pointers.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
minix-bug-widening-a-binary-not-operation.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch
pktcdvd-silence-static-checker-warning.patch

