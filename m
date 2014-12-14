From: akpm@linux-foundation.org
Subject: [merged] parisc-update-comments-refereing-to-__get_cpu_var.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:10:41 -0800
Message-ID: <548d0dc1.vr/4Rbi4z77AJeg2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaLNEKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: percpu: update comments referring to __get_cpu_var
has been removed from the -mm tree.  Its filename was
     parisc-update-comments-refereing-to-__get_cpu_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: parisc: percpu: update comments referring to __get_cpu_var

__get_cpu_var was removed. Update comments to refer to
this_cpu_ptr() instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/fixup.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/lib/fixup.S~parisc-update-comments-refereing-to-__get_cpu_var arch/parisc/lib/fixup.S
--- a/arch/parisc/lib/fixup.S~parisc-update-comments-refereing-to-__get_cpu_var
+++ a/arch/parisc/lib/fixup.S
@@ -38,14 +38,14 @@
 	LDREGX \t2(\t1),\t2 
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t1
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	add,l \t1,\t2,\t1
 	/* t1 = t1->fault_ip */
 	LDREG EXCDATA_IP(\t1), \t1
 	.endm
 #else
 	.macro  get_fault_ip t1 t2
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t2
 	/* t1 = t2->fault_ip */
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch

