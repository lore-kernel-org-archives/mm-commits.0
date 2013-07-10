From: akpm@linux-foundation.org
Subject: [-] drop_caches-add-some-documentation-and-info-messsge.patch
 removed from -mm tree
Date: Wed, 10 Jul 2013 13:25:03 -0700
Message-ID: <51ddc31f.zotz9WDKK3lWXtDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJUZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 16:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com, mhocko@suse.cz

Subject: [-] drop_caches-add-some-documentation-and-info-messsge.patch removed from -mm tree
To: mhocko@suse.cz,dave@linux.vnet.ibm.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 13:25:03 -0700


The patch titled
     Subject: drop_caches: add some documentation and info message
has been removed from the -mm tree.  Its filename was
     drop_caches-add-some-documentation-and-info-messsge.patch

This patch was dropped because it has gone stale

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: drop_caches: add some documentation and info message

I would like to resurrect Dave's patch.  The last time it was posted was
here https://lkml.org/lkml/2010/9/16/250 and there didn't seem to be any
strong opposition.

Kosaki was worried about possible excessive logging when somebody drops
caches too often (but then he claimed he didn't have a strong opinion on
that) but I would say opposite.  If somebody does that then I would really
like to know that from the log when supporting a system because it almost
for sure means that there is something fishy going on.  It is also worth
mentioning that only root can write drop caches so this is not an flooding
attack vector.

I am bringing that up again because this can be really helpful when
chasing strange performance issues which (surprise surprise) turn out to
be related to artificially dropped caches done because the admin thinks
this would help...

I have just refreshed the original patch on top of the current mm tree
but I could live with KERN_INFO as well if people think that KERN_NOTICE
is too hysterical.

: From: Dave Hansen <dave@linux.vnet.ibm.com>
: Date: Fri, 12 Oct 2012 14:30:54 +0200
: 
: There is plenty of anecdotal evidence and a load of blog posts
: suggesting that using "drop_caches" periodically keeps your system
: running in "tip top shape".  Perhaps adding some kernel
: documentation will increase the amount of accurate data on its use.
: 
: If we are not shrinking caches effectively, then we have real bugs.
: Using drop_caches will simply mask the bugs and make them harder
: to find, but certainly does not fix them, nor is it an appropriate
: "workaround" to limit the size of the caches.
: 
: It's a great debugging tool, and is really handy for doing things
: like repeatable benchmark runs.  So, add a bit more documentation
: about it, and add a little KERN_NOTICE.  It should help developers
: who are chasing down reclaim-related bugs.

[mhocko@suse.cz: refreshed to current -mm tree]
[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   33 +++++++++++++++++++++++++++------
 fs/drop_caches.c            |    2 ++
 2 files changed, 29 insertions(+), 6 deletions(-)

diff -puN Documentation/sysctl/vm.txt~drop_caches-add-some-documentation-and-info-messsge Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~drop_caches-add-some-documentation-and-info-messsge
+++ a/Documentation/sysctl/vm.txt
@@ -169,18 +169,39 @@ Setting this to zero disables periodic w
 
 drop_caches
 
-Writing to this will cause the kernel to drop clean caches, dentries and
-inodes from memory, causing that memory to become free.
+Writing to this will cause the kernel to drop clean caches, as well as
+reclaimable slab objects like dentries and inodes.  Once dropped, their
+memory becomes free.
 
 To free pagecache:
 	echo 1 > /proc/sys/vm/drop_caches
-To free dentries and inodes:
+To free reclaimable slab objects (includes dentries and inodes):
 	echo 2 > /proc/sys/vm/drop_caches
-To free pagecache, dentries and inodes:
+To free slab objects and pagecache:
 	echo 3 > /proc/sys/vm/drop_caches
 
-As this is a non-destructive operation and dirty objects are not freeable, the
-user should run `sync' first.
+This is a non-destructive operation and will not free any dirty objects.
+To increase the number of objects freed by this operation, the user may run
+`sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
+number of dirty objects on the system and create more candidates to be
+dropped.
+
+This file is not a means to control the growth of the various kernel caches
+(inodes, dentries, pagecache, etc...)  These objects are automatically
+reclaimed by the kernel when memory is needed elsewhere on the system.
+
+Use of this file can cause performance problems.  Since it discards cached
+objects, it may cost a significant amount of I/O and CPU to recreate the
+dropped objects, especially if they were under heavy use.  Because of this,
+use outside of a testing or debugging environment is not recommended.
+
+You may see informational messages in your kernel log when this file is
+used:
+
+	cat (1234): dropped kernel caches: 3
+
+These are informational only.  They do not mean that anything is wrong
+with your system.
 
 ==============================================================
 
diff -puN fs/drop_caches.c~drop_caches-add-some-documentation-and-info-messsge fs/drop_caches.c
--- a/fs/drop_caches.c~drop_caches-add-some-documentation-and-info-messsge
+++ a/fs/drop_caches.c
@@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table
 	if (ret)
 		return ret;
 	if (write) {
+		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
+		       current->comm, task_pid_nr(current), sysctl_drop_caches);
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
 		if (sysctl_drop_caches & 2)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch

