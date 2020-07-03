From: akpm@linux-foundation.org
Subject: +
 mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch added to -mm
 tree
Date: Thu, 02 Jul 2020 21:29:19 -0700
Message-ID: <20200703042919.kZ3qJMXHz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCE3U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, vbabka@suse.cz, weiyongjun1@huawei.com


The patch titled
     Subject: mm, slub: make function parse_slub_debug_flags() static
has been added to the -mm tree.  Its filename is
     mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: mm, slub: make function parse_slub_debug_flags() static

Fix sparse build warning:

mm/slub.c:1267:6: warning:
 symbol 'parse_slub_debug_flags' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702150522.4940-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix
+++ a/mm/slub.c
@@ -1272,7 +1272,7 @@ out:
  *
  * returns the start of next block if there's any, or NULL
  */
-char *
+static char *
 parse_slub_debug_flags(char *str, slab_flags_t *flags, char **slabs, bool init)
 {
 	bool higher_order_disable = false;
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch
