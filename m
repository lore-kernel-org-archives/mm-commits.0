From: akpm@linux-foundation.org
Subject: + hugetlb-fix-config_sysctl=n-build.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:29:27 -0700
Message-ID: <200807252129.m6PLTRLl032067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYGYVaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu


The patch titled
     hugetlb: fix CONFIG_SYSCTL=n build
has been added to the -mm tree.  Its filename is
     hugetlb-fix-config_sysctl=n-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix CONFIG_SYSCTL=n build
From: Nishanth Aravamudan <nacc@us.ibm.com>

Fixes a build failure reported by Alan Cox:

mm/hugetlb.c: In function `hugetlb_acct_memory': mm/hugetlb.c:1507:
error: implicit declaration of function `cpuset_mems_nr'

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build
+++ a/mm/hugetlb.c
@@ -1026,7 +1026,6 @@ static void __init report_hugepages(void
 	}
 }
 
-#ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
 {
@@ -1386,6 +1385,7 @@ static unsigned int cpuset_mems_nr(unsig
 	return nr;
 }
 
+#ifdef CONFIG_SYSCTL
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
hugetlb-fix-config_sysctl=n-build.patch

