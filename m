From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch added to
 -mm tree
Date: Mon, 06 Apr 2020 18:43:41 -0700
Message-ID: <20200407014341.g450LyWt3%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgDGBnm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:43:42 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix
has been added to the -mm tree.  Its filename is
     mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix

fix spello in comment

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix
+++ a/mm/mempolicy.c
@@ -903,7 +903,7 @@ static int lookup_node(struct mm_struct
 	int locked = 1;
 	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
 	if (err == 0) {
-		/* E.g. GUP interupted by fatal signal */
+		/* E.g. GUP interrupted by fatal signal */
 		err = -EFAULT;
 	} else if (err > 0) {
 		err = page_to_nid(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch
mm-migratec-migrate-pg_readahead-flag.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
