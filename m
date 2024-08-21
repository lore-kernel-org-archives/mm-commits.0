Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5E7405A
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724274376; cv=none; b=i1c26H3H5uP5x5yA8tLnm2VHOOfgUMRK/2QvcBzbmDtQ/aXK5ECRXVDv/L6BZM1u4hl/loo6DilQEZes2Ac7kTMniuEzVHqPrTzLC3VjyBScH3enFlNzl4pEl3xrhnVa7LompEpwRTmhXB6d7GNR7wB0ciglgrEqZnNMSKKBVyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724274376; c=relaxed/simple;
	bh=ZADX0+WEeOEwypjse+iX1xtxwwDsYQX2D7mySDgzGIM=;
	h=Date:To:From:Subject:Message-Id; b=X8Hvcs4qaGmxtHgPk95UQpr4P5DqNI5yYrTJ2wxjIKlGOwIPetrpOvHhJsO6JGJIjb0T8fOp7iMaPXGlK7JuZYesLr3K4UcRzdjUNLHC+zRZ2YFiyQhKuGQSUDxrjEjyp4DpjXt2lkS3TUkf4WBELqoqBdUad79YQtcJGJ9zcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OB7c5ts8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OB7c5ts8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFC1C4AF10;
	Wed, 21 Aug 2024 21:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724274375;
	bh=ZADX0+WEeOEwypjse+iX1xtxwwDsYQX2D7mySDgzGIM=;
	h=Date:To:From:Subject:From;
	b=OB7c5ts8ogpGhkSJua7MHSkN87y8qZ0RC482thcyNsoWdwcErefb24bfPSTpSYiAE
	 gtKuyDHg+4xiUe+zz81qZp38gJvppAGq4VCiV+mquKqBICy9k4tyeUFjkpmkFOhlRG
	 lwy27vwkqg6G6Tl+07EYtrD4KeOeuuc2DCxFkkz0=
Date: Wed, 21 Aug 2024 14:06:14 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,ira.weiny@intel.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] resource-fix-region_intersects-for-cxl-memory.patch removed from -mm tree
Message-Id: <20240821210615.6EFC1C4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: fix region_intersects() for CXL memory
has been removed from the -mm tree.  Its filename was
     resource-fix-region_intersects-for-cxl-memory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: resource: fix region_intersects() for CXL memory
Date: Fri, 16 Aug 2024 10:07:23 +0800

On a system with CXL memory installed, the resource tree (/proc/iomem)
related to CXL memory looks like something as follows.

490000000-50fffffff : CXL Window 0
  490000000-50fffffff : region0
    490000000-50fffffff : dax0.0
      490000000-50fffffff : System RAM (kmem)

When the following command line is run to try writing some memory in
CXL memory range,

 $ dd if=data of=/dev/mem bs=1k seek=19136512 count=1
 dd: error writing '/dev/mem': Bad address
 1+0 records in
 0+0 records out
 0 bytes copied, 0.0283507 s, 0.0 kB/s

the command fails as expected.  However, the error code is wrong.  It
should be "Operation not permitted" instead of "Bad address".  And,
the following warning is reported in kernel log.

 ioremap on RAM at 0x0000000490000000 - 0x0000000490000fff
 WARNING: CPU: 2 PID: 416 at arch/x86/mm/ioremap.c:216 __ioremap_caller.constprop.0+0x131/0x35d
 Modules linked in: cxl_pmem libnvdimm cbc encrypted_keys cxl_pmu
 CPU: 2 UID: 0 PID: 416 Comm: dd Not tainted 6.11.0-rc3-kvm #40
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
 RIP: 0010:__ioremap_caller.constprop.0+0x131/0x35d
 Code: 2d 80 3d 24 6a a1 02 00 75 c1 48 8d 54 24 70 48 8d b4 24 90 00 00 00 48 c7 c7 40 3a 05 8a c6 05 07 6a a1 02 01 e8 a3 a0 01 00 <0f> 0b eb 9d 48 8b 84 24 90 00 00 00 48 8d 4c 24 60 89 ea 48 bf 00
 RSP: 0018:ffff888105387bf0 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: 0000000490000fff RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffffed1020a70f73
 RBP: 0000000000000000 R08: ffffed100d9fce92 R09: 0000000000000001
 R10: ffffffff892348e7 R11: ffffed100d9fce91 R12: 0000000490000000
 R13: 0000000000000001 R14: 0000000000000001 R15: ffff888105387ca0
 FS:  00007f86c438c740(0000) GS:ffff88806ce00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055ba75b1b818 CR3: 0000000005231000 CR4: 0000000000350eb0
 Call Trace:
  <TASK>
  ? __warn+0xd7/0x1b8
  ? __ioremap_caller.constprop.0+0x131/0x35d
  ? report_bug+0x136/0x19e
  ? __ioremap_caller.constprop.0+0x131/0x35d
  ? handle_bug+0x3c/0x64
  ? exc_invalid_op+0x13/0x38
  ? asm_exc_invalid_op+0x16/0x20
  ? irq_work_claim+0x16/0x38
  ? __ioremap_caller.constprop.0+0x131/0x35d
  ? tracer_hardirqs_off+0x18/0x16d
  ? kmem_cache_debug_flags+0x16/0x23
  ? memremap+0xcb/0x184
  ? iounmap+0xfe/0xfe
  ? lock_sync+0xc7/0xc7
  ? lock_sync+0xc7/0xc7
  ? rcu_is_watching+0x1c/0x38
  ? do_raw_read_unlock+0x37/0x42
  ? _raw_read_unlock+0x1f/0x2f
  memremap+0xcb/0x184
  ? pfn_valid+0x159/0x159
  ? resource_is_exclusive+0xba/0xc5
  xlate_dev_mem_ptr+0x25/0x2f
  write_mem+0x94/0xfb
  vfs_write+0x128/0x26d
  ? kernel_write+0x89/0x89
  ? rcu_is_watching+0x1c/0x38
  ? __might_fault+0x72/0xba
  ? __might_fault+0x72/0xba
  ? rcu_is_watching+0x1c/0x38
  ? lock_release+0xba/0x13e
  ? files_lookup_fd_raw+0x40/0x4b
  ? __fget_light+0x64/0x89
  ksys_write+0xac/0xfe
  ? __ia32_sys_read+0x40/0x40
  ? tracer_hardirqs_off+0x18/0x16d
  ? tracer_hardirqs_on+0x11/0x146
  do_syscall_64+0x9a/0xfd
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 RIP: 0033:0x7f86c4487140
 Code: 40 00 48 8b 15 c1 9c 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d a1 24 0e 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
 RSP: 002b:00007ffca9f62af8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 0000000000000400 RCX: 00007f86c4487140
 RDX: 0000000000000400 RSI: 000055ba75b1a000 RDI: 0000000000000001
 RBP: 000055ba75b1a000 R08: 0000000000000000 R09: 00007f86c457c080
 R10: 00007f86c43a84d0 R11: 0000000000000202 R12: 0000000000000000
 R13: 0000000000000000 R14: 000055ba75b1a000 R15: 0000000000000400
  </TASK>
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffff89091e85>] copy_process+0xb60/0x255f
 softirqs last  enabled at (0): [<ffffffff89091e85>] copy_process+0xb60/0x255f
 softirqs last disabled at (0): [<0000000000000000>] 0x0

After investigation, we found the following bug.

In the above resource tree, "System RAM" is a descendant of "CXL Window 0"
instead of a top level resource.  So, region_intersects() will report no
System RAM resources in the CXL memory region incorrectly, because it only
checks the top level resources.  Consequently, devmem_is_allowed() will
return 1 (allow access via /dev/mem) for CXL memory region incorrectly. 
Fortunately, ioremap() doesn't allow to map System RAM and reject the
access.

However, region_intersects() needs to be fixed to work correctly with the
resources tree with CXL Window as above.  To fix it, we will search
matched resources in the descendant resources too.  So, we will not miss
any matched resources anymore.

Link: https://lkml.kernel.org/r/20240816020723.771196-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

--- a/kernel/resource.c~resource-fix-region_intersects-for-cxl-memory
+++ a/kernel/resource.c
@@ -542,18 +542,48 @@ static int __region_intersects(struct re
 {
 	struct resource res;
 	int type = 0; int other = 0;
-	struct resource *p;
+	struct resource *p, *dp;
+	resource_size_t ostart, oend;
+	bool is_type;
 
 	res.start = start;
 	res.end = start + size - 1;
 
 	for (p = parent->child; p ; p = p->sibling) {
-		bool is_type = (((p->flags & flags) == flags) &&
-				((desc == IORES_DESC_NONE) ||
-				 (desc == p->desc)));
-
-		if (resource_overlaps(p, &res))
-			is_type ? type++ : other++;
+		if (!resource_overlaps(p, &res))
+			continue;
+		is_type = (((p->flags & flags) == flags) &&
+			   ((desc == IORES_DESC_NONE) || (desc == p->desc)));
+		if (is_type) {
+			type++;
+			continue;
+		}
+		/*
+		 * Continue to search in descendant resources.  Unless
+		 * the matched descendant resources cover the whole
+		 * overlapped range, increase 'other', because it
+		 * overlaps with 'p' at least.
+		 */
+		other++;
+		ostart = max(res.start, p->start);
+		oend = min(res.end, p->end);
+		for_each_resource(p, dp, false) {
+			if (!resource_overlaps(dp, &res))
+				continue;
+			is_type = (((dp->flags & flags) == flags) &&
+				   ((desc == IORES_DESC_NONE) ||
+				    (desc == dp->desc)));
+			if (is_type) {
+				type++;
+				if (dp->start > ostart)
+					break;
+				if (dp->end >= oend) {
+					other--;
+					break;
+				}
+				ostart = dp->end + 1;
+			}
+		}
 	}
 
 	if (type == 0)
_

Patches currently in -mm which might be from ying.huang@intel.com are


