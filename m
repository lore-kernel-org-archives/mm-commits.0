From: akpm@linux-foundation.org
Subject: - cgroup-annotate-cgroup_init_subsys-with-__init.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:35 -0700
Message-ID: <200804300542.m3U5gZxu029159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575AbYD3FnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: annotate cgroup_init_subsys with __init
has been removed from the -mm tree.  Its filename was
     cgroup-annotate-cgroup_init_subsys-with-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: annotate cgroup_init_subsys with __init
From: Li Zefan <lizf@cn.fujitsu.com>

It is called by cgroup_init() and cgroup_init_early() only, which are
annotated with __init.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-annotate-cgroup_init_subsys-with-__init kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-annotate-cgroup_init_subsys-with-__init
+++ a/kernel/cgroup.c
@@ -2444,7 +2444,7 @@ static int cgroup_rmdir(struct inode *un
 	return 0;
 }
 
-static void cgroup_init_subsys(struct cgroup_subsys *ss)
+static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
 	struct list_head *l;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-acpi.patch

