From: akpm@linux-foundation.org
Subject: [patch 38/51] lib/idr.c: fix comment for idr_replace()
Date: Tue, 03 Oct 2017 16:16:13 -0700
Message-ID: <59d41a3d.8NAhmUXWiLa8tFKc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebiggers@google.com, mawilcox@microsoft.com

From: Eric Biggers <ebiggers@google.com>
Subject: lib/idr.c: fix comment for idr_replace()

idr_replace() returns the old value on success, not 0.

Link: http://lkml.kernel.org/r/20170918162642.37511-1-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr-fix-comment-for-idr_replace lib/idr.c
--- a/lib/idr.c~idr-fix-comment-for-idr_replace
+++ a/lib/idr.c
@@ -146,8 +146,8 @@ EXPORT_SYMBOL(idr_get_next_ext);
  * idr_alloc() and idr_remove() (as long as the ID being removed is not
  * the one being replaced!).
  *
- * Returns: 0 on success.  %-ENOENT indicates that @id was not found.
- * %-EINVAL indicates that @id or @ptr were not valid.
+ * Returns: the old value on success.  %-ENOENT indicates that @id was not
+ * found.  %-EINVAL indicates that @id or @ptr were not valid.
  */
 void *idr_replace(struct idr *idr, void *ptr, int id)
 {
_
