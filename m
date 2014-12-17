From: akpm@linux-foundation.org
Subject: +
 hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch added to
 -mm tree
Date: Wed, 17 Dec 2014 14:03:31 -0800
Message-ID: <5491fdb3.k0j4YN3LTa5gut1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaLQWDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb, sysctl: pass '.extra1 = NULL' rather then '.extra1 = &zero'
has been added to the -mm tree.  Its filename is
     hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-sysctl-pass-extra1-%3D-null-rather-then-extra1-%3D-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-sysctl-pass-extra1-%3D-null-rather-then-extra1-%3D-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: hugetlb, sysctl: pass '.extra1 = NULL' rather then '.extra1 = &zero'

Commit ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and
hugetlb_infinity") replaced 'unsigned long hugetlb_zero' with 'int zero'
leading to out-of-bounds access in proc_doulongvec_minmax().  Use '.extra1
= NULL' instead of '.extra1 = &zero'.  Passing NULL is equivalent to
passing minimal value, which is 0 for unsigned types.

Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sysctl.c~hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero
+++ a/kernel/sysctl.c
@@ -1248,7 +1248,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1257,7 +1256,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1280,7 +1278,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= &zero,
 	},
 #endif
 	{
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

