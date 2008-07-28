From: akpm@linux-foundation.org
Subject: - drivers-base-memoryc-fix-fallout-from-sysdev-api-changes.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:04 -0700
Message-ID: <200807282111.m6SLB4pX027637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849AbYG1VMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ntl@pobox.com, andi@firstfloor.org, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/base/memory.c: fix fallout from sysdev API changes
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-fix-fallout-from-sysdev-api-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/memory.c: fix fallout from sysdev API changes
From: Nathan Lynch <ntl@pobox.com>

drivers/base/memory.c:280: warning: initialization from incompatible pointer type

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~drivers-base-memoryc-fix-fallout-from-sysdev-api-changes drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-base-memoryc-fix-fallout-from-sysdev-api-changes
+++ a/drivers/base/memory.c
@@ -103,7 +103,8 @@ static ssize_t show_mem_phys_index(struc
 /*
  * Show whether the section of memory is likely to be hot-removable
  */
-static ssize_t show_mem_removable(struct sys_device *dev, char *buf)
+static ssize_t show_mem_removable(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
 {
 	unsigned long start_pfn;
 	int ret;
_

Patches currently in -mm which might be from ntl@pobox.com are

origin.patch

