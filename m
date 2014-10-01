From: akpm@linux-foundation.org
Subject: + mm-ksm-use-pr_err-instead-of-printk.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:51:10 -0700
Message-ID: <542c693e.pTFsvw1dm5xDSN5q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaJAUvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksm use pr_err instead of printk
has been added to the -mm tree.  Its filename is
     mm-ksm-use-pr_err-instead-of-printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-use-pr_err-instead-of-printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-use-pr_err-instead-of-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: mm: ksm use pr_err instead of printk

WARNING: Prefer: pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~mm-ksm-use-pr_err-instead-of-printk mm/ksm.c
--- a/mm/ksm.c~mm-ksm-use-pr_err-instead-of-printk
+++ a/mm/ksm.c
@@ -2310,7 +2310,7 @@ static int __init ksm_init(void)
 
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
-		printk(KERN_ERR "ksm: creating kthread failed\n");
+		pr_err(KERN_ERR "ksm: creating kthread failed\n");
 		err = PTR_ERR(ksm_thread);
 		goto out_free;
 	}
@@ -2318,7 +2318,7 @@ static int __init ksm_init(void)
 #ifdef CONFIG_SYSFS
 	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
 	if (err) {
-		printk(KERN_ERR "ksm: register sysfs failed\n");
+		pr_err(KERN_ERR "ksm: register sysfs failed\n");
 		kthread_stop(ksm_thread);
 		goto out_free;
 	}
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

mm-mremap-use-linux-headers.patch
mm-filemap-remove-trailing-whitespace.patch
mm-bootmem-added-headers.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch

