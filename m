From: akpm@linux-foundation.org
Subject: + bitops-introduce-for_each_clear_bit.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:10 -0800
Message-ID: <20120113225610.DB087200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:53146 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2AMW4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:13 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt14so109041wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, david.vrabel@csr.com, dwmw2@infradead.org, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, schwidefsky@de.ibm.com, sshtylyov@mvista.com, stefano.panella@csr.com, tglx@linutronix.de


The patch titled
     Subject: bitops: introduce for_each_clear_bit()
has been added to the -mm tree.  Its filename is
     bitops-introduce-for_each_clear_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: bitops: introduce for_each_clear_bit()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch

