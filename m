From: akpm@linux-foundation.org
Subject: + resource-make-sure-requested-range-is-included-in-the-root-range.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:16:09 -0700
Message-ID: <20120713211609.F192D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63658 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab2GMVQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:16:11 -0400
Received: by qabg24 with SMTP id g24so100312qab.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:16:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: octavian.purdila@intel.com, jbarnes@virtuousgeek.org, linuxram@us.ibm.com


The patch titled
     Subject: resource: make sure requested range is included in the root range
has been added to the -mm tree.  Its filename is
     resource-make-sure-requested-range-is-included-in-the-root-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Octavian Purdila <octavian.purdila@intel.com>
Subject: resource: make sure requested range is included in the root range

When the requested range is outside of the root range the logic in
__reserve_region_with_split will cause an infinite recursion which will
overflow the stack as seen in the warning bellow.

This particular stack overflow was caused by requesting the
(100000000-107ffffff) range while the root range was (0-ffffffff).  In
this case __request_resource would return the whole root range as conflict
range (i.e.  0-ffffffff).  Then, the logic in __reserve_region_with_split
would continue the recursion requesting the new range as (conflict->end+1,
end) which incidentally in this case equals the originally requested
range.

This patch aborts looking for an usable range when the request does not
intersect with the root range.  When the request partially overlaps with
the root range, it ajust the request to fall in the root range and then
continues with the new request.

When the request is modified or aborted errors and a stack trace are
logged to allow catching the errors in the upper layers.

[    5.968374] WARNING: at kernel/sched.c:4129 sub_preempt_count+0x63/0x89()
[    5.975150] Modules linked in:
[    5.978184] Pid: 1, comm: swapper Not tainted 3.0.22-mid27-00004-gb72c817 #46
[    5.985324] Call Trace:
[    5.987759]  [<c1039dfc>] ? console_unlock+0x17b/0x18d
[    5.992891]  [<c1039620>] warn_slowpath_common+0x48/0x5d
[    5.998194]  [<c1031758>] ? sub_preempt_count+0x63/0x89
[    6.003412]  [<c1039644>] warn_slowpath_null+0xf/0x13
[    6.008453]  [<c1031758>] sub_preempt_count+0x63/0x89
[    6.013499]  [<c14d60c4>] _raw_spin_unlock+0x27/0x3f
[    6.018453]  [<c10c6349>] add_partial+0x36/0x3b
[    6.022973]  [<c10c7c0a>] deactivate_slab+0x96/0xb4
[    6.027842]  [<c14cf9d9>] __slab_alloc.isra.54.constprop.63+0x204/0x241
[    6.034456]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.039842]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.045232]  [<c10c7dc9>] kmem_cache_alloc_trace+0x51/0xb0
[    6.050710]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.056100]  [<c103f78f>] kzalloc.constprop.5+0x29/0x38
[    6.061320]  [<c17b45e9>] __reserve_region_with_split+0x1c/0xd1
[    6.067230]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
...
[    7.179057]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
[    7.184970]  [<c17b4779>] reserve_region_with_split+0x30/0x42
[    7.190709]  [<c17a8ebf>] e820_reserve_resources_late+0xd1/0xe9
[    7.196623]  [<c17c9526>] pcibios_resource_survey+0x23/0x2a
[    7.202184]  [<c17cad8a>] pcibios_init+0x23/0x35
[    7.206789]  [<c17ca574>] pci_subsys_init+0x3f/0x44
[    7.211659]  [<c1002088>] do_one_initcall+0x72/0x122
[    7.216615]  [<c17ca535>] ? pci_legacy_init+0x3d/0x3d
[    7.221659]  [<c17a27ff>] kernel_init+0xa6/0x118
[    7.226265]  [<c17a2759>] ? start_kernel+0x334/0x334
[    7.231223]  [<c14d7482>] kernel_thread_helper+0x6/0x10

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN kernel/resource.c~resource-make-sure-requested-range-is-included-in-the-root-range kernel/resource.c
--- a/kernel/resource.c~resource-make-sure-requested-range-is-included-in-the-root-range
+++ a/kernel/resource.c
@@ -7,6 +7,8 @@
  * Arbitrary resource management.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
@@ -791,8 +793,28 @@ void __init reserve_region_with_split(st
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
+	int abort = 0;
+
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (root->start > start || root->end < end) {
+		pr_err("requested range [0x%llx-0x%llx] not in root %pr\n",
+		       (unsigned long long)start, (unsigned long long)end,
+		       root);
+		if (start > root->end || end < root->start)
+			abort = 1;
+		else {
+			if (end > root->end)
+				end = root->end;
+			if (start < root->start)
+				start = root->start;
+			pr_err("fixing request to [0x%llx-0x%llx]\n",
+			       (unsigned long long)start,
+			       (unsigned long long)end);
+		}
+		dump_stack();
+	}
+	if (!abort)
+		__reserve_region_with_split(root, start, end, name);
 	write_unlock(&resource_lock);
 }
 
_
Subject: Subject: resource: make sure requested range is included in the root range

Patches currently in -mm which might be from octavian.purdila@intel.com are

resource-make-sure-requested-range-is-included-in-the-root-range.patch

