From: akpm@linux-foundation.org
Subject: + seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch added to
 -mm tree
Date: Fri, 06 Feb 2015 15:14:05 -0800
Message-ID: <54d54abd.PeSP0R94I9yQMVGk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbbBFXOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 18:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ldv@altlinux.org, luto@amacapital.net, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: cap SECCOMP_RET_ERRNO data to MAX_ERRNO
has been added to the -mm tree.  Its filename is
     seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
lib-vsprintf-add-%pt-format-specifier.patch
samples-seccomp-improve-label-helper.patch
samples-seccomp-improve-label-helper-fix.patch
seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch
linux-next.patch

