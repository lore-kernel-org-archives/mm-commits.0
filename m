Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C800A14E2F5;
	Mon,  2 Sep 2024 03:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248785; cv=none; b=OA4xwx5oM75CyfB1nTCxZzFdHEy8kUqCpFLg/6ecRh6VP7J7F6p89fnclQpuh1ufxJCFa9kDJ568uHqvB9AOijEFhIPO60eYXl18jdR6dv0Jc8z2EZU61P+3T8YoExSreTZfo3rRpQjEAa5KqpqroxXU2CNjYU9Kv+lM91TyHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248785; c=relaxed/simple;
	bh=CgtmVjpY3nwg+EqiNbEYNE1YaLeowC0MurHxaKFTOOk=;
	h=Date:To:From:Subject:Message-Id; b=b0yn0gZ/ayDXz+gJyqMvnW7AMeb7OA9I7QENFCfeC/qZKCIkwS/r8is12xHYQYQat8HpiPDoRMoY40lLa2e0qLUQOAKD2Wb5FY6r/USvwc3klS5CCHOv0Q3cLS3tZem+gBMla7v54cpHUK+WEDQ+xfflBIGsZGX66K6cLo603EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2pu3HgeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2pu3HgeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97188C4CED0;
	Mon,  2 Sep 2024 03:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248785;
	bh=CgtmVjpY3nwg+EqiNbEYNE1YaLeowC0MurHxaKFTOOk=;
	h=Date:To:From:Subject:From;
	b=2pu3HgeB1AKyN9NGUFRdAfGf+CD9kfrZ9pRNBbrOoXyOYTdLLGJ/OFZzLQyRjOGn2
	 hoZ9sZEbXQfEhP0jUJk7QoLL39X5vDLqr1M27G0WR1BMgWr6LbNEce/lxogkVcQ08Y
	 +9jRCkdmRV8EH3Ht5QAAxSXVMHrL2oxs1ilTOoz8=
Date: Sun, 01 Sep 2024 20:46:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-mounts-command-error.patch removed from -mm tree
Message-Id: <20240902034625.97188C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix lx-mounts command error
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-mounts-command-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


