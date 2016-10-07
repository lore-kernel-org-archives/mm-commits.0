From: akpm@linux-foundation.org
Subject: [patch 035/127] do_generic_file_read(): fail immediately if
 killed
Date: Fri, 07 Oct 2016 16:58:33 -0700
Message-ID: <57f836a9.5oM6kYGjX1PNU8RJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39001 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbcJGX6f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bart.vanassche@sandisk.com, hughd@google.com, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, oleg@redhat.com

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
