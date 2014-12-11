From: akpm@linux-foundation.org
Subject: [merged]
 ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:58:29 -0800
Message-ID: <5489e955.F0Gs5r+O8lLtWYaT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaLKS6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: replace get_unused_fd() with get_unused_fd_flags(0)
has been removed from the -mm tree.  Its filename was
     ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: ia64: replace get_unused_fd() with get_unused_fd_flags(0)

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

In a further patch, get_unused_fd() will be removed so that new code start
using get_unused_fd_flags(), with the hope O_CLOEXEC could be used, either
by default or choosen by userspace.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/perfmon.c~ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0 arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0
+++ a/arch/ia64/kernel/perfmon.c
@@ -2662,7 +2662,7 @@ pfm_context_create(pfm_context_t *ctx, v
 
 	ret = -ENOMEM;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(0);
 	if (fd < 0)
 		return fd;
 
_

Patches currently in -mm which might be from ydroneaud@opteya.com are

origin.patch

