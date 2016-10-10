From: akpm@linux-foundation.org
Subject: [merged] do_generic_file_read-fail-immediately-if-killed.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:43:45 -0700
Message-ID: <57fc19a1.SQEwtyuZIIqhpelh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36635 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbcJJWnq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@sandisk.com, hughd@google.com, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: do_generic_file_read(): fail immediately if killed
has been removed from the -mm tree.  Its filename was
     do_generic_file_read-fail-immediately-if-killed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1721,7 +1721,9 @@ find_page:
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


