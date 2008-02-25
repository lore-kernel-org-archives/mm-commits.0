From: akpm@linux-foundation.org
Subject: - cgroup-fix-memory-leak-in-cgroup_get_sb.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:56 -0800
Message-ID: <200802250045.m1P0juJj006294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbYBYAst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix memory leak in cgroup_get_sb()
has been removed from the -mm tree.  Its filename was
     cgroup-fix-memory-leak-in-cgroup_get_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix memory leak in cgroup_get_sb()
From: Li Zefan <lizf@cn.fujitsu.com>

opts.release_agent is not kfree()ed in all necessary places.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-fix-memory-leak-in-cgroup_get_sb kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-memory-leak-in-cgroup_get_sb
+++ a/kernel/cgroup.c
@@ -954,8 +954,11 @@ static int cgroup_get_sb(struct file_sys
 	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
-	if (!root)
+	if (!root) {
+		if (opts.release_agent)
+			kfree(opts.release_agent);
 		return -ENOMEM;
+	}
 
 	init_cgroup_root(root);
 	root->subsys_bits = opts.subsys_bits;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are
