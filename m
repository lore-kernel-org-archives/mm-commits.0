From: akpm@linux-foundation.org
Subject: + m32r-remove-abort.patch added to -mm tree
Date: Thu, 25 Jan 2018 14:29:40 -0800
Message-ID: <5a6a5a54.kqYD2Vs+an98hNnw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbeAYW3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jan 2018 17:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: remove abort()
has been added to the -mm tree.  Its filename is
     m32r-remove-abort.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-remove-abort.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-remove-abort.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: remove abort()

7c2c11b208be ("arch: define weak abort()") has introduced a weak abort()
which is common for all arch.  And, so we will not need arch specific
abort which has the same code as the weak abort().  Remove the abort() for
m32r.

Link: http://lkml.kernel.org/r/1516912339-5665-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/traps.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/m32r/kernel/traps.c~m32r-remove-abort arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~m32r-remove-abort
+++ a/arch/m32r/kernel/traps.c
@@ -115,14 +115,6 @@ static void set_eit_vector_entries(void)
 	_flush_cache_copyback_all();
 }
 
-void abort(void)
-{
-	BUG();
-
-	/* if that doesn't kill us, halt */
-	panic("Oops failed to kill thread");
-}
