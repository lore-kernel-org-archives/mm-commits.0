From: akpm@linux-foundation.org
Subject: [merged] cgroups-make-messages-more-readable.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:15 -0700
Message-ID: <200906182245.n5IMjFOB004286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758127AbZFRW57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: make messages more readable
has been removed from the -mm tree.  Its filename was
     cgroups-make-messages-more-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make messages more readable
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix some cgroup messages to read better.
Update MAINTAINERS to include mm/*cgroup* files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS      |    1 +
 mm/page_cgroup.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN MAINTAINERS~cgroups-make-messages-more-readable MAINTAINERS
--- a/MAINTAINERS~cgroups-make-messages-more-readable
+++ a/MAINTAINERS
@@ -1544,6 +1544,7 @@ L:	containers@lists.linux-foundation.org
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
+F:	mm/*cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
diff -puN mm/page_cgroup.c~cgroups-make-messages-more-readable mm/page_cgroup.c
--- a/mm/page_cgroup.c~cgroups-make-messages-more-readable
+++ a/mm/page_cgroup.c
@@ -83,12 +83,12 @@ void __init page_cgroup_init_flatmem(voi
 			goto fail;
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try cgroup_disable=memory option if you"
-	" don't want\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
+	" don't want memory cgroups\n");
 	return;
 fail:
-	printk(KERN_CRIT "allocation of page_cgroup was failed.\n");
-	printk(KERN_CRIT "please try cgroup_disable=memory boot option\n");
+	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
+	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
 	panic("Out of memory");
 }
 
@@ -252,14 +252,14 @@ void __init page_cgroup_init(void)
 		fail = init_section_page_cgroup(pfn);
 	}
 	if (fail) {
-		printk(KERN_CRIT "try cgroup_disable=memory boot option\n");
+		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
 		panic("Out of memory");
 	} else {
 		hotplug_memory_notifier(page_cgroup_callback, 0);
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try cgroup_disable=memory option if you don't"
-	" want\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
+	" want memory cgroups\n");
 }
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
reiser4-export-remove_from_page_cache-fix.patch

