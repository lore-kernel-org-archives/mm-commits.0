From: akpm@linux-foundation.org
Subject: + mm-use-the-same-log-level-for-show_mem.patch added to -mm tree
Date: Tue, 02 Mar 2010 16:11:20 -0800
Message-ID: <201003030011.o230BKhf006398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab0CCAMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com


The patch titled
     mm: use the same log level for show_mem()
has been added to the -mm tree.  Its filename is
     mm-use-the-same-log-level-for-show_mem.patch

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
Subject: mm: use the same log level for show_mem()
From: Amerigo Wang <amwang@redhat.com>

Use the same log level for printk's in show_mem(), so that those messages
can be shown completely when using log level 6.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/show_mem.c~mm-use-the-same-log-level-for-show_mem lib/show_mem.c
--- a/lib/show_mem.c~mm-use-the-same-log-level-for-show_mem
+++ a/lib/show_mem.c
@@ -15,7 +15,7 @@ void show_mem(void)
 	unsigned long total = 0, reserved = 0, shared = 0,
 		nonshared = 0, highmem = 0;
 
-	printk(KERN_INFO "Mem-Info:\n");
+	printk("Mem-Info:\n");
 	show_free_areas();
 
 	for_each_online_pgdat(pgdat) {
@@ -49,15 +49,15 @@ void show_mem(void)
 		pgdat_resize_unlock(pgdat, &flags);
 	}
 
-	printk(KERN_INFO "%lu pages RAM\n", total);
+	printk("%lu pages RAM\n", total);
 #ifdef CONFIG_HIGHMEM
-	printk(KERN_INFO "%lu pages HighMem\n", highmem);
+	printk("%lu pages HighMem\n", highmem);
 #endif
-	printk(KERN_INFO "%lu pages reserved\n", reserved);
-	printk(KERN_INFO "%lu pages shared\n", shared);
-	printk(KERN_INFO "%lu pages non-shared\n", nonshared);
+	printk("%lu pages reserved\n", reserved);
+	printk("%lu pages shared\n", shared);
+	printk("%lu pages non-shared\n", nonshared);
 #ifdef CONFIG_QUICKLIST
-	printk(KERN_INFO "%lu pages in pagetable cache\n",
+	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
 #endif
 }
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
scripts-improve-checkstack.patch
checkincludes-fix-perlcritic-warnings.patch
checkversion-perl-cleanup.patch
namespace-perlcritic-warnings.patch
profile2linkerlist-fix-perl-warnings.patch
export_report-fix-perl-warnings.patch
headers_check-fix-perl-warnings.patch
headers_install-use-local-file-handles.patch
markup_oops-fix-perlcritic-warnings.patch
headerdep-perlcritic-warning.patch
mm-use-the-same-log-level-for-show_mem.patch
fs-compat_ioctlc-suppress-two-warnings.patch
console-limit-the-range-of-vgacon_soft_scrollback_size.patch

