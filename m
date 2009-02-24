From: akpm@linux-foundation.org
Subject: [merged] fs-proc-pagec-fix-arg-reversal.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:09 -0800
Message-ID: <200902241933.n1OJX9Bv004498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbZBXTd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helge.bahmann@secunet.com, adobriyan@gmail.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     fs/proc/page.c: fix arg reversal
has been removed from the -mm tree.  Its filename was
     fs-proc-pagec-fix-arg-reversal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

