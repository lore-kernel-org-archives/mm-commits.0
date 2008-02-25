From: akpm@linux-foundation.org
Subject: - cgroup-fix-subsys-bitops.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:58 -0800
Message-ID: <200802250045.m1P0jwOf006297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbYBYAsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix subsys bitops
has been removed from the -mm tree.  Its filename was
     cgroup-fix-subsys-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix subsys bitops
From: Li Zefan <lizf@cn.fujitsu.com>

Cgroup uses unsigned long for subsys bitops, not unsigned long long.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-subsys-bitops kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-subsys-bitops
+++ a/kernel/cgroup.c
@@ -319,7 +319,7 @@ static struct css_set *find_existing_css
 	/* Built the set of subsystem state objects that we want to
 	 * see in the new css_set */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		if (root->subsys_bits & (1ull << i)) {
+		if (root->subsys_bits & (1UL << i)) {
 			/* Subsystem is in this hierarchy. So we want
 			 * the subsystem state from the new
 			 * cgroup */
@@ -689,7 +689,7 @@ static int rebind_subsystems(struct cgro
 	added_bits = final_bits & ~root->actual_subsys_bits;
 	/* Check that any added subsystems are currently free */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		unsigned long long bit = 1ull << i;
+		unsigned long bit = 1UL << i;
 		struct cgroup_subsys *ss = subsys[i];
 		if (!(bit & added_bits))
 			continue;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are
