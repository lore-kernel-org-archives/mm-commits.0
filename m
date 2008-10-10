From: akpm@linux-foundation.org
Subject: + memory_probe-fix-wrong-sysfs-file-attribute.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:04:25 -0700
Message-ID: <200810102004.m9AK4PNo029229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761352AbYJJUFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:05:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, randy.dunlap@oracle.com


The patch titled
     memory_probe: fix wrong sysfs file attribute
has been added to the -mm tree.  Its filename is
     memory_probe-fix-wrong-sysfs-file-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_probe: fix wrong sysfs file attribute
From: Shaohua Li <shaohua.li@intel.com>

This attribute just has a write operation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute drivers/base/memory.c
--- a/drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute
+++ a/drivers/base/memory.c
@@ -325,7 +325,7 @@ memory_probe_store(struct class *class, 
 
 	return count;
 }
-static CLASS_ATTR(probe, 0700, NULL, memory_probe_store);
+static CLASS_ATTR(probe, 0200, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
_

Patches currently in -mm which might be from shaohua.li@intel.com are

git-tip.patch
git-acpi.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch

