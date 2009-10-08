From: akpm@linux-foundation.org
Subject: + cgroup-fix-strstrip-misuse.patch added to -mm tree
Date: Thu, 08 Oct 2009 16:04:45 -0700
Message-ID: <200910082304.n98N4jQ0015824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660AbZJHXGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 19:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: fix strstrip() misuse
has been added to the -mm tree.  Its filename is
     cgroup-fix-strstrip-misuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix strstrip() misuse
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

cgroup_write_X64() and cgroup_write_string() ignore the return value of
strstrip().  it makes small inconsistent behavior.

example:
=========================
 # cd /mnt/cgroup/hoge
 # cat memory.swappiness
 60
 # echo "59 " > memory.swappiness
 # cat memory.swappiness
 59
 # echo " 58" > memory.swappiness
 bash: echo: write error: Invalid argument

This patch fixes it.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/cgroup.c~cgroup-fix-strstrip-misuse kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-strstrip-misuse
+++ a/kernel/cgroup.c
@@ -1710,14 +1710,13 @@ static ssize_t cgroup_write_X64(struct c
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-	strstrip(buffer);
 	if (cft->write_u64) {
-		u64 val = simple_strtoull(buffer, &end, 0);
+		u64 val = simple_strtoull(strstrip(buffer), &end, 0);
 		if (*end)
 			return -EINVAL;
 		retval = cft->write_u64(cgrp, cft, val);
 	} else {
-		s64 val = simple_strtoll(buffer, &end, 0);
+		s64 val = simple_strtoll(strstrip(buffer), &end, 0);
 		if (*end)
 			return -EINVAL;
 		retval = cft->write_s64(cgrp, cft, val);
@@ -1753,8 +1752,7 @@ static ssize_t cgroup_write_string(struc
 	}
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-	strstrip(buffer);
-	retval = cft->write_string(cgrp, cft, buffer);
+	retval = cft->write_string(cgrp, cft, strstrip(buffer));
 	if (!retval)
 		retval = nbytes;
 out:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
congestion_wait-dont-use-write.patch
elv_iosched_store-fix-strstrip-misuse.patch
cgroup-fix-strstrip-misuse.patch
strstrip-mark-as-as-must_check.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

