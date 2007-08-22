From: akpm@linux-foundation.org
Subject: - get_nodes-should-ignore-invalid-node.patch removed from -mm tree
Date: Wed, 22 Aug 2007 12:19:53 -0700
Message-ID: <200708221919.l7MJJrIq032456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbXHVTUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 15:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, clameter@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     get_nodes() should ignore invalid node
has been removed from the -mm tree.  Its filename was
     get_nodes-should-ignore-invalid-node.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: get_nodes() should ignore invalid node
From: Shaohua Li <shaohua.li@intel.com>

get_nodes() doesn't check if nodes in node mask are valid, cause a kernel
oops when an invalid node is used..

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mempolicy.c~get_nodes-should-ignore-invalid-node mm/mempolicy.c
--- a/mm/mempolicy.c~get_nodes-should-ignore-invalid-node
+++ a/mm/mempolicy.c
@@ -850,6 +850,8 @@ static int get_nodes(nodemask_t *nodes, 
 	if (copy_from_user(nodes_addr(*nodes), nmask, nlongs*sizeof(unsigned long)))
 		return -EFAULT;
 	nodes_addr(*nodes)[nlongs-1] &= endmask;
+
+	nodes_and(*nodes, *nodes, node_online_map);
 	return 0;
 }
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
get_nodes-should-ignore-invalid-node.patch
git-acpi.patch
git-kvm.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
