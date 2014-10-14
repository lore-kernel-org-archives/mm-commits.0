From: akpm@linux-foundation.org
Subject: + vmscan-replace-printk-with-pr_err.patch added to -mm tree
Date: Tue, 14 Oct 2014 14:18:13 -0700
Message-ID: <543d9315.Pl/pGWT7hwZrqspv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaJNVSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: replace printk with pr_err
has been added to the -mm tree.  Its filename is
     vmscan-replace-printk-with-pr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-replace-printk-with-pr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-replace-printk-with-pr_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm/vmscan.c: replace printk with pr_err

This patch replaces printk(KERN_ERR..) with pr_err found under
shrink_slab.  Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-replace-printk-with-pr_err mm/vmscan.c
--- a/mm/vmscan.c~vmscan-replace-printk-with-pr_err
+++ a/mm/vmscan.c
@@ -260,8 +260,7 @@ shrink_slab_node(struct shrink_control *
 	do_div(delta, lru_pages + 1);
 	total_scan += delta;
 	if (total_scan < 0) {
-		printk(KERN_ERR
-		"shrink_slab: %pF negative objects to delete nr=%ld\n",
+		pr_err("shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
 		total_scan = freeable;
 	}
_

Patches currently in -mm which might be from pintu.k@samsung.com are

vmalloc-replace-printk-with-pr_warn.patch
vmscan-replace-printk-with-pr_err.patch

