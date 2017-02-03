From: akpm@linux-foundation.org
Subject: [patch 8/8] mm, fs: check for fatal signals in
 do_generic_file_read()
Date: Fri, 03 Feb 2017 13:13:29 -0800
Message-ID: <5894f279.nfIS8JnR1vxXUlXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdBCVNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 16:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: mm, fs: check for fatal signals in do_generic_file_read()

do_generic_file_read() can be told to perform a large request from
userspace.  If the system is under OOM and the reading task is the OOM
victim then it has an access to memory reserves and finishing the full
request can lead to the full memory depletion which is dangerous.  Make
sure we rather go with a short read and allow the killed task to
terminate.

Link: http://lkml.kernel.org/r/20170201092706.9966-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/filemap.c~mm-fs-check-for-fatal-signals-in-do_generic_file_read mm/filemap.c
--- a/mm/filemap.c~mm-fs-check-for-fatal-signals-in-do_generic_file_read
+++ a/mm/filemap.c
@@ -1791,6 +1791,11 @@ static ssize_t do_generic_file_read(stru
 
 		cond_resched();
 find_page:
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			goto out;
+		}
+
 		page = find_get_page(mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(mapping,
_
