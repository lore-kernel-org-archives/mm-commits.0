From: akpm@linux-foundation.org
Subject: - autofs4-collect-version-check-return.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:08 -0800
Message-ID: <200811102032.mAAKW8rp023770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYKJUi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: collect version check return
has been removed from the -mm tree.  Its filename was
     autofs4-collect-version-check-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: collect version check return
From: Ian Kent <raven@themaw.net>

The function check_dev_ioctl_version() returns an error code upon fail but
it isn't captured and returned in validate_dev_ioctl() as it should be.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return
+++ a/fs/autofs4/dev-ioctl.c
@@ -128,9 +128,10 @@ static inline void free_dev_ioctl(struct
  */
 static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 {
-	int err = -EINVAL;
+	int err;
 
-	if (check_dev_ioctl_version(cmd, param)) {
+	err = check_dev_ioctl_version(cmd, param);
+	if (err) {
 		AUTOFS_WARN("invalid device control module version "
 		     "supplied for cmd(0x%08x)", cmd);
 		goto out;
_

Patches currently in -mm which might be from raven@themaw.net are

linux-next.patch
autofs4-improve-parameter-usage.patch
autofs4-fix-var-shadowed-by-local-delaration.patch
autofs4-make-autofs-type-usage-explicit.patch
autofs4-fix-string-validation-check-order.patch

