From: akpm@linux-foundation.org
Subject: + mm-compactionc-mark-function-as-static.patch added to -mm tree
Date: Fri, 07 Feb 2014 14:31:24 -0800
Message-ID: <52f55ebc.YYmM5pvVNXVVRBdk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGWbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + mm-compactionc-mark-function-as-static.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:31:24 -0800


The patch titled
     Subject: mm/compaction.c: mark function as static
has been added to the -mm tree.  Its filename is
     mm-compactionc-mark-function-as-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-mark-function-as-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-mark-function-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/compaction.c: mark function as static

Mark function as static in compaction.c because it is not used outside
this file.

This eliminates the following warning from mm/compaction.c:
mm/compaction.c:1190:9: warning: no previous prototype for `sysfs_compact_node' [-Wmissing-prototypes

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compactionc-mark-function-as-static mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-mark-function-as-static
+++ a/mm/compaction.c
@@ -1229,7 +1229,7 @@ int sysctl_extfrag_handler(struct ctl_ta
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-ssize_t sysfs_compact_node(struct device *dev,
+static ssize_t sysfs_compact_node(struct device *dev,
 			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch

