From: akpm@linux-foundation.org
Subject: +
 mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch added to -mm tree
Date: Tue, 18 Nov 2014 13:19:42 -0800
Message-ID: <546bb7ee.SldPplMfratXQn70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaKRVTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: delete unnecessary check before calling free_percpu()
has been added to the -mm tree.  Its filename is
     mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/zswap: delete unnecessary check before calling free_percpu()

free_percpu() tests whether its argument is NULL and then returns
immediately.  Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu mm/zswap.c
--- a/mm/zswap.c~mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu
+++ a/mm/zswap.c
@@ -152,8 +152,7 @@ static int __init zswap_comp_init(void)
 static void __init zswap_comp_exit(void)
 {
 	/* free percpu transforms */
-	if (zswap_comp_pcpu_tfms)
-		free_percpu(zswap_comp_pcpu_tfms);
+	free_percpu(zswap_comp_pcpu_tfms);
 }
 
 /*********************************
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch
linux-next.patch

