From: akpm@linux-foundation.org
Subject: + autofs4-collect-version-check-return.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:33:12 -0700
Message-ID: <200810272033.m9RKXCRt017422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYJ0Ud2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: collect version check return
has been added to the -mm tree.  Its filename is
     autofs4-collect-version-check-return.patch

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
Subject: autofs4: collect version check return
From: Ian Kent <raven@themaw.net>

The function check_dev_ioctl_version() returns an error code upon fail but
it isn't captured and returned in validate_dev_ioctl() as it should be.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return
+++ a/fs/autofs4/dev-ioctl.c
@@ -116,9 +116,9 @@ static inline void free_dev_ioctl(struct
  */
 static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 {
-	int err = -EINVAL;
+	int err;
 
-	if (check_dev_ioctl_version(cmd, param)) {
+	if ((err = check_dev_ioctl_version(cmd, param))) {
 		AUTOFS_WARN("invalid device control module version "
 		     "supplied for cmd(0x%08x)", cmd);
 		goto out;
_

Patches currently in -mm which might be from raven@themaw.net are

linux-next.patch
autofs4-correct-offset-mount-expire-check.patch
autofs4-remove-string-terminator-check.patch
autofs4-collect-version-check-return.patch

