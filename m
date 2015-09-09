From: akpm@linux-foundation.org
Subject: [merged] cgroup-fix-seq_show_option-merge-with-legacy_name.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:42:35 -0700
Message-ID: <55f08bab.CMuF3yW8RZHxnLhE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: fix seq_show_option merge with legacy_name
has been removed from the -mm tree.  Its filename was
     cgroup-fix-seq_show_option-merge-with-legacy_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: cgroup: fix seq_show_option merge with legacy_name

When seq_show_option (068acf2ee776) was merged, it did not correctly
collide with cgroup's addition of legacy_name (3e1d2eed39d8) changes. 
This fixes the reported name.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-fix-seq_show_option-merge-with-legacy_name kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-seq_show_option-merge-with-legacy_name
+++ a/kernel/cgroup.c
@@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct se
 	if (root != &cgrp_dfl_root)
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
-				seq_show_option(seq, ss->name, NULL);
+				seq_show_option(seq, ss->legacy_name, NULL);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch
lib-string_helpers-rename-esc-arg-to-only.patch

