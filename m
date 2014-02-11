From: akpm@linux-foundation.org
Subject: + drop_caches-add-some-documentation-and-info-message.patch added to -mm tree
Date: Tue, 11 Feb 2014 13:42:01 -0800
Message-ID: <52fa9929.YVMQoScy4BVRWG40%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBKVmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 16:42:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, dave@linux.vnet.ibm.com

Subject: + drop_caches-add-some-documentation-and-info-message.patch added to -mm tree
To: dave@linux.vnet.ibm.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 13:42:01 -0800


The patch titled
     Subject: drop_caches: add some documentation and info message
has been added to the -mm tree.  Its filename is
     drop_caches-add-some-documentation-and-info-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drop_caches-add-some-documentation-and-info-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drop_caches-add-some-documentation-and-info-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: drop_caches: add some documentation and info message

There is plenty of anecdotal evidence and a load of blog posts suggesting
that using "drop_caches" periodically keeps your system running in "tip
top shape".  Perhaps adding some kernel documentation will increase the
amount of accurate data on its use.

If we are not shrinking caches effectively, then we have real bugs.  Using
drop_caches will simply mask the bugs and make them harder to find, but
certainly does not fix them, nor is it an appropriate "workaround" to
limit the size of the caches.  On the contrary, there have been bug
reports on issues that turned out to be misguided use of cache dropping.

Dropping caches is a very drastic and disruptive operation that is good
for debugging and running tests, but if it creates bug reports from
production use, kernel developers should be aware of its use.

Add a bit more documentation about it, a syslog message to track down
abusers, and vmstat drop counters to help analyze problem reports.

[akpm@linux-foundation.org: checkpatch fixes]
[hannes@cmpxchg.org: add runtime suppression control]
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt   |   33 ++++++++++++++++++++++++++------
 fs/drop_caches.c              |   16 +++++++++++++--
 include/linux/vm_event_item.h |    1 
 kernel/sysctl.c               |    4 +--
 mm/vmstat.c                   |    3 ++
 5 files changed, 47 insertions(+), 10 deletions(-)

diff -puN Documentation/sysctl/vm.txt~drop_caches-add-some-documentation-and-info-message Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~drop_caches-add-some-documentation-and-info-message
+++ a/Documentation/sysctl/vm.txt
@@ -175,18 +175,39 @@ Setting this to zero disables periodic w
 
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
+	cat (1234): drop_caches: 3
+
+These are informational only.  They do not mean that anything is wrong
+with your system.  To disable them, echo 4 (bit 3) into drop_caches.
 
 ==============================================================
 
diff -puN fs/drop_caches.c~drop_caches-add-some-documentation-and-info-message fs/drop_caches.c
--- a/fs/drop_caches.c~drop_caches-add-some-documentation-and-info-message
+++ a/fs/drop_caches.c
@@ -59,10 +59,22 @@ int drop_caches_sysctl_handler(ctl_table
 	if (ret)
 		return ret;
 	if (write) {
-		if (sysctl_drop_caches & 1)
+		static int stfu;
+
+		if (sysctl_drop_caches & 1) {
 			iterate_supers(drop_pagecache_sb, NULL);
-		if (sysctl_drop_caches & 2)
+			count_vm_event(DROP_PAGECACHE);
+		}
+		if (sysctl_drop_caches & 2) {
 			drop_slab();
+			count_vm_event(DROP_SLAB);
+		}
+		if (!stfu) {
+			pr_info("%s (%d): drop_caches: %d\n",
+				current->comm, task_pid_nr(current),
+				sysctl_drop_caches);
+		}
+		stfu |= sysctl_drop_caches & 4;
 	}
 	return 0;
 }
diff -puN include/linux/vm_event_item.h~drop_caches-add-some-documentation-and-info-message include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~drop_caches-add-some-documentation-and-info-message
+++ a/include/linux/vm_event_item.h
@@ -37,6 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		DROP_PAGECACHE, DROP_SLAB,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
 		NUMA_HUGE_PTE_UPDATES,
diff -puN kernel/sysctl.c~drop_caches-add-some-documentation-and-info-message kernel/sysctl.c
--- a/kernel/sysctl.c~drop_caches-add-some-documentation-and-info-message
+++ a/kernel/sysctl.c
@@ -126,7 +126,7 @@ static int __maybe_unused neg_one = -1;
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
-static int __maybe_unused three = 3;
+static int __maybe_unused four = 4;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 #ifdef CONFIG_PRINTK
@@ -1283,7 +1283,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
 		.extra1		= &one,
-		.extra2		= &three,
+		.extra2		= &four,
 	},
 #ifdef CONFIG_COMPACTION
 	{
diff -puN mm/vmstat.c~drop_caches-add-some-documentation-and-info-message mm/vmstat.c
--- a/mm/vmstat.c~drop_caches-add-some-documentation-and-info-message
+++ a/mm/vmstat.c
@@ -813,6 +813,9 @@ const char * const vmstat_text[] = {
 
 	"pgrotated",
 
+	"drop_pagecache",
+	"drop_slab",
+
 #ifdef CONFIG_NUMA_BALANCING
 	"numa_pte_updates",
 	"numa_huge_pte_updates",
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

drop_caches-add-some-documentation-and-info-message.patch
debugging-keep-track-of-page-owners.patch

