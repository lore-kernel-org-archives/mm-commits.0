From: akpm@linux-foundation.org
Subject: [patch 115/123] lib/ida: document locking requirements a bit
 better
Date: Mon, 12 Dec 2016 16:46:20 -0800
Message-ID: <584f44dc.Tih1Ze6x4VyaIFrL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbcLMAqV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, daniel.vetter@ffwll.ch, daniel.vetter@intel.com, mgorman@techsingularity.net, mhocko@suse.com, tj@kernel.org, vbabka@suse.cz

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
