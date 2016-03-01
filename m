From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch removed from -mm tree
Date: Tue, 01 Mar 2016 11:13:21 -0800
Message-ID: <56d5e9d1.WBVkfG2vagEQlTr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbcCATNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 14:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref, crypto/async_pq: don't put_page from __exit
has been removed from the -mm tree.  Its filename was
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/page_ref, crypto/async_pq: don't put_page from __exit

The addition of tracepoints to the page reference tracking had an
unfortunate side-effect in at least one driver that calls put_page
from its exit function, resulting in a link error:

`.exit.text' referenced in section `__jump_table' of crypto/built-in.o: defined in discarded section `.exit.text' of crypto/built-in.o

I could not come up with a nice solution that ignores __jump_table
entries in discarded code, so we probably now have to treat this
as something a driver is not allowed to do. Removing the __exit
annotation avoids the problem in this particular driver, but the
same problem could come back any time in other code.

On a related problem regarding the runtime patching for SMP
operations on ARM uniprocessor systems, we resorted to not
drop the .exit section at link time, but that doesn't seem
appropriate here.

Fixes: 0f80830dd044 ("mm/page_ref: add tracepoint to track down page reference manipulation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_pq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix crypto/async_tx/async_pq.c
--- a/crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix
+++ a/crypto/async_tx/async_pq.c
@@ -442,7 +442,7 @@ static int __init async_pq_init(void)
 	return -ENOMEM;
 }
 
-static void __exit async_pq_exit(void)
+static void async_pq_exit(void)
 {
 	put_page(pq_scribble_page);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-compaction-introduce-kcompactd-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch

