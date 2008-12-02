From: akpm@linux-foundation.org
Subject: + uml-boot-broken-due-to-buffer-overrun.patch added to -mm tree
Date: Tue, 02 Dec 2008 12:17:12 -0800
Message-ID: <200812022017.mB2KHCAi029678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbYLBURd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 15:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, jdike@addtoit.com, penberg@cs.helsinki.fi, skldas@gmail.com, stable@kernel.org, vikki.km@gmail.com, wangcong@zeuux.org


The patch titled
     uml: boot broken due to buffer overrun
has been added to the -mm tree.  Its filename is
     uml-boot-broken-due-to-buffer-overrun.patch

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
Subject: uml: boot broken due to buffer overrun
From: Balbir Singh <balbir@linux.vnet.ibm.com>

mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
a big overrun bug reported on UML bootup.

sockaddr_un.sun_path is UNIX_PATH_MAX long which causes the problem.
Reported-by: Vikas K Managutte <vikki.km@gmail.com>
Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>		[please check with Jeff]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-boot-broken-due-to-buffer-overrun arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-boot-broken-due-to-buffer-overrun
+++ a/arch/um/drivers/mconsole_kern.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/utsname.h>
+#include <linux/socket.h>
+#include <linux/un.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -785,7 +787,7 @@ static int __init mconsole_init(void)
 	/* long to avoid size mismatch warnings from gcc */
 	long sock;
 	int err;
-	char file[256];
+	char file[UNIX_PATH_MAX];
 
 	if (umid_file_name("mconsole", file, sizeof(file)))
 		return -1;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

uml-boot-broken-due-to-buffer-overrun.patch
linux-next.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

