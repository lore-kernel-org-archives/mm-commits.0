From: akpm@linux-foundation.org
Subject: + topology-fix-sparc64-build.patch added to -mm tree
Date: Wed, 07 Jan 2009 15:39:09 -0800
Message-ID: <200901072339.n07Nd9Zd019672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbZAGXjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:39:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net


The patch titled
     topology: Fix sparc64 build
has been added to the -mm tree.  Its filename is
     topology-fix-sparc64-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: topology: Fix sparc64 build
From: David Miller <davem@davemloft.net>

Due to changeset ba84be2338d3a2b6020d39279335bb06fcd332e1
("remove linux/hardirq.h from asm-generic/local.h") the
sparc64 build started failing on drivers/base/topology.c:

drivers/base/topology.c: In function `show_physical_package_id':
drivers/base/topology.c:103: error: implicit declaration of function `cpu_data'
drivers/base/topology.c:103: error: request for member `proc_id' in something not a structure or union
drivers/base/topology.c: In function `show_core_id':
drivers/base/topology.c:106: error: request for member `core_id' in something not a structure or union

Adding the obvious fix of including asm/cpudata.h into
asm/topology.h on sparc64 doesn't fix it, in fact it
makes things worse because of the header file dependency
chain:

	linux/gfp.h --> linux/mmzone.h --> linux/topology.h -->
	asm/topology.h --> asm/cpudata.h --> linux/percpu.h -->
	linux/slab.h

which results in:

include/linux/slub_def.h: In function `kmalloc_large':
include/linux/slub_def.h:209: error: implicit declaration of function `__get_free_pages'
include/linux/slub_def.h:209: error: `__GFP_COMP' undeclared (first use in this function)
include/linux/slub_def.h:209: error: (Each undeclared identifier is reported only once
include/linux/slub_def.h:209: error: for each function it appears in.)
include/linux/slub_def.h:209: warning: cast to pointer from integer of different size

The simplest thing to do is to add yet another one-off hack like
parts of the guilty changeset did, by putting an explicit
linux/hardirq.h include into drivers/base/topology.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/topology.c~topology-fix-sparc64-build drivers/base/topology.c
--- a/drivers/base/topology.c~topology-fix-sparc64-build
+++ a/drivers/base/topology.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <linux/topology.h>
 
 #define define_one_ro(_name) 		\
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
remove-lots-of-double-semicolons.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
topology-fix-sparc64-build.patch

