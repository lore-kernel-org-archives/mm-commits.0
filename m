From: akpm@linux-foundation.org
Subject: - uml-boot-broken-due-to-buffer-overrun.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:28:32 -0800
Message-ID: <200812101928.mBAJSWPk021209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274AbYLJT3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, jdike@addtoit.com, penberg@cs.helsinki.fi, skldas@gmail.com, stable@kernel.org, vikki.km@gmail.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: boot broken due to buffer overrun
has been removed from the -mm tree.  Its filename was
     uml-boot-broken-due-to-buffer-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch

