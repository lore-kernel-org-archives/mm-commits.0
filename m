From: akpm@osdl.org
Subject: - sys_mbind-use-cpuset-accessors-for-mems_allowed.patch removed from -mm tree
Date: Fri, 12 Jan 2007 12:39:29 -0800
Message-ID: <200701122039.l0CKdTiP028254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXALUjd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 15:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     sys_mbind: use cpuset accessors for mems_allowed
has been removed from the -mm tree.  Its filename was
     sys_mbind-use-cpuset-accessors-for-mems_allowed.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sys_mbind: use cpuset accessors for mems_allowed
From: Andy Whitcroft <apw@shadowen.org>

sys_mbind is currently accessing mems_allowed directly.  This
does not exist when CONFIG_CPUSETS is not defined.  This leads
to the following error:

  mm/mempolicy.c: In function `sys_mbind':
  mm/mempolicy.c:885: error: structure has no member named `mems_allowed'

Use the cpuset accessors.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mempolicy.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~sys_mbind-use-cpuset-accessors-for-mems_allowed mm/mempolicy.c
--- a/mm/mempolicy.c~sys_mbind-use-cpuset-accessors-for-mems_allowed
+++ a/mm/mempolicy.c
@@ -880,9 +880,11 @@ asmlinkage long sys_mbind(unsigned long 
 {
 	nodemask_t nodes;
 	int err;
+	nodemask_t allowed_nodes;
 
 	err = get_nodes(&nodes, nmask, maxnode);
-	nodes_and(nodes, nodes, current->mems_allowed);
+	allowed_nodes = cpuset_mems_allowed(current);
+	nodes_and(nodes, nodes, allowed_nodes);
 	if (err)
 		return err;
 	return do_mbind(start, len, mode, &nodes, flags);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
fix-sparsemem-on-cell.patch
sys_mbind-use-cpuset-accessors-for-mems_allowed.patch
pci-device-ensure-sysdata-initialised-v2.patch
slab-cache-alloc-cleanups.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
