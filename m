From: akpm@linux-foundation.org
Subject: +
 ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch added to
 -mm tree
Date: Tue, 14 Oct 2014 13:27:58 -0700
Message-ID: <543d874e.Z3T6wjzBUZ5hg9QB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaJNU16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: replace get_unused_fd() with get_unused_fd_flags(0)
has been added to the -mm tree.  Its filename is
     ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
ppc-cell-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-remove-get_unused_fd-macro.patch

