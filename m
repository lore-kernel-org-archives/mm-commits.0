From: akpm@linux-foundation.org
Subject: [patch 037/102] autofs: don't fail to free_dev_ioctl(param)
Date: Tue, 11 Oct 2016 13:52:48 -0700
Message-ID: <57fd5120.iLyhGOmDOiv5KSc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbcJKUxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, ikent@redhat.com

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
