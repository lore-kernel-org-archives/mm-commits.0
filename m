Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C892146D5A
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771788623; cv=none; b=TZ7S6ChnFEvLa8NnXGGUnZxzTcDBZjbeDfw33GTS4XZQd77dkgxpOVwLH1y6JvDq4w4ZaMFrb3mo1SUAUbS2Ooijxq95hCH0DW2vIKu1cbAXnZuS0pNxWOg+YSJDTKh4uLnsqiyQ/6q2ptkpMewVoaiyLpkAdKnUiYuanOpqFN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771788623; c=relaxed/simple;
	bh=4LE0xjr1/y5xIGBCeA/R3waYi91BVDJfkrmeL6ofEi8=;
	h=Date:To:From:Subject:Message-Id; b=YXb/q7lH8X+VyNpQUbTaVfHB5TuInF4arK8IuPhTCtZALTERl2OVpD5PrjPnWwShrHWJqr3KroHHQJvrr99mTSskGAuoNaP/GDkeYDmR3WNggMC2n9s9xF5sk2IDNEayXlpQllHfHtsnd3uUVsZMl0stSwmwtWybr+VwieAnxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKbODYRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKbODYRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBECC116D0;
	Sun, 22 Feb 2026 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771788623;
	bh=4LE0xjr1/y5xIGBCeA/R3waYi91BVDJfkrmeL6ofEi8=;
	h=Date:To:From:Subject:From;
	b=XKbODYRcrV9V5F3uNS5HLTkd0PXny0FKxVY2+0PxpyzIQYzL1t+OmmSkDUVzuk5zN
	 GTGHrb2acusJFb8RGZRVRHI3FuTnHxmzKdfeAlTNZaD2vfZ5ji7xGl4C0u/jQoUAZa
	 ZdQDoVChqNfxyx88Hnq5PICiF5XN30LSVOVLnB/w=
Date: Sun, 22 Feb 2026 11:30:22 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,ming.lei@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-null-node_data-dereference-for-memoryless-nodes-on-boot.patch added to mm-hotfixes-unstable branch
Message-Id: <20260222193023.0FBECC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-null-node_data-dereference-for-memoryless-nodes-on-boot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-null-node_data-dereference-for-memoryless-nodes-on-boot.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ming Lei <ming.lei@redhat.com>
Subject: mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
Date: Sun, 22 Feb 2026 19:57:02 +0800

Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones
and memory map") moved free_area_init() from setup_arch() to
mm_core_init_early(), which runs after setup_arch() returns.

This changed the ordering relative to init_cpu_to_node() on x86.  Before
the commit, free_area_init() ran during paging_init() (called from
setup_arch()) *before* init_cpu_to_node().  After the commit, it runs
*after* init_cpu_to_node().

On machines with memoryless NUMA nodes (e.g., node 0 has CPUs but no
memory), this causes a NULL pointer dereference:

 1. numa_register_nodes() skips memoryless nodes: no alloc_node_data()
    and no node_set_online() for them.
 2. init_cpu_to_node() sets memoryless nodes online (they have CPUs)
    but does not allocate NODE_DATA.
 3. free_area_init() checks "if (!node_online(nid))" to decide whether
    to call alloc_offline_node_data(). Since the memoryless node is now
    online, the allocation is skipped, leaving NODE_DATA(nid) == NULL.
 4. The immediate "pgdat = NODE_DATA(nid)" dereferences NULL.

The crash happens before console_init(), so no output is visible without
earlyprintk.  With earlyprintk enabled, the following panic is observed:

 BUG: unable to handle page fault for address: 000000000002a1e0
 Oops: Oops: 0000 [#1] SMP NOPTI
 RIP: 0010:free_area_init_node+0x3a/0x540
 Call Trace:
  <TASK>
  free_area_init+0x331/0x4e0
  start_kernel+0x69/0x4a0
  x86_64_start_reservations+0x24/0x30
  x86_64_start_kernel+0x125/0x130
  common_startup_64+0x13e/0x148
  </TASK>
 Kernel panic - not syncing: Attempted to kill the idle task!

Fix this by checking "if (!NODE_DATA(nid))" instead of "if
(!node_online(nid))".  This directly tests whether the per-node data
structure needs to be allocated, regardless of the node's online status. 
This change is also safe for non-x86 architectures as they all allocate
NODE_DATA for every node including memoryless ones, so the check simply
evaluates to false with no change in behavior.

Link: https://lkml.kernel.org/r/20260222115702.3659-1-ming.lei@redhat.com
Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-fix-null-node_data-dereference-for-memoryless-nodes-on-boot
+++ a/mm/mm_init.c
@@ -1896,7 +1896,11 @@ static void __init free_area_init(void)
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
-		if (!node_online(nid))
+		/*
+		 * If an architecture has not allocated node data for
+		 * this node, presume the node is memoryless or offline.
+		 */
+		if (!NODE_DATA(nid))
 			alloc_offline_node_data(nid);
 
 		pgdat = NODE_DATA(nid);
_

Patches currently in -mm which might be from ming.lei@redhat.com are

mm-fix-null-node_data-dereference-for-memoryless-nodes-on-boot.patch

