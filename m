From: akpm@linux-foundation.org
Subject: + fs-proc-pagec-fix-arg-reversal.patch added to -mm tree
Date: Thu, 19 Feb 2009 17:22:53 -0800
Message-ID: <200902200122.n1K1Mrwu004120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbZBTBXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 20:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helge.bahmann@secunet.com, adobriyan@gmail.com, mpm@selenic.com


The patch titled
     fs/proc/page.c: fix arg reversal
has been added to the -mm tree.  Its filename is
     fs-proc-pagec-fix-arg-reversal.patch

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
Subject: fs/proc/page.c: fix arg reversal
From: Helge Bahmann <helge.bahmann@secunet.com>

Fix arguments passed to macro in wrong order (expr always evaluates to
zero otherwise)

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~fs-proc-pagec-fix-arg-reversal fs/proc/page.c
--- a/fs/proc/page.c~fs-proc-pagec-fix-arg-reversal
+++ a/fs/proc/page.c
@@ -107,7 +107,7 @@ static ssize_t kpageflags_read(struct fi
 		else
 			kflags = ppage->flags;
 
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
 			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
 			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
 			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
_

Patches currently in -mm which might be from helge.bahmann@secunet.com are

fs-proc-pagec-fix-arg-reversal.patch

