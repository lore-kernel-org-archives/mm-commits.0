From: akpm@linux-foundation.org
Subject: + mm-swap-make-pointer-swap_avail_heads-static.patch added to -mm tree
Date: Tue, 06 Feb 2018 14:01:20 -0800
Message-ID: <5a7a25b0.T0dTa3wSV+YuMFni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbeBFWBV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 17:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: make pointer swap_avail_heads static
has been added to the -mm tree.  Its filename is
     mm-swap-make-pointer-swap_avail_heads-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-make-pointer-swap_avail_heads-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-make-pointer-swap_avail_heads-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/swapfile.c: make pointer swap_avail_heads static

The pointer swap_avail_heads is local to the source and does not need to
be in global scope, so make it static.

Cleans up sparse warning:
mm/swapfile.c:88:19: warning: symbol 'swap_avail_heads' was not
declared. Should it be static?

Link: http://lkml.kernel.org/r/20180206215836.12366-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-make-pointer-swap_avail_heads-static mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-make-pointer-swap_avail_heads-static
+++ a/mm/swapfile.c
@@ -85,7 +85,7 @@ PLIST_HEAD(swap_active_head);
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-struct plist_head *swap_avail_heads;
+static struct plist_head *swap_avail_heads;
 static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-swap-make-pointer-swap_avail_heads-static.patch
kasan-remove-redundant-initialization-of-variable-real_size.patch

