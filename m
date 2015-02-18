From: akpm@linux-foundation.org
Subject: [merged] seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:55 -0800
Message-ID: <54e4ebb7.sIZFA/mA4O/JoLu/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ldv@altlinux.org, luto@amacapital.net, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: cap SECCOMP_RET_ERRNO data to MAX_ERRNO
has been removed from the -mm tree.  Its filename was
     seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: seccomp: cap SECCOMP_RET_ERRNO data to MAX_ERRNO

The value resulting from the SECCOMP_RET_DATA mask could exceed MAX_ERRNO
when setting errno during a SECCOMP_RET_ERRNO filter action.  This makes
sure we have a reliable value being set, so that an invalid errno will not
be ignored by userspace.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/seccomp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/seccomp.c~seccomp-cap-seccomp_ret_errno-data-to-max_errno kernel/seccomp.c
--- a/kernel/seccomp.c~seccomp-cap-seccomp_ret_errno-data-to-max_errno
+++ a/kernel/seccomp.c
@@ -629,7 +629,9 @@ static u32 __seccomp_phase1_filter(int t
 
 	switch (action) {
 	case SECCOMP_RET_ERRNO:
-		/* Set the low-order 16-bits as a errno. */
+		/* Set low-order bits as an errno, capped at MAX_ERRNO. */
+		if (data > MAX_ERRNO)
+			data = MAX_ERRNO;
 		syscall_set_return_value(current, task_pt_regs(current),
 					 -data, 0);
 		goto skip;
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
aslr-fix-stack-randomization-on-64-bit-systems.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

