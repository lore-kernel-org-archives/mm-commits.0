From: akpm@linux-foundation.org
Subject: [alternative-merged] memory-hotplug-release-lock-on-an-error-path.patch removed from -mm tree
Date: Thu, 27 Oct 2011 15:55:04 -0700
Message-ID: <201110272255.p9RMt5P8028260@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:19876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1J0Wzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 18:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, greg@kroah.com, nfont@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: release lock on an error path
has been removed from the -mm tree.  Its filename was
     memory-hotplug-release-lock-on-an-error-path.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: memory hotplug: release lock on an error path

We need to release the mutex here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-release-lock-on-an-error-path drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-release-lock-on-an-error-path
+++ a/drivers/base/memory.c
@@ -299,7 +299,7 @@ static int memory_block_change_state(str
 		for (i = 0; i < sections_per_block; i++) {
 			ret = check_page_reservations(mem->start_section_nr + i);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation.patch
bio-change-some-signed-vars-to-unsigned.patch
paride-fix-potential-information-leak-in-pg_read.patch

