From: akpm@linux-foundation.org
Subject: + kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:08:54 -0700
Message-ID: <200904242008.n3OK8s4G004324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757697AbZDXUKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     kernel/kfifo.c: replace conditional test with is_power_of_2()
has been added to the -mm tree.  Its filename is
     kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch

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
Subject: kernel/kfifo.c: replace conditional test with is_power_of_2()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kfifo.c~kernel-kfifoc-replace-conditional-test-with-is_power_of_2 kernel/kfifo.c
--- a/kernel/kfifo.c~kernel-kfifoc-replace-conditional-test-with-is_power_of_2
+++ a/kernel/kfifo.c
@@ -74,7 +74,7 @@ struct kfifo *kfifo_alloc(unsigned int s
 	 * round up to the next power of 2, since our 'let the indices
 	 * wrap' tachnique works only in this case.
 	 */
-	if (size & (size - 1)) {
+	if (!is_power_of_2(size)) {
 		BUG_ON(size > 0x80000000);
 		size = roundup_pow_of_two(size);
 	}
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch

