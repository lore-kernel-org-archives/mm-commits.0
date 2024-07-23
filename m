Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3A149C59;
	Tue, 23 Jul 2024 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778043; cv=none; b=cM2uY6/wsbc67i96QjYbL+12IXQBBeSx0VTbN/7/RAXwRWZV+vJXZgtlpuFFa93JigOUbpMUM+vT5X8lD6C/odNuT2ucOiHZ8pcPrH3kw9e/QiHc5empKu2D7iktVvXhlaDzZHw3xCZF1TMHSRi/ALrJ/YlR9bSJvyIiFJll1ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778043; c=relaxed/simple;
	bh=yogXOnZVei3qScDWNcCWXJVDUacfjuJ5ODTBn3C1/W0=;
	h=Date:To:From:Subject:Message-Id; b=TBNb+fnMgWUZ/bSNekgQSpeCJk/lX0jFEggQbHthJGfvbIjZcPX87+vgRjYYHoi4haCJy6AoeXrzMIRofrh3mMoVbTvM7o6UBYgDHHpiSHlzvbe0wXhnUWyL9XfbCBKLAiPstqepM0VsTOHrrsKIswRUbnWCOwef1RyOR2q/n+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=klIjDxWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="klIjDxWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C787C4AF0A;
	Tue, 23 Jul 2024 23:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778042;
	bh=yogXOnZVei3qScDWNcCWXJVDUacfjuJ5ODTBn3C1/W0=;
	h=Date:To:From:Subject:From;
	b=klIjDxWhohoxRWlTQM+JWFgh1qqto8U9NGyJ0wKN+IKclZb4PqZIKI/LJQ6qBDYpe
	 pRslPOVRi9tw1FDIJa2irk/BBFS5nge5Hm2tG47ATeEQkcVZYGR8DC+eyfktp6XyLS
	 56Wu/47GbebdkSq+nI+KTFh2MnuQXs73EZRADWQg=
Date: Tue, 23 Jul 2024 16:40:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-mounts-command-error.patch added to mm-nonmm-unstable branch
Message-Id: <20240723234042.9C787C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix lx-mounts command error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-mounts-command-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-mounts-command-error.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: fix lx-mounts command error
Date: Tue, 23 Jul 2024 14:48:59 +0800

(gdb) lx-mounts
      mount          super_block     devname pathname fstype options
Python Exception <class 'gdb.error'>: There is no member named list.
Error occurred in Python: There is no member named list.

We encounter the above issue after commit 2eea9ce4310d ("mounts: keep
list of mounts in an rbtree"). The commit move a mount from list into
rbtree.

So we can instead use rbtree to iterate all mounts information.

Link: https://lkml.kernel.org/r/20240723064902.124154-4-kuan-ying.lee@canonical.com
Fixes: 2eea9ce4310d ("mounts: keep list of mounts in an rbtree")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/proc.py~scripts-gdb-fix-lx-mounts-command-error
+++ a/scripts/gdb/linux/proc.py
@@ -18,6 +18,7 @@ from linux import utils
 from linux import tasks
 from linux import lists
 from linux import vfs
+from linux import rbtree
 from struct import *
 
 
@@ -172,8 +173,7 @@ values of that process namespace"""
         gdb.write("{:^18} {:^15} {:>9} {} {} options\n".format(
                   "mount", "super_block", "devname", "pathname", "fstype"))
 
-        for mnt in lists.list_for_each_entry(namespace['list'],
-                                             mount_ptr_type, "mnt_list"):
+        for mnt in rbtree.rb_inorder_for_each_entry(namespace['mounts'], mount_ptr_type, "mnt_node"):
             devname = mnt['mnt_devname'].string()
             devname = devname if devname else "none"
 
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-fix-timerlist-parsing-issue.patch
scripts-gdb-add-iteration-function-for-rbtree.patch
scripts-gdb-fix-lx-mounts-command-error.patch
scripts-gdb-add-lx-stack_depot_lookup-command.patch
scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

