From: akpm@linux-foundation.org
Subject: + get_nodes-should-ignore-invalid-node.patch added to -mm tree
Date: Tue, 21 Aug 2007 19:35:13 -0700
Message-ID: <200708220235.l7M2ZDDW023334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbXHVCf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 22:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, clameter@sgi.com, stable@kernel.org


The patch titled
     get_nodes() should ignore invalid node
has been added to the -mm tree.  Its filename is
     get_nodes-should-ignore-invalid-node.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
