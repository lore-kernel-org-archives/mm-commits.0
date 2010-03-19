From: akpm@linux-foundation.org
Subject: + kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch added to -mm tree
Date: Fri, 19 Mar 2010 14:33:02 -0700
Message-ID: <201003192133.o2JLX29O013544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0CSVdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 17:33:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, stefani@seibold.net


The patch titled
     kfifo: kfifo_is_{full,empty} should return bools, not ints
has been added to the -mm tree.  Its filename is
     kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch

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
Subject: kfifo: kfifo_is_{full,empty} should return bools, not ints
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

For consistency with other kfifo routines, return bool, not int.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-kfifo_is_fullempty-should-return-bools-not-ints include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-kfifo_is_fullempty-should-return-bools-not-ints
+++ a/include/linux/kfifo.h
@@ -172,7 +172,7 @@ static inline unsigned int kfifo_len(str
  * kfifo_is_empty - returns true if the fifo is empty
  * @fifo: the fifo to be used.
  */
-static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
+static inline __must_check bool kfifo_is_empty(struct kfifo *fifo)
 {
 	return fifo->in == fifo->out;
 }
@@ -181,7 +181,7 @@ static inline __must_check int kfifo_is_
  * kfifo_is_full - returns true if the fifo is full
  * @fifo: the fifo to be used.
  */
-static inline __must_check int kfifo_is_full(struct kfifo *fifo)
+static inline __must_check bool kfifo_is_full(struct kfifo *fifo)
 {
 	return kfifo_len(fifo) == kfifo_size(fifo);
 }
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch

