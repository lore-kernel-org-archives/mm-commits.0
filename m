From: akpm@linux-foundation.org
Subject: [merged] dev-mem-remove-redundant-test-on-len.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:24 -0800
Message-ID: <200912152150.nBFLoOHD014953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934027AbZLOWVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: remove redundant test on len
has been removed from the -mm tree.  Its filename was
     dev-mem-remove-redundant-test-on-len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: remove redundant test on len
From: Wu Fengguang <fengguang.wu@intel.com>

The len test in write_kmem() is always true, so can be reduced.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-redundant-test-on-len drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-redundant-test-on-len
+++ a/drivers/char/mem.c
@@ -581,14 +581,12 @@ static ssize_t write_kmem(struct file * 
 
 			if (len > PAGE_SIZE)
 				len = PAGE_SIZE;
-			if (len) {
-				written = copy_from_user(kbuf, buf, len);
-				if (written) {
-					if (wrote + virtr)
-						break;
-					free_page((unsigned long)kbuf);
-					return -EFAULT;
-				}
+			written = copy_from_user(kbuf, buf, len);
+			if (written) {
+				if (wrote + virtr)
+					break;
+				free_page((unsigned long)kbuf);
+				return -EFAULT;
 			}
 			len = vwrite(kbuf, (char *)p, len);
 			count -= len;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch

