From: akpm@linux-foundation.org
Subject: + hugetlb_file_setup-use-c-not-cpp.patch added to -mm tree
Date: Tue, 22 Sep 2009 15:45:57 -0700
Message-ID: <200909222308.n8MN8Mp4005807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbZIVXIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 19:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agl@us.ibm.com, apw@canonical.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com


The patch titled
     hugetlb_file_setup(): use C, not cpp
has been added to the -mm tree.  Its filename is
     hugetlb_file_setup-use-c-not-cpp.patch

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
Subject: hugetlb_file_setup(): use C, not cpp
From: Andrew Morton <akpm@linux-foundation.org>

why macros are always wrong:

mm/mmap.c: In function 'do_mmap_pgoff':
mm/mmap.c:953: warning: unused variable 'user'

also, move a couple of struct forward-decls outside `#ifdef
CONFIG_HUGETLB_PAGE' - it's pointless and frequently harmful to make these
conditional (eg, this patch needed `struct user_struct').

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb_file_setup-use-c-not-cpp fs/hugetlbfs/inode.c
diff -puN include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp
+++ a/include/linux/hugetlb.h
@@ -3,15 +3,15 @@
 
 #include <linux/fs.h>
 
+struct ctl_table;
+struct user_struct;
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
 
-struct ctl_table;
-struct user_struct;
-
 int PageHuge(struct page *page);
 
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
@@ -187,7 +187,11 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acct,user,creat)	ERR_PTR(-ENOSYS)
+static inline struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
+				struct user_struct **user, int creat_flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
 
 #endif /* !CONFIG_HUGETLBFS */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-kmemcheckh-fix-a-trillion-warnings.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking.patch
hugetlb_file_setup-use-c-not-cpp.patch

