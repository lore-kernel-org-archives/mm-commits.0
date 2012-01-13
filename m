From: akpm@linux-foundation.org
Subject: + bitops-remove-for_each_set_bit_cont.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:06 -0800
Message-ID: <20120113225607.204221E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49254 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab2AMW4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:08 -0500
Received: by yenl1 with SMTP id l1so85783yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de


The patch titled
     Subject: bitops: remove for_each_set_bit_cont()
has been added to the -mm tree.  Its filename is
     bitops-remove-for_each_set_bit_cont.patch

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
Subject: bitops: remove for_each_set_bit_cont()

Remove for_each_set_bit_cont() after confirming that no one uses
for_each_set_bit_cont() anymore.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/bitops.h~bitops-remove-for_each_set_bit_cont include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-remove-for_each_set_bit_cont
+++ a/include/linux/bitops.h
@@ -32,9 +32,6 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-#define for_each_set_bit_cont(bit, addr, size) \
-	for_each_set_bit_from(bit, addr, size)
