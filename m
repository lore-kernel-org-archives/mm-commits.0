From: akpm@linux-foundation.org
Subject: [merged] bitops-introduce-for_each_clear_bit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:14 -0700
Message-ID: <20120326192914.8E78FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2CZT3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:16 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, david.vrabel@csr.com, dwmw2@infradead.org, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, schwidefsky@de.ibm.com, sshtylyov@mvista.com, stefano.panella@csr.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: introduce for_each_clear_bit()
has been removed from the -mm tree.  Its filename was
     bitops-introduce-for_each_clear_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bitops: introduce for_each_clear_bit()

Introduce for_each_clear_bit() and for_each_clear_bit_from().  They are
similar to for_each_set_bit() and list_for_each_set_bit_from(), but they
iterate over all the cleared bits in a memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stefano Panella <stefano.panella@csr.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/bitops.h~bitops-introduce-for_each_clear_bit include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-introduce-for_each_clear_bit
+++ a/include/linux/bitops.h
@@ -32,6 +32,17 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+#define for_each_clear_bit(bit, addr, size) \
+	for ((bit) = find_first_zero_bit((addr), (size));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_clear_bit() but use bit as value to start with */
+#define for_each_clear_bit_from(bit, addr, size) \
+	for ((bit) = find_next_zero_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

