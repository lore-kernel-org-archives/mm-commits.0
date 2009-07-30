From: akpm@linux-foundation.org
Subject: [merged] fs-ramfs-file-nommuc-needs-include-linux-schedh.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:22 -0700
Message-ID: <200907302037.n6UKbMhj011342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZG3Uhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/ramfs/file-nommu.c needs include/linux/sched.h
has been removed from the -mm tree.  Its filename was
     fs-ramfs-file-nommuc-needs-include-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ramfs/file-nommu.c needs include/linux/sched.h
From: Catalin Marinas <catalin.marinas@arm.com>

This file makes use of various macros defined in files like asm/current.h
or asm-generic/resource.h.  All these files can be included via sched.h. 
The building of the !MMU ARM kernel (with additional patches) fails
without this change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-needs-include-linux-schedh fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-needs-include-linux-schedh
+++ a/fs/ramfs/file-nommu.c
@@ -20,6 +20,7 @@
 #include <linux/ramfs.h>
 #include <linux/pagevec.h>
 #include <linux/mman.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include "internal.h"
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

