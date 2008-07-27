From: akpm@linux-foundation.org
Subject: + drivers-base-memoryc-fix-fallout-from-sysdev-api-changes.patch added to -mm tree
Date: Sat, 26 Jul 2008 23:29:21 -0700
Message-ID: <200807270629.m6R6TLtE006287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757641AbYG0GaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 02:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntl@pobox.com, andi@firstfloor.org, pbadari@us.ibm.com


The patch titled
     drivers/base/memory.c: fix fallout from sysdev API changes
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-fix-fallout-from-sysdev-api-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-base-memoryc-fix-fallout-from-sysdev-api-changes.patch

