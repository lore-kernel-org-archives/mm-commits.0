From: akpm@linux-foundation.org
Subject: + lib-ida-document-locking-requirements-a-bit-better-v2.patch
 added to -mm tree
Date: Fri, 28 Oct 2016 16:19:09 -0700
Message-ID: <5813dced.qLxG04lKzgDXjZqG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964858AbcJ1XUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 19:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.vetter@ffwll.ch, daniel.vetter@intel.com, mgorman@techsingularity.net, mhocko@suse.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ida: document locking requirements a bit better
has been added to the -mm tree.  Its filename is
     lib-ida-document-locking-requirements-a-bit-better-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ida-document-locking-requirements-a-bit-better-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ida-document-locking-requirements-a-bit-better-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: lib/ida: document locking requirements a bit better

I wanted to wrap a bunch of ida_simple_get calls into their own locking,
until I dug around and read the original commit message.  Stuff like this
should imo be added to the kernel doc, let's do that.

Link: http://lkml.kernel.org/r/20161027072216.20411-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN lib/idr.c~lib-ida-document-locking-requirements-a-bit-better-v2 lib/idr.c
--- a/lib/idr.c~lib-ida-document-locking-requirements-a-bit-better-v2
+++ a/lib/idr.c
@@ -927,6 +927,9 @@ EXPORT_SYMBOL(ida_pre_get);
  * and go back to the ida_pre_get() call.  If the ida is full, it will
  * return %-ENOSPC.
  *
+ * Note that callers must ensure that concurrent access to @ida is not possible.
+ * See ida_simple_get() for a varaint which takes care of locking.
+ *
  * @p_id returns a value in the range @starting_id ... %0x7fffffff.
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
@@ -1073,6 +1076,9 @@ EXPORT_SYMBOL(ida_destroy);
  * Allocates an id in the range start <= id < end, or returns -ENOSPC.
  * On memory allocation failure, returns -ENOMEM.
  *
+ * Compared to ida_get_new_above() this function does its own locking, and
+ * should be used unless there are special requirements.
+ *
  * Use ida_simple_remove() to get rid of an id.
  */
 int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
@@ -1119,6 +1125,11 @@ EXPORT_SYMBOL(ida_simple_get);
  * ida_simple_remove - remove an allocated id.
  * @ida: the (initialized) ida.
  * @id: the id returned by ida_simple_get.
+ *
+ * Use to release an id allocated with ida_simple_get().
+ *
+ * Compared to ida_remove() this function does its own locking, and should be
+ * used unless there are special requirements.
  */
 void ida_simple_remove(struct ida *ida, unsigned int id)
 {
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

lib-ida-document-locking-requirements-a-bit-better-v2.patch

