From: akpm@linux-foundation.org
Subject: [merged]
 binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:33 -0800
Message-ID: <5489e959.ZD66/Bc52a5rJVXc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaLKS6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: replace get_unused_fd() with get_unused_fd_flags(0)
has been removed from the -mm tree.  Its filename was
     binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: binfmt_misc: replace get_unused_fd() with get_unused_fd_flags(0)

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

In a further patch, get_unused_fd() will be removed so that new code start
using get_unused_fd_flags(), with the hope O_CLOEXEC could be used, either
by default or choosen by userspace.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0 fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0
+++ a/fs/binfmt_misc.c
@@ -153,7 +153,7 @@ static int load_misc_binary(struct linux
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
 		 * to it */
- 		fd_binary = get_unused_fd();
+		fd_binary = get_unused_fd_flags(0);
  		if (fd_binary < 0) {
  			retval = fd_binary;
  			goto _ret;
_

Patches currently in -mm which might be from ydroneaud@opteya.com are

origin.patch

