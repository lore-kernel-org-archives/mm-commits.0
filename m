From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:23 -0700
Message-ID: <20120608194123.62256A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:51533 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2FHTlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:25 -0400
Received: by bkty5 with SMTP id y5so124821bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: add minimal address test to PR_SET_MM
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: add minimal address test to PR_SET_MM

Make sure the address being set is greater than mmap_min_addr (as
suggested by Kees Cook).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm
+++ a/kernel/sys.c
@@ -1869,7 +1869,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE)
+	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-fcntl-add-f_getowner_uids-option.patch

