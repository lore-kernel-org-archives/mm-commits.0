From: akpm@linux-foundation.org
Subject: - mem-policy-fix-mempolicy-usage-in-pci-driver.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:09 -0800
Message-ID: <200711262149.lAQLn9QM024733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbXKZV7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, greg@kroah.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Mem Policy: fix mempolicy usage in pci driver
has been removed from the -mm tree.  Its filename was
     mem-policy-fix-mempolicy-usage-in-pci-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Mem Policy: fix mempolicy usage in pci driver
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

In an attempt to ensure memory allocation from the local node, the pci
driver temporarily replaces the current task's memory policy with the
system default policy.  Trying to be a good citizen, the driver then call's
mpol_get() on the new policy.  When it's finished probing, it undoes the
'_get by calling mpol_free() [on the system default policy] and then
restores the current task's saved mempolicy.

A couple of issues here:

1) it's never necessary to set a task's mempolicy to the
   system default policy in order to get system default
   allocation behavior.  Simply set the current task's
   mempolicy to NULL and allocations will fall back to
   system default policy.

2) we should never [need to] call mpol_free() on the system
   default policy.  [I plan on trapping this with a VM_BUG_ON()
   in a subsequent patch.]

This patch removes the calls to mpol_get() and mpol_free()
and uses NULL for the temporary task mempolicy to effect
default allocation behavior.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-driver.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/pci/pci-driver.c~mem-policy-fix-mempolicy-usage-in-pci-driver drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~mem-policy-fix-mempolicy-usage-in-pci-driver
+++ a/drivers/pci/pci-driver.c
@@ -177,13 +177,11 @@ static int pci_call_probe(struct pci_dri
 	    set_cpus_allowed(current, node_to_cpumask(node));
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
-	current->mempolicy = &default_policy;
-	mpol_get(current->mempolicy);
+	current->mempolicy = NULL;	/* fall back to system default policy */
 #endif
 	error = drv->probe(dev, id);
 #ifdef CONFIG_NUMA
 	set_cpus_allowed(current, oldmask);
-	mpol_free(current->mempolicy);
 	current->mempolicy = oldpol;
 #endif
 	return error;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

memory-controller-add-per-container-lru-and-reclaim-v7.patch
