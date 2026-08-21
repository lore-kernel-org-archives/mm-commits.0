Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC839D6FA;
	Fri, 21 Aug 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337855; cv=none; b=lHT4Oksq3UEDJcxGPFUjRr6dQzquYqJQmd/ixIctpyaPtELGGw3lnCKHzor/FlySpEEHh6hnlzigo695k1Vy6a8zZxT4QAeFoy3JVSBgUSb2yA5qfZnawOQCFfa5KOxJFZmFOMManItrTKxkbZbYT101kcPAiDE20rjA/gFo428=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337855; c=relaxed/simple;
	bh=c98CFs/N0sjrTB3xwoA8TtTw6m9Zk+C6Kbh2OgorRxU=;
	h=Date:To:From:Subject:Message-Id; b=bl/Q5wzRbYQUgzlvhwumGsOb97FKfaY4RCmfneaObndnkUHlcubaGAaYf99YShl2QUjYRDrh3W9/51pSL3fNJpnb33suhXck33EjRYIADhVUIyvFkMUo53qdi9rUbvSIololHjiJcbu0dTm33XBNhtuPFvhXaBT3Gl2rcrcdqm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xip9laVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xip9laVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D21F000E9;
	Fri, 21 Aug 2026 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787337852;
	bh=h8ANFG4+UJFZLwTr1nquITw3M1WlydE+XpZXcC97+pM=;
	h=Date:To:From:Subject;
	b=xip9laVGa8X2rAUmS2pbqou4TBSf/vLq7e+MyWSifTxaPCR5SgVphQFrZ/2NMGsot
	 Ri5QoqMr9HmpkcFOFrMAYb7ZlVPMP/7qKSvKmbmxZ7XLD2xA7MtuEpD81xJpjAoXMS
	 uyEzwxaU7fmtmk8ohOifRMakcAStBeppHp1X2DPU=
Date: Fri, 21 Aug 2026 11:44:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,dennis.dalessandro@cornelisnetworks.com,akpm@linux-foundation.org,akinobu.mita@gmail.com,mliang@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-fix-dentry-leak.patch added to mm-nonmm-unstable branch
Message-Id: <20260821184412.9D9D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject: fix dentry leak
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-fix-dentry-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-fix-dentry-leak.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Michael Liang <mliang@purestorage.com>
Subject: fault-inject: fix dentry leak
Date: Fri, 21 Aug 2026 12:15:27 -0600

fault_create_debugfs_attr() has always taken an extra dentry reference on
the created directory (attr->dname = dget(dir)) so that fail_dump() could
print the name via %pd from any context.  Nothing anywhere in the tree
ever calls dput() on attr->dname.

For callers with a matching teardown, that unmatched reference causes one
dentry plus its attached inode to leak per fault_create_debugfs_attr /
debugfs_remove_recursive cycle.  simple_recursive_removal() drops
debugfs's own +1 ref on the child dentry, but the dget()'d ref keeps its
refcount at 1: the dentry ends up unhashed but pinned, and its inode is
never freed.

Boot-once callers (mm/failslab, block/blk-core, etc.) leak exactly once at
init and never destroy the tree, so the impact there is bounded.  But
per-lifecycle callers (drivers/nvme, drivers/infiniband/hw/hfi1,
drivers/mmc, drivers/iommu/iommufd, drivers/media, drivers/misc,
drivers/gpu/drm/msm, drivers/crypto, net/sunrpc) leak on every
create/destroy cycle.

We observed this in production: an NVMe/RDMA host repeatedly reconnecting
to a target that rejected the CRTO Property Get went through ~50 nvme
controller create/destroy cycles per second, and dentry and inode_cache
grew by ~13k pinned objects per 240 s -- unrecoverable through
drop_caches.  Byte math matched a per-cycle 1-dentry / 1-inode leak from
the "fault_inject" directory dentry.

Fix this by not holding any external reference in fault_attr.  Embed the
directory name as a fixed-size char array (FAULT_ATTR_DNAME_LEN, 64 bytes)
inside struct fault_attr, copied by strscpy() at
fault_create_debugfs_attr() time.  fail_dump() prints it via %s.

Advantages of an embedded array over kstrdup() + kfree() paired with a new
destroy API:

  - Zero API footprint.  No new export and no caller changes required:
    callers already own their fault_attr's memory and free it when
    they are done, and now that suffices.
  - No allocation on the create path.
  - fault_create_debugfs_attr() cannot fail from the name-copy step.
  - No lifetime coupling between attr->dname and debugfs; the string
    is valid for exactly as long as the containing struct.

The 64-byte length accommodates every in-tree caller with generous
headroom (the longest current name is "fail_dma_array_full", 19 chars).

The user-visible fail_dump() format changes from "name %pd" to "name %s",
but the printed content is identical -- %pd on the created directory
renders the same string that was passed in as @name.

drivers/infiniband/hw/hfi1/fault.c drops a now-invalid "attr.dname = NULL"
statement; the surrounding kzalloc() already zero-initialises the array.

Link: https://lore.kernel.org/20260821181527.3271414-1-mliang@purestorage.com
Fixes: 6adc4a22f20b ("fault-inject: add ratelimit option")
Signed-off-by: Michael Liang <mliang@purestorage.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/hfi1/fault.c |    1 -
 include/linux/fault-inject.h       |   10 ++++++++--
 lib/fault-inject.c                 |    7 +++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/hfi1/fault.c~fault-inject-fix-dentry-leak
+++ a/drivers/infiniband/hw/hfi1/fault.c
@@ -216,7 +216,6 @@ int hfi1_fault_init_debugfs(struct hfi1_
 	ibd->fault->attr.interval = 1;
 	ibd->fault->attr.require_end = ULONG_MAX;
 	ibd->fault->attr.stacktrace_depth = 32;
-	ibd->fault->attr.dname = NULL;
 	ibd->fault->attr.verbose = 0;
 	ibd->fault->enable = false;
 	ibd->fault->opcode = false;
--- a/include/linux/fault-inject.h~fault-inject-fix-dentry-leak
+++ a/include/linux/fault-inject.h
@@ -19,6 +19,13 @@ enum fault_flags {
 #include <linux/ratelimit.h>
 
 /*
+ * Length of the debugfs directory name embedded in struct fault_attr.
+ * Chosen to accommodate every in-tree caller of fault_create_debugfs_attr()
+ * (the longest is "fail_dma_array_full", 19 chars) with generous headroom.
+ */
+#define FAULT_ATTR_DNAME_LEN	64
+
+/*
  * For explanation of the elements of this struct, see
  * Documentation/fault-injection/fault-injection.rst
  */
@@ -37,7 +44,7 @@ struct fault_attr {
 
 	unsigned long count;
 	struct ratelimit_state ratelimit_state;
-	struct dentry *dname;
+	char dname[FAULT_ATTR_DNAME_LEN];
 };
 
 #define FAULT_ATTR_INITIALIZER {					\
@@ -47,7 +54,6 @@ struct fault_attr {
 		.stacktrace_depth = 32,					\
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
-		.dname = NULL,						\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
--- a/lib/fault-inject.c~fault-inject-fix-dentry-leak
+++ a/lib/fault-inject.c
@@ -5,6 +5,7 @@
 #include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/export.h>
@@ -64,7 +65,7 @@ static void fail_dump(struct fault_attr
 {
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
-		       "name %pd, interval %lu, probability %lu, "
+		       "name %s, interval %lu, probability %lu, "
 		       "space %d, times %d\n", attr->dname,
 		       attr->interval, attr->probability,
 		       atomic_read(&attr->space),
@@ -261,7 +262,9 @@ struct dentry *fault_create_debugfs_attr
 	debugfs_create_xul("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-	attr->dname = dget(dir);
+	if (strscpy(attr->dname, name, sizeof(attr->dname)) == -E2BIG)
+		pr_warn("FAULT_INJECTION: name '%s' truncated to '%s'\n",
+			name, attr->dname);
 	return dir;
 }
 EXPORT_SYMBOL_GPL(fault_create_debugfs_attr);
_

Patches currently in -mm which might be from mliang@purestorage.com are

fault-inject-fix-dentry-leak.patch

