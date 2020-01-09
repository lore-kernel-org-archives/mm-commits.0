From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?drivers-base-memoryc-cache-blocks-in-radix-tree-to-acceler?=
 =?US-ASCII?Q?ate-lookup-fix.patch?= added to -mm tree
Date: Thu, 09 Jan 2020 14:28:38 -0800
Message-ID: <20200109222838.tfI8LqnN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgAIW2j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 17:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cheloha@linux.ibm.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, nathanl@linux.ibm.com, rafael@kernel.org, ricklind@linux.vnet.ibm.com


The patch titled
     Subject: drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix

document the radix tree locking

Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/memory.c~drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix
+++ a/drivers/base/memory.c
@@ -61,6 +61,9 @@ static struct bus_type memory_subsys = {
  * Memory blocks are cached in a local radix tree to avoid
  * a costly linear search for the corresponding device on
  * the subsystem bus.
+ *
+ * Protected by mem_hotplug_lock in mem_hotplug_begin(), and by the guaranteed
+ * single-threadness at boot time.
  */
 static RADIX_TREE(memory_blocks, GFP_KERNEL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
