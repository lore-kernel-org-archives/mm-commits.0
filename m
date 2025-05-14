Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0662722171B
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747261004; cv=none; b=t2E+0W+rbYJxIM/zkcROftPIrj2/o5u+JHVLTSkqlVnKevJ8CtgGhX2k8hdZNni8XDBbpy7QU8F8r7mv+HHveFdPadCXTqKvfe3OHqyeAg6m6QLTvQZqXZHyttYFnKXCgdfpWMtypaaU66r9rcvAYObs0xsdj/c+O2eXWoTTZTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747261004; c=relaxed/simple;
	bh=oTPEkeURxsSTHfd7pl0v+kVFtyEUg/FlcnhyaIk4IYM=;
	h=Date:To:From:Subject:Message-Id; b=octUL9PtnJAhf/ZwuA6pbe1uR4P7PUl/IyEf+C11SF8fx3rPUh/fbNjOGEwjzyyhwbEj64iG7/nDikjkqpLJQAlzj/GuLvGfM9oK4Aqjo87KfA6VndGSIajuQX2VKM0jYdFOciFsTpYwkupPbmyE5VhKFxKit1vn3C+jjzCb0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqDQM/l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqDQM/l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C676C4CEED;
	Wed, 14 May 2025 22:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747261003;
	bh=oTPEkeURxsSTHfd7pl0v+kVFtyEUg/FlcnhyaIk4IYM=;
	h=Date:To:From:Subject:From;
	b=NqDQM/l6XB6StdI/OL6eM47Nllkx56P88hu5GrL29mNYhFJOUVgWszsGJ9jzpKd61
	 +NKinNCt0/VxWMpyxU78EVfmXDNs2A8ynPAHOvxMMuAIbnJ7ZTdgLB9JVah3QEL5z3
	 9K35Y9TE5EzQ+Wp8754PyfgJ9CG5eFpH8GJD5/4c=
Date: Wed, 14 May 2025 15:16:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jkangas@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink.patch added to mm-nonmm-unstable branch
Message-Id: <20250514221643.4C676C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: radix tree: fix kmemleak false positive in radix_tree_shrink()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jared Kangas <jkangas@redhat.com>
Subject: radix tree: fix kmemleak false positive in radix_tree_shrink()
Date: Wed, 14 May 2025 11:01:37 -0700

Kmemleak periodically produces a false positive report that resembles the
following:

unreferenced object 0xffff00000db613b8 (size 576):
  comm "systemd", pid 1, jiffies 4294987015
  hex dump (first 32 bytes):
    00 22 01 00 00 00 00 00 28 1c d5 c5 00 00 ff ff  ."......(.......
    10 e4 6c c0 00 00 ff ff d0 13 b6 0d 00 00 ff ff  ..l.............
  backtrace (crc 520d6e1c):
    kmemleak_alloc+0xb4/0xc4
    kmem_cache_alloc+0x288/0x2b0
    radix_tree_node_alloc.constprop.0+0x214/0x364
    idr_get_free+0x3d0/0x690
    idr_alloc_u32+0x120/0x280
    idr_alloc_cyclic+0xe8/0x1b4
    __kernfs_new_node+0x118/0x5a0
    kernfs_create_dir_ns+0x8c/0x1fc
    cgroup_create+0x1cc/0x8a0
    cgroup_mkdir+0x13c/0x90c
    kernfs_iop_mkdir+0x108/0x184
    vfs_mkdir+0x3c8/0x5f0
    do_mkdirat+0x218/0x290
    __arm64_sys_mkdirat+0xe0/0x140
    invoke_syscall.constprop.0+0x74/0x1e4
    do_el0_svc+0xd0/0x1dc

This is a transient leak that can be traced to radix_tree_shrink(): when
root->xa_head is set, kmemleak may have already started traversing the
radix tree.  If this has happened, but kmemleak fails to scan the new
xa_head before it moves, kmemleak will see it as a leak until the radix
tree is scanned again.

Mark the new xa_head as a transient leak to prevent this false positive
report.

Link: https://lkml.kernel.org/r/20250514180137.363929-1-jkangas@redhat.com
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/lib/radix-tree.c~radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink
+++ a/lib/radix-tree.c
@@ -510,6 +510,14 @@ static inline bool radix_tree_shrink(str
 			root_tag_clear(root, IDR_FREE);
 
 		/*
+		 * Kmemleak might report a false positive if it traverses the
+		 * tree while we're shrinking it, since the reference moves
+		 * from node->slots[0] to root->xa_head.
+		 */
+		if (radix_tree_is_internal_node(child))
+			kmemleak_transient_leak(entry_to_node(child));
+
+		/*
 		 * We have a dilemma here. The node's slot[0] must not be
 		 * NULLed in case there are concurrent lookups expecting to
 		 * find the item. However if this was a bottom-level node,
_

Patches currently in -mm which might be from jkangas@redhat.com are

xarray-fix-kmemleak-false-positive-in-xas_shrink.patch
radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink.patch

