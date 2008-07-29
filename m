From: akpm@linux-foundation.org
Subject: - vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:31:25 -0700
Message-ID: <200807290031.m6T0VPJk004348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795AbYG2AcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, ak@linux.intel.com, gregkh@suse.de, hugh@veritas.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     adapt vmscan-unevictable-lru-scan-sysctl.patch to new sysfs API
has been removed from the -mm tree.  Its filename was
     vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch

This patch was dropped because it was folded into vmscan-unevictable-lru-scan-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adapt vmscan-unevictable-lru-scan-sysctl.patch to new sysfs API
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The second attribute parameter is missing in
read_scan_unevictable_node()/write_scan_unevictable_node().
which has been added recently.

	mm/vmscan.c:2654: warning: initialization from incompatible pointer type
	mm/vmscan.c:2654: warning: initialization from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter mm/vmscan.c
--- a/mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter
+++ a/mm/vmscan.c
@@ -2613,12 +2613,15 @@ int scan_unevictable_handler(struct ctl_
  * a specified node's per zone unevictable lists for evictable pages.
  */
 
-static ssize_t read_scan_unevictable_node(struct sys_device *dev, char *buf)
+static ssize_t read_scan_unevictable_node(struct sys_device *dev,
+					  struct sysdev_attribute *attr,
+					  char *buf)
 {
 	return sprintf(buf, "0\n");	/* always zero; should fit... */
 }
 
 static ssize_t write_scan_unevictable_node(struct sys_device *dev,
+					   struct sysdev_attribute *attr,
 					const char *buf, size_t count)
 {
 	struct zone *node_zones = NODE_DATA(dev->id)->node_zones;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
introduce-__get_user_pages.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

