From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:14 -0800
Message-ID: <548d0cf2.gl3vqFfAE5M4YWqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaLNEHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix hugepages= entry in kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

origin.patch
linux-next.patch

