From: akpm@linux-foundation.org
Subject: + kfifo-implement-missing-__kfifo_skip_r.patch added to -mm tree
Date: Thu, 12 Aug 2010 14:22:18 -0700
Message-ID: <201008122122.o7CLMIbM013450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab0HLVWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 17:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, greg@kroah.com, stefani@seibold.net


The patch titled
     kfifo: implement missing __kfifo_skip_r()
has been added to the -mm tree.  Its filename is
     kfifo-implement-missing-__kfifo_skip_r.patch

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
Subject: kfifo: implement missing __kfifo_skip_r()
From: Andrea Righi <arighi@develer.com>

kfifo_skip() is currently broken, due to the missing of the internal
helper function.  Add it.

Signed-off-by: Andrea Righi <arighi@develer.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 ++
 kernel/kfifo.c        |    9 +++++++++
 2 files changed, 11 insertions(+)

diff -puN include/linux/kfifo.h~kfifo-implement-missing-__kfifo_skip_r include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-implement-missing-__kfifo_skip_r
+++ a/include/linux/kfifo.h
@@ -836,6 +836,8 @@ extern void __kfifo_dma_out_finish_r(str
 
 extern unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize);
 
+extern void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize);
+
 extern unsigned int __kfifo_out_peek_r(struct __kfifo *fifo,
 	void *buf, unsigned int len, size_t recsize);
 
diff -puN kernel/kfifo.c~kfifo-implement-missing-__kfifo_skip_r kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-implement-missing-__kfifo_skip_r
+++ a/kernel/kfifo.c
@@ -503,6 +503,15 @@ unsigned int __kfifo_out_r(struct __kfif
 }
 EXPORT_SYMBOL(__kfifo_out_r);
 
+void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize)
+{
+	unsigned int n;
+
+	n = __kfifo_peek_n(fifo, recsize);
+	fifo->out += n + recsize;
+}
+EXPORT_SYMBOL(__kfifo_skip_r);
+
 int __kfifo_from_user_r(struct __kfifo *fifo, const void __user *from,
 	unsigned long len, unsigned int *copied, size_t recsize)
 {
_

Patches currently in -mm which might be from arighi@develer.com are

origin.patch
kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch

