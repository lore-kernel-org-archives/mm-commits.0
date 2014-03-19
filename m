From: akpm@linux-foundation.org
Subject: +
 include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch added
 to -mm tree
Date: Wed, 19 Mar 2014 16:11:44 -0700
Message-ID: <532a2430.qy/YPR1I5rCAHBmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaCSXLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 19:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, simon.kagstrom@netinsight.net

Subject: + include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch added to -mm tree
To: simon.kagstrom@netinsight.net
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 16:11:44 -0700


The patch titled
     Subject: include/linux/printk.h: remove double asmlinkage in printk_emit
has been added to the -mm tree.  Its filename is
     include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Kågström <simon.kagstrom@netinsight.net>
Subject: include/linux/printk.h: remove double asmlinkage in printk_emit

The double asmlinkage was introduced in 7ff9554bb578ba0 ("printk: convert
byte-buffer to variable-length record buffer").

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-remove-double-asmlinkage-in-printk_emit include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-remove-double-asmlinkage-in-printk_emit
+++ a/include/linux/printk.h
@@ -124,9 +124,9 @@ asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
 
 asmlinkage __printf(5, 6) __cold
-asmlinkage int printk_emit(int facility, int level,
-			   const char *dict, size_t dictlen,
-			   const char *fmt, ...);
+int printk_emit(int facility, int level,
+		const char *dict, size_t dictlen,
+		const char *fmt, ...);
 
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
_

Patches currently in -mm which might be from simon.kagstrom@netinsight.net are

include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch
linux-next.patch

