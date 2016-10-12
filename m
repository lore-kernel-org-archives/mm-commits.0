From: akpm@linux-foundation.org
Subject: [merged] autofs-dont-fail-to-free_dev_ioctlparam.patch removed
 from -mm tree
Date: Wed, 12 Oct 2016 12:23:51 -0700
Message-ID: <57fe8dc7.ddevYzUD08Z8b4nc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33271 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756012AbcJLTYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: don't fail to free_dev_ioctl(param)
has been removed from the -mm tree.  Its filename was
     autofs-dont-fail-to-free_dev_ioctlparam.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: don't fail to free_dev_ioctl(param)

Returning -ENOTTY here fails to free dynamically allocated param.

Link: http://lkml.kernel.org/r/20160812024815.12352.69153.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-dont-fail-to-free_dev_ioctlparam fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-dont-fail-to-free_dev_ioctlparam
+++ a/fs/autofs4/dev-ioctl.c
@@ -662,7 +662,8 @@ static int _autofs_dev_ioctl(unsigned in
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
 		pr_warn("unknown command 0x%08x\n", command);
-		return -ENOTTY;
+		err = -ENOTTY;
+		goto out;
 	}
 
 	fp = NULL;
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


