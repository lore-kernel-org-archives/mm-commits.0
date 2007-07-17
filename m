From: akpm@linux-foundation.org
Subject: - avoid-open_max-in-scm_max_fd.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:15 -0700
Message-ID: <200707172302.l6HN2Fc7011552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936666AbXGQXQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     avoid OPEN_MAX in SCM_MAX_FD
has been removed from the -mm tree.  Its filename was
     avoid-open_max-in-scm_max_fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avoid OPEN_MAX in SCM_MAX_FD
From: Roland McGrath <roland@redhat.com>

The OPEN_MAX constant is an arbitrary number with no useful relation to
anything.  Nothing should be using it.  SCM_MAX_FD is just an arbitrary
constant and it should be clear that its value is chosen in net/scm.h
and not actually derived from anything else meaningful in the system.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/scm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/net/scm.h~avoid-open_max-in-scm_max_fd include/net/scm.h
--- a/include/net/scm.h~avoid-open_max-in-scm_max_fd
+++ a/include/net/scm.h
@@ -8,7 +8,7 @@
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
  */
-#define SCM_MAX_FD	(OPEN_MAX-1)
+#define SCM_MAX_FD	255
 
 struct scm_fp_list
 {
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch
alpha-put-allocated-elf-notes-in-read-only-data-segment.patch
powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
