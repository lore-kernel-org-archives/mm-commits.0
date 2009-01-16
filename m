From: akpm@linux-foundation.org
Subject: [merged] idr-fix-wrong-kernel-doc.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:54 -0800
Message-ID: <200901161916.n0GJGsim025417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935345AbZAPTRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     idr: fix wrong kernel-doc
has been removed from the -mm tree.  Its filename was
     idr-fix-wrong-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix wrong kernel-doc
From: Li Zefan <lizf@cn.fujitsu.com>

idr_get_new_above() and ida_get_new_above() return an id in the range of
@staring_id ... 0x7fffffff, not 0 ... 0x7fffffff.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr-fix-wrong-kernel-doc lib/idr.c
--- a/lib/idr.c~idr-fix-wrong-kernel-doc
+++ a/lib/idr.c
@@ -292,7 +292,7 @@ static int idr_get_new_above_int(struct 
  * and go back to the idr_pre_get() call.  If the idr is full, it will
  * return -ENOSPC.
  *
- * @id returns a value in the range 0 ... 0x7fffffff
+ * @id returns a value in the range @starting_id ... 0x7fffffff
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
@@ -723,7 +723,7 @@ EXPORT_SYMBOL(ida_pre_get);
  * and go back to the ida_pre_get() call.  If the ida is full, it will
  * return -ENOSPC.
  *
- * @p_id returns a value in the range 0 ... 0x7fffffff.
+ * @p_id returns a value in the range @starting_id ... 0x7fffffff.
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memcg-get-put-parents-at-create-free.patch
linux-next.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

