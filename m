From: akpm@linux-foundation.org
Subject: +
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch added to -mm tree
Date: Mon, 29 Feb 2016 13:20:28 -0800
Message-ID: <56d4b61c.9JjBp1YWEDHZ4M1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcB2VU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 16:20:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref, crypto/async_pq: don't put_page from __exit
has been added to the -mm tree.  Its filename is
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch

