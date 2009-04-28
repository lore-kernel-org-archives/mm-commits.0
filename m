From: akpm@linux-foundation.org
Subject: + cgroups-make-messages-more-readable.patch added to -mm tree
Date: Tue, 28 Apr 2009 15:22:40 -0700
Message-ID: <200904282222.n3SMMeB2016513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZD1WZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 18:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: make messages more readable
has been added to the -mm tree.  Its filename is
     cgroups-make-messages-more-readable.patch

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
@@ -1522,6 +1522,7 @@ L:	containers@lists.linux-foundation.org
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
+F:	mm/*cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
diff -puN mm/page_cgroup.c~cgroups-make-messages-more-readable mm/page_cgroup.c
--- a/mm/page_cgroup.c~cgroups-make-messages-more-readable
+++ a/mm/page_cgroup.c
@@ -83,12 +83,12 @@ void __init page_cgroup_init(void)
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
 
@@ -257,14 +257,14 @@ void __init page_cgroup_init(void)
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
ecryptfs-fix-printk-format-warning.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

