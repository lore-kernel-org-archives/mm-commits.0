From: akpm@linux-foundation.org
Subject: + cgroup-alloc_css_id-increments-hierarchy-depth.patch added to -mm tree
Date: Wed, 02 Jun 2010 11:56:28 -0700
Message-ID: <201006021856.o52IuSsa010740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758531Ab0FBS5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 14:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, stable@kernel.org


The patch titled
     cgroups: alloc_css_id() increments hierarchy depth
has been added to the -mm tree.  Its filename is
     cgroup-alloc_css_id-increments-hierarchy-depth.patch

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
Subject: cgroups: alloc_css_id() increments hierarchy depth
From: Greg Thelen <gthelen@google.com>

Child groups should have a greater depth than their parents.  Prior to
this change, the parent would incorrectly report zero memory usage for
child cgroups when use_hierarchy is enabled.

test script:
  mount -t cgroup none /cgroups -o memory
  cd /cgroups
  mkdir cg1

  echo 1 > cg1/memory.use_hierarchy
  mkdir cg1/cg11

  echo $$ > cg1/cg11/tasks
  dd if=/dev/zero of=/tmp/foo bs=1M count=1

  echo
  echo CHILD
  grep cache cg1/cg11/memory.stat

  echo
  echo PARENT
  grep cache cg1/memory.stat

  echo $$ > tasks
  rmdir cg1/cg11 cg1
  cd /
  umount /cgroups

Using fae9c79, a recent patch that changed alloc_css_id() depth computation,
the parent incorrectly reports zero usage:
  root@ubuntu:~# ./test
  1+0 records in
  1+0 records out
  1048576 bytes (1.0 MB) copied, 0.0151844 s, 69.1 MB/s

  CHILD
  cache 1048576
  total_cache 1048576

  PARENT
  cache 0
  total_cache 0

With this patch, the parent correctly includes child usage:
  root@ubuntu:~# ./test
  1+0 records in
  1+0 records out
  1048576 bytes (1.0 MB) copied, 0.0136827 s, 76.6 MB/s

  CHILD
  cache 1052672
  total_cache 1052672

  PARENT
  cache 0
  total_cache 1052672

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.34.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-alloc_css_id-increments-hierarchy-depth kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-alloc_css_id-increments-hierarchy-depth
+++ a/kernel/cgroup.c
@@ -4598,7 +4598,7 @@ static int alloc_css_id(struct cgroup_su
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
 	parent_id = parent_css->id;
-	depth = parent_id->depth;
+	depth = parent_id->depth + 1;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
cgroup-alloc_css_id-increments-hierarchy-depth.patch

