From: akpm@linux-foundation.org
Subject: [folded] init-add-root=partuuid=uuid-partnroff=%d-support-update.patch removed from -mm tree
Date: Wed, 03 Aug 2011 14:07:18 -0700
Message-ID: <201108032107.p73L7IOC013996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1HCVIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 17:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wad@chromium.org, Trond.Myklebust@netapp.com, axboe@kernel.dk, kay.sievers@vrfy.org, namhyung@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     init: clean up devt_from_partuuid syntax checking and logging
has been removed from the -mm tree.  Its filename was
     init-add-root=partuuid=uuid-partnroff=%d-support-update.patch

This patch was dropped because it was folded into init-add-root=partuuid=uuid-partnroff=%d-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: clean up devt_from_partuuid syntax checking and logging
From: Will Drewry <wad@chromium.org>

This patch makes two changes:
- check for trailing characters after parsing PARTNROFF=%d
- disable root_wait if a syntax error is seen

The former assures that bad input like
  root=PARTUUID=<validuuid>/PARTNROFF=5abc
properly fails by attempting to parse an extra character after the
integer.  If the integer is missing, sscanf will fail, but if it is
present, and there is a trailing non-nul character, then the extra
field will be parsed and the error case will be hit.

The latter assures that if rootwait has been specified, the error
message isn't flooded to the screen during rootwait's loop.  Instead of
adding printk ratelimiting, root_wait was disabled.  This stays true to
the rootwait goal of support asynchronous device arrival while still
providing users with helpful messages.  With ratelimiting or disabling
logging on rootwait, a range of edge cases turn up where the user would
not be informed of an error properly.

Signed-off-by: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support-update init/do_mounts.c
--- a/init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support-update
+++ a/init/do_mounts.c
@@ -110,10 +110,16 @@ static dev_t devt_from_partuuid(char *uu
 
 	/* Check for optional partition number offset attributes. */
 	if (uuid_str[36]) {
+		char c = 0;
 		/* Explicitly fail on poor PARTUUID syntax. */
-		if (sscanf(&uuid_str[36], "/PARTNROFF=%d", &offset) != 1) {
+		if (sscanf(&uuid_str[36],
+			   "/PARTNROFF=%d%c", &offset, &c) != 1) {
 			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
 			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
+			if (root_wait)
+				printk(KERN_ERR
+				     "Disabling rootwait; root= is invalid.\n");
+			root_wait = 0;
 			goto done;
 		}
 	}
_

Patches currently in -mm which might be from wad@chromium.org are

init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch

