From: akpm@linux-foundation.org
Subject: + nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:46:09 -0700
Message-ID: <201003192346.o2JNk9Hu019036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab0CSXq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, uclinux@blueteddy.net


The patch titled
     nommu: fix an incorrect comment in the do_mmap_shared_file()
has been added to the -mm tree.  Its filename is
     nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file.patch

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
Subject: nommu: fix an incorrect comment in the do_mmap_shared_file()
From: David Howells <dhowells@redhat.com>

Fix an incorrect comment in the do_mmap_shared_file().  If a mapping is
requested MAP_SHARED, then a private copy cannot be made and still provide
correct semantics.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Dave Hudson <uclinux@blueteddy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file mm/nommu.c
--- a/mm/nommu.c~nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file
+++ a/mm/nommu.c
@@ -1044,10 +1044,9 @@ static int do_mmap_shared_file(struct vm
 	if (ret != -ENOSYS)
 		return ret;
 
-	/* getting an ENOSYS error indicates that direct mmap isn't
-	 * possible (as opposed to tried but failed) so we'll fall
-	 * through to making a private copy of the data and mapping
-	 * that if we can */
+	/* getting -ENOSYS indicates that direct mmap isn't possible (as
+	 * opposed to tried but failed) so we can only give a suitable error as
+	 * it's not possible to make a private copy if MAP_SHARED was given */
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file.patch
linux-next.patch
document-linuxs-circular-buffering-capabilities.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

