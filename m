From: akpm@linux-foundation.org
Subject: + kstrtox-remove-redundant-cleanup.patch added to -mm tree
Date: Mon, 18 Nov 2013 15:46:51 -0800
Message-ID: <528aa6eb.DC08jTcwwGU1byBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3KRXqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 18:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, levex@linux.com, felipe.contreras@gmail.com

Subject: + kstrtox-remove-redundant-cleanup.patch added to -mm tree
To: felipe.contreras@gmail.com,levex@linux.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 15:46:51 -0800


The patch titled
     Subject: kstrtox: remove redundant cleanup
has been added to the -mm tree.  Its filename is
     kstrtox-remove-redundant-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrtox-remove-redundant-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrtox-remove-redundant-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: kstrtox: remove redundant cleanup

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
kstrtox-remove-redundant-cleanup.patch

