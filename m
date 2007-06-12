From: akpm@linux-foundation.org
Subject: - mount-t-tmpfs-o-mpol=-check-nodes-online.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:41 -0700
Message-ID: <200706121856.l5CIufbM018409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbXFLS5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ak@suse.de, clameter@sgi.com, holt@sgi.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mount -t tmpfs -o mpol=: check nodes online
has been removed from the -mm tree.  Its filename was
     mount-t-tmpfs-o-mpol=-check-nodes-online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mount -t tmpfs -o mpol=: check nodes online
From: Hugh Dickins <hugh@veritas.com>

Randy Dunlap reports that a tmpfs, mounted with NUMA mpol= specifying an
offline node, crashes as soon as data is allocated upon it.  Now restrict it
to online nodes, where before it restricted to MAX_NUMNODES.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Tested-and-acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |   10 +++++-----
 mm/shmem.c                          |    2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/tmpfs.txt~mount-t-tmpfs-o-mpol=-check-nodes-online Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~mount-t-tmpfs-o-mpol=-check-nodes-online
+++ a/Documentation/filesystems/tmpfs.txt
@@ -94,10 +94,10 @@ largest node numbers in the range.  For 
 
 Note that trying to mount a tmpfs with an mpol option will fail if the
 running kernel does not support NUMA; and will fail if its nodelist
-specifies a node >= MAX_NUMNODES.  If your system relies on that tmpfs
-being mounted, but from time to time runs a kernel built without NUMA
-capability (perhaps a safe recovery kernel), or configured to support
-fewer nodes, then it is advisable to omit the mpol option from automatic
+specifies a node which is not online.  If your system relies on that
+tmpfs being mounted, but from time to time runs a kernel built without
+NUMA capability (perhaps a safe recovery kernel), or with fewer nodes
+online, then it is advisable to omit the mpol option from automatic
 mount options.  It can be added later, when the tmpfs is already mounted
 on MountPoint, by 'mount -o remount,mpol=Policy:NodeList MountPoint'.
 
@@ -121,4 +121,4 @@ RAM/SWAP in 10240 inodes and it is only 
 Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
-   Hugh Dickins <hugh@veritas.com>, 19 February 2006
+   Hugh Dickins <hugh@veritas.com>, 4 June 2007
diff -puN mm/shmem.c~mount-t-tmpfs-o-mpol=-check-nodes-online mm/shmem.c
--- a/mm/shmem.c~mount-t-tmpfs-o-mpol=-check-nodes-online
+++ a/mm/shmem.c
@@ -967,6 +967,8 @@ static inline int shmem_parse_mpol(char 
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, *policy_nodes))
 			goto out;
+		if (!nodes_subset(*policy_nodes, node_online_map))
+			goto out;
 	}
 	if (!strcmp(value, "default")) {
 		*policy = MPOL_DEFAULT;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
hugetlbfs-use-lib-parser-fix-docs.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch
