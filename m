From: akpm@linux-foundation.org
Subject: [merged] kstrtox-remove-redundant-cleanup.patch removed from -mm
 tree
Date: Fri, 24 Jan 2014 11:01:31 -0800
Message-ID: <52e2b88b.laV6yj4t1RcXaMCw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaAXTBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, levex@linux.com, felipe.contreras@gmail.com

Subject: [merged] kstrtox-remove-redundant-cleanup.patch removed from -mm tree
To: felipe.contreras@gmail.com,levex@linux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:31 -0800


The patch titled
     Subject: lib/kstrtox.c: remove redundant cleanup
has been removed from the -mm tree.  Its filename was
     kstrtox-remove-redundant-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: lib/kstrtox.c: remove redundant cleanup

We can't reach the cleanup code unless the flag KSTRTOX_OVERFLOW is not
set, so there's not no point in clearing a bit that we know is not set.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Acked-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/kstrtox.c~kstrtox-remove-redundant-cleanup lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-remove-redundant-cleanup
+++ a/lib/kstrtox.c
@@ -92,7 +92,6 @@ static int _kstrtoull(const char *s, uns
 	rv = _parse_integer(s, base, &_res);
 	if (rv & KSTRTOX_OVERFLOW)
 		return -ERANGE;
-	rv &= ~KSTRTOX_OVERFLOW;
 	if (rv == 0)
 		return -EINVAL;
 	s += rv;
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

origin.patch
linux-next.patch

