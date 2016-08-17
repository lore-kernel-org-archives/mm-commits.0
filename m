From: akpm@linux-foundation.org
Subject: + do_generic_file_read-fail-immediately-if-killed.patch added to
 -mm tree
Date: Wed, 17 Aug 2016 14:17:24 -0700
Message-ID: <57b4d464.tgn2Q2M0FxpFihCb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbcHQVRZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2016 17:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@sandisk.com, hughd@google.com, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: do_generic_file_read(): fail immediately if killed
has been added to the -mm tree.  Its filename is
     do_generic_file_read-fail-immediately-if-killed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/do_generic_file_read-fail-immediately-if-killed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/do_generic_file_read-fail-immediately-if-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: do_generic_file_read(): fail immediately if killed

If a fatal signal has been received, fail immediately instead of trying to
read more data.

If wait_on_page_locked_killable() was interrupted then this page is most
likely is not PageUptodate() and in this case do_generic_file_read() will
fail after lock_page_killable().

See also commit ebded02788b5 ("mm: filemap: avoid unnecessary calls to
lock_page when waiting for IO to complete during a read")

[oleg@redhat.com: changelog addition]
Link: http://lkml.kernel.org/r/63068e8e-8bee-b208-8441-a3c39a9d9eb6@sandisk.com
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~do_generic_file_read-fail-immediately-if-killed mm/filemap.c
--- a/mm/filemap.c~do_generic_file_read-fail-immediately-if-killed
+++ a/mm/filemap.c
@@ -1708,7 +1708,9 @@ find_page:
 			 * wait_on_page_locked is used to avoid unnecessarily
 			 * serialisations and why it's safe.
 			 */
-			wait_on_page_locked_killable(page);
+			error = wait_on_page_locked_killable(page);
+			if (unlikely(error))
+				goto readpage_error;
 			if (PageUptodate(page))
 				goto page_ok;
 
_

Patches currently in -mm which might be from bart.vanassche@sandisk.com are

do_generic_file_read-fail-immediately-if-killed.patch

