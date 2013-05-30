From: akpm@linux-foundation.org
Subject: [merged] pktcdvd-silence-static-checker-warning.patch removed
 from -mm tree
Date: Thu, 30 May 2013 12:20:55 -0700
Message-ID: <51a7a697.Ud1EhQ+EBVA6gD8T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3E3TU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 15:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, dan.carpenter@oracle.com

Subject: [merged] pktcdvd-silence-static-checker-warning.patch removed from -mm tree
To: dan.carpenter@oracle.com,jkosina@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 12:20:55 -0700


The patch titled
     Subject: pktcdvd: silence static checker warning
has been removed from the -mm tree.  Its filename was
     pktcdvd-silence-static-checker-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

