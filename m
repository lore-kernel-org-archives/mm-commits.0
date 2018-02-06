From: akpm@linux-foundation.org
Subject: + mm-ksm-make-function-stable_node_dup-static.patch added to -mm
 tree
Date: Tue, 06 Feb 2018 14:14:53 -0800
Message-ID: <5a7a28dd./RkSDgXxUw6xYmJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753323AbeBFWOz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 17:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: make stable_node_dup() static
has been added to the -mm tree.  Its filename is
     mm-ksm-make-function-stable_node_dup-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-make-function-stable_node_dup-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-make-function-stable_node_dup-static.patch

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
Subject: mm/ksm.c: make stable_node_dup() static

stable_node_dup() is local to the source and does not need to be in global
scope, so make it static.

Cleans up sparse warning:
mm/ksm.c:1321:13: warning: symbol 'stable_node_dup' was not
declared. Should it be static?

Link: http://lkml.kernel.org/r/20180206221005.12642-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~mm-ksm-make-function-stable_node_dup-static mm/ksm.c
--- a/mm/ksm.c~mm-ksm-make-function-stable_node_dup-static
+++ a/mm/ksm.c
@@ -1318,10 +1318,10 @@ bool is_page_sharing_candidate(struct st
 	return __is_page_sharing_candidate(stable_node, 0);
 }
 
-struct page *stable_node_dup(struct stable_node **_stable_node_dup,
-			     struct stable_node **_stable_node,
-			     struct rb_root *root,
-			     bool prune_stale_stable_nodes)
+static struct page *stable_node_dup(struct stable_node **_stable_node_dup,
+				    struct stable_node **_stable_node,
+				    struct rb_root *root,
+				    bool prune_stale_stable_nodes)
 {
 	struct stable_node *dup, *found = NULL, *stable_node = *_stable_node;
 	struct hlist_node *hlist_safe;
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-ksm-make-function-stable_node_dup-static.patch
mm-swap-make-pointer-swap_avail_heads-static.patch
kasan-remove-redundant-initialization-of-variable-real_size.patch

