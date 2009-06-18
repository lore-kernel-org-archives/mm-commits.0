From: akpm@linux-foundation.org
Subject: [merged] memcg-add-interface-to-reset-limits.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:11 -0700
Message-ID: <200906182246.n5IMkBRn005264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758553AbZFRWqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: add interface to reset limits
has been removed from the -mm tree.  Its filename was
     memcg-add-interface-to-reset-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add interface to reset limits
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

We don't have an interface to reset mem.limit or memsw.limit now.

This patch allows to reset mem.limit or memsw.limit when they are being
set to -1.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    1 +
 include/linux/res_counter.h      |    2 ++
 kernel/res_counter.c             |   12 +++++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-interface-to-reset-limits Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-interface-to-reset-limits
+++ a/Documentation/cgroups/memory.txt
@@ -209,6 +209,7 @@ We can alter the memory limit:
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
+NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
 
 # cat /cgroups/0/memory.limit_in_bytes
 4194304
diff -puN include/linux/res_counter.h~memcg-add-interface-to-reset-limits include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-add-interface-to-reset-limits
+++ a/include/linux/res_counter.h
@@ -49,6 +49,8 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
+#define RESOURCE_MAX (unsigned long long)LLONG_MAX
+
 /**
  * Helpers to interact with userspace
  * res_counter_read_u64() - returns the value of the specified member.
diff -puN kernel/res_counter.c~memcg-add-interface-to-reset-limits kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-add-interface-to-reset-limits
+++ a/kernel/res_counter.c
@@ -18,7 +18,7 @@
 void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
-	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->limit = RESOURCE_MAX;
 	counter->parent = parent;
 }
 
@@ -133,6 +133,16 @@ int res_counter_memparse_write_strategy(
 					unsigned long long *res)
 {
 	char *end;
+
+	/* return RESOURCE_MAX(unlimited) if "-1" is specified */
+	if (*buf == '-') {
+		*res = simple_strtoull(buf + 1, &end, 10);
+		if (*res != 1 || *end != '\0')
+			return -EINVAL;
+		*res = RESOURCE_MAX;
+		return 0;
+	}
+
 	/* FIXME - make memparse() take const char* args */
 	*res = memparse((char *)buf, &end);
 	if (*end != '\0')
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

