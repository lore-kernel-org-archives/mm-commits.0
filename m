From: akpm@linux-foundation.org
Subject: [merged] aio-remove-unnecessary-check.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:59 -0800
Message-ID: <201101132012.p0DKCeBw030316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab1AMUNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove unnecessary check
has been removed from the -mm tree.  Its filename was
     aio-remove-unnecessary-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: remove unnecessary check
From: Namhyung Kim <namhyung@gmail.com>

'nr >= min_nr >= 0' always satisfies 'nr >= 0' so the check is unnecesary.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/aio.c~aio-remove-unnecessary-check fs/aio.c
--- a/fs/aio.c~aio-remove-unnecessary-check
+++ a/fs/aio.c
@@ -1839,7 +1839,7 @@ SYSCALL_DEFINE5(io_getevents, aio_contex
 	long ret = -EINVAL;
 
 	if (likely(ioctx)) {
-		if (likely(min_nr <= nr && min_nr >= 0 && nr >= 0))
+		if (likely(min_nr <= nr && min_nr >= 0))
 			ret = read_events(ioctx, min_nr, nr, events, timeout);
 		put_ioctx(ioctx);
 	}
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch

