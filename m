From: akpm@linux-foundation.org
Subject: [patch 083/127] mm/shmem.c: constify anon_ops
Date: Fri, 07 Oct 2016 17:01:01 -0700
Message-ID: <57f8373d.v27PsVoTn1L+Ivwa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39393 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932687AbcJHABC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, linux@rasmusvillemoes.dk, hughd@google.com

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
@@ -4078,7 +4078,7 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 /* common code */
 
-static struct dentry_operations anon_ops = {
+static const struct dentry_operations anon_ops = {
 	.d_dname = simple_dname
 };
 
_
