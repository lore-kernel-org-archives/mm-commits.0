From: akpm@linux-foundation.org
Subject: + cgroup-fix-default-notify_on_release-setting.patch added to -mm tree
Date: Sun, 24 Feb 2008 23:17:16 -0800
Message-ID: <200802250717.m1P7HG7Q019571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYBYHSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 02:18:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: fix default notify_on_release setting
has been added to the -mm tree.  Its filename is
     cgroup-fix-default-notify_on_release-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix default notify_on_release setting
From: Li Zefan <lizf@cn.fujitsu.com>

The documentation says the default value of notify_on_release of a child
cgroup is inherited from its parent, which is reasonable, but the
implementation just sets the flag disabled.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-fix-default-notify_on_release-setting kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-default-notify_on_release-setting
+++ a/kernel/cgroup.c
@@ -2232,7 +2232,6 @@ static long cgroup_create(struct cgroup 
 
 	mutex_lock(&cgroup_mutex);
 
-	cgrp->flags = 0;
 	INIT_LIST_HEAD(&cgrp->sibling);
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->css_sets);
@@ -2242,6 +2241,9 @@ static long cgroup_create(struct cgroup 
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
 
+	if (notify_on_release(parent))
+		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
 		if (IS_ERR(css)) {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-fix-default-notify_on_release-setting.patch
