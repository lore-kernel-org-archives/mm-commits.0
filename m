From: akpm@osdl.org
Subject: + use-zvc-for-free_pages-fix-4.patch added to -mm tree
Date: Fri, 26 Jan 2007 14:14:42 -0800
Message-ID: <200701262214.l0QMEgG2028038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbXAZWOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 17:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com


The patch titled
     use-zvc-for-free_pages-fix-4
has been added to the -mm tree.  Its filename is
     use-zvc-for-free_pages-fix-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use-zvc-for-free_pages-fix-4
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Additional fix

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/snapshot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/power/snapshot.c~use-zvc-for-free_pages-fix-4 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~use-zvc-for-free_pages-fix-4
+++ a/kernel/power/snapshot.c
@@ -591,7 +591,7 @@ static unsigned int count_free_highmem_p
 
 	for_each_zone(zone)
 		if (populated_zone(zone) && is_highmem(zone))
-			cnt += zone->free_pages;
+			cnt += zone_page_state(zone, NR_FREE_PAGES);
 
 	return cnt;
 }
@@ -869,7 +869,7 @@ static int enough_free_mem(unsigned int 
 	for_each_zone(zone) {
 		meta += snapshot_additional_pages(zone);
 		if (!is_highmem(zone))
-			free += zone->free_pages;
+			free += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
touchkit-ps-2-touchscreen-driver.patch
use-zvc-for-free_pages-fix-4.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
