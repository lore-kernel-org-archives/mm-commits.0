From: akpm@linux-foundation.org
Subject: + checkpatch-reduce-maintainers-update-message-frequency.patch
 added to -mm tree
Date: Thu, 30 Oct 2014 14:53:28 -0700
Message-ID: <5452b358.RbhCRV1uCqbvO+V8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019AbaJ3Vx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: reduce MAINTAINERS update message frequency
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-maintainers-update-message-frequency.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-maintainers-update-message-frequency.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-maintainers-update-message-frequency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: reduce MAINTAINERS update message frequency

When files are being added/moved/deleted and a patch contains an update to
the MAINTAINERS file, assume it's to update the MAINTAINERS file correctly
and do not emit the "does MAINTAINERS need updating?" message.

Reported by many people.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-maintainers-update-message-frequency scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-maintainers-update-message-frequency
+++ a/scripts/checkpatch.pl
@@ -2082,6 +2082,12 @@ sub process {
 			$in_commit_log = 0;
 		}
 
+# Check if MAINTAINERS is being updated.  If so, there's probably no need to
+# emit the "does MAINTAINERS need updating?" message on file add/move/delete
+		if ($line =~ /^\s*MAINTAINERS\s*\|/) {
+			$reported_maintainer_file = 1;
+		}
+
 # Check signature styles
 		if (!$in_header_lines &&
 		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

