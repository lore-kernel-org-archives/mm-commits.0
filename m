From: akpm@linux-foundation.org
Subject: + coredump_filter-permit-changing-of-the-default-filter.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:07:35 -0800
Message-ID: <200812302307.mBUN7ZUk017152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbYL3XI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, kosaki.motohiro@jp.fujitsu.com, roland@redhat.com


The patch titled
     coredump_filter: permit changing of the default filter
has been added to the -mm tree.  Its filename is
     coredump_filter-permit-changing-of-the-default-filter.patch

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
Subject: coredump_filter: permit changing of the default filter
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

Introduce a new kernel parameter `coredump_filter'.  Setting a value to
this parameter causes the default bitmask of coredump_filter to be
changed.

It is useful for users to change coredump_filter settings for the whole
system at boot time.  Without this parameter, users have to change
coredump_filter settings for each /proc/<pid>/ in an initializing script.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 kernel/fork.c                       |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~coredump_filter-permit-changing-of-the-default-filter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~coredump_filter-permit-changing-of-the-default-filter
+++ a/Documentation/kernel-parameters.txt
@@ -556,6 +556,11 @@ and is between 256 and 4096 characters. 
 			not work reliably with all consoles, but is known
 			to work with serial and VGA consoles.
 
+	coredump_filter=
+			[KNL] Change the default value for
+			/proc/<pid>/coredump_filter.
+			See also Documentation/filesystems/proc.txt.
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
diff -puN kernel/fork.c~coredump_filter-permit-changing-of-the-default-filter kernel/fork.c
--- a/kernel/fork.c~coredump_filter-permit-changing-of-the-default-filter
+++ a/kernel/fork.c
@@ -405,6 +405,18 @@ __cacheline_aligned_in_smp DEFINE_SPINLO
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
 
+static unsigned long default_dump_filter = MMF_DUMP_FILTER_DEFAULT;
+
+static int __init coredump_filter_setup(char *s)
+{
+	default_dump_filter =
+		(simple_strtoul(s, NULL, 0) << MMF_DUMP_FILTER_SHIFT) &
+		MMF_DUMP_FILTER_MASK;
+	return 1;
+}
+
+__setup("coredump_filter=", coredump_filter_setup);
+
 #include <linux/init_task.h>
 
 static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
@@ -413,8 +425,7 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
-	mm->flags = (current->mm) ? current->mm->flags
-				  : MMF_DUMP_FILTER_DEFAULT;
+	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump_filter-permit-changing-of-the-default-filter.patch

