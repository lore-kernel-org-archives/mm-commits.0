From: akpm@linux-foundation.org
Subject: + aio-remove-unnecessary-check.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:42:43 -0800
Message-ID: <201101042242.p04MghfF028420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab1ADWmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, jmoyer@redhat.com


The patch titled
     aio: remove unnecessary check
has been added to the -mm tree.  Its filename is
     aio-remove-unnecessary-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
drivers-telephony-ixjc-fix-warning.patch
fs-char_devc-remove-unused-cdev_index.patch
aio-remove-unnecessary-check.patch

