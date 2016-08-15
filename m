From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-fix-excess-fenceh-kernel-doc-notation.patch removed from -mm
 tree
Date: Mon, 15 Aug 2016 16:34:05 -0700
Message-ID: <57b2516d.sIFqL9k/fujJUJTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbcHOXeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 19:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org, gustavo.padovan@collabora.co.uk, luisbg@osg.samsung.com, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: fix excess fence.h kernel-doc notation
has been removed from the -mm tree.  Its filename was
     include-linux-fix-excess-fenceh-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux: fix excess fence.h kernel-doc notation

Fix excess fields in kernel-doc notation in <linux/fence.h> after some
struct fields were removed.

Fixes these kernel-doc warnings:
..//include/linux/fence.h:85: warning: Excess struct/union/enum/typedef member 'child_list' description in 'fence'
..//include/linux/fence.h:85: warning: Excess struct/union/enum/typedef member 'active_list' description in 'fence'

Fixes: 0431b9065f28 ("staging/android: bring struct sync_pt back")

Link: http://lkml.kernel.org/r/979639c6-369b-c9ad-10d6-7982b048f1fb@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fence.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/fence.h~include-linux-fix-excess-fenceh-kernel-doc-notation include/linux/fence.h
--- a/include/linux/fence.h~include-linux-fix-excess-fenceh-kernel-doc-notation
+++ a/include/linux/fence.h
@@ -49,8 +49,6 @@ struct fence_cb;
  * @timestamp: Timestamp when the fence was signaled.
  * @status: Optional, only valid if < 0, must be set before calling
  * fence_signal, indicates that the fence has completed with an error.
- * @child_list: list of children fences
- * @active_list: list of active fences
  *
  * the flags member must be manipulated and read using the appropriate
  * atomic ops (bit_*), so taking the spinlock will not be needed most
_

Patches currently in -mm which might be from rdunlap@infradead.org are


