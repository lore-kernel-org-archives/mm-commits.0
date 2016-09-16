From: akpm@linux-foundation.org
Subject: + mm-shmemc-constify-anon_ops.patch added to -mm tree
Date: Fri, 16 Sep 2016 15:46:56 -0700
Message-ID: <57dc7660.ORcm5dHB6ttiZVyr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58807 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbcIPWq5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 18:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: constify anon_ops
has been added to the -mm tree.  Its filename is
     mm-shmemc-constify-anon_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmemc-constify-anon_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmemc-constify-anon_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/shmem.c: constify anon_ops

Every other dentry_operations instance is const, and this one might as
well be.

Link: http://lkml.kernel.org/r/1473890528-7009-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~mm-shmemc-constify-anon_ops mm/shmem.c
--- a/mm/shmem.c~mm-shmemc-constify-anon_ops
+++ a/mm/shmem.c
@@ -4077,7 +4077,7 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 /* common code */
 
-static struct dentry_operations anon_ops = {
+static const struct dentry_operations anon_ops = {
 	.d_dname = simple_dname
 };
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-shmemc-constify-anon_ops.patch

