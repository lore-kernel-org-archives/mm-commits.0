From: akpm@linux-foundation.org
Subject: + idr-fix-wrong-kernel-doc.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:26:22 -0800
Message-ID: <200901130826.n0D8QMYp021752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbZAMI00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:26:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com


The patch titled
     idr: fix wrong kernel-doc
has been added to the -mm tree.  Its filename is
     idr-fix-wrong-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

cgroups-clean-up-kconfig.patch
cgroups-consolidate-cgroup-documents.patch
idr-fix-wrong-kernel-doc.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

