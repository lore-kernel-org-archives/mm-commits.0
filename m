From: akpm@linux-foundation.org
Subject: + hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
 added to -mm tree
Date: Thu, 13 Nov 2014 13:54:50 -0800
Message-ID: <546528aa.2bYuJ5wqx2a5Mb01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934250AbaKMVyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix hugepages= entry in kernel-parameters.txt
has been added to the -mm tree.  Its filename is
     hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-hugepages%3D-entry-in-kernel-parameterstxt.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-hugepages%3D-entry-in-kernel-parameterstxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: fix hugepages= entry in kernel-parameters.txt

The hugepages= entry in kernel-parameters.txt states that 1GB pages can
only be allocated at boot time and not freed afterwards.  This is not true
since commit 944d9fec8d7aee, at least for x86_64.

Instead of adding arch-specifc observations to the hugepages= entry, this
commit just drops the out of date information.  Further information about
arch-specific support and available features can be obtained in the
hugetlb documentation.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -1228,9 +1228,7 @@ bytes respectively. Such letter suffixes
 			multiple times interleaved with hugepages= to reserve
 			huge pages of different sizes. Valid pages sizes on
 			x86-64 are 2M (when the CPU supports "pse") and 1G
-			(when the CPU supports the "pdpe1gb" cpuinfo flag)
-			Note that 1GB pages can only be allocated at boot time
-			using hugepages= and not freed afterwards.
+			(when the CPU supports the "pdpe1gb" cpuinfo flag).
 
 	hvc_iucv=	[S390] Number of z/VM IUCV hypervisor console (HVC)
 			       terminal devices. Valid values: 0..8
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
linux-next.patch

