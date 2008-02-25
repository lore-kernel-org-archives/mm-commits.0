From: akpm@linux-foundation.org
Subject: - cgroup-remove-duplicate-code-in-find_css_set.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:46:00 -0800
Message-ID: <200802250046.m1P0k0X2006300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbYBYAss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: remove duplicate code in find_css_set()
has been removed from the -mm tree.  Its filename was
     cgroup-remove-duplicate-code-in-find_css_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: remove duplicate code in find_css_set()
From: Li Zefan <lizf@cn.fujitsu.com>

The list head res->tasks gets initialized twice in find_css_set().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-remove-duplicate-code-in-find_css_set kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-duplicate-code-in-find_css_set
+++ a/kernel/cgroup.c
@@ -470,7 +470,6 @@ static struct css_set *find_css_set(
 	/* Link this cgroup group into the list */
 	list_add(&res->list, &init_css_set.list);
 	css_set_count++;
-	INIT_LIST_HEAD(&res->tasks);
 	write_unlock(&css_set_lock);
 
 	return res;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are
