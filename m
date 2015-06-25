From: akpm@linux-foundation.org
Subject: + stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch added to -mm tree
Date: Thu, 25 Jun 2015 12:52:04 -0700
Message-ID: <558c5be4.cepfDLTv7NUgkxus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbFYTwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 15:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dvlasenk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: stddef.h: move offsetofend inside #ifndef/#endif guard, neaten
has been added to the -mm tree.  Its filename is
     stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch

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
Subject: stddef.h: move offsetofend inside #ifndef/#endif guard, neaten

commit 3876488444e7 ("include/stddef.h: Move offsetofend() from vfio.h to
a generic kernel header") added offsetofend outside the normal include
#ifndef/#endif guard.  Move it inside.

Miscellanea:

o remove unnecessary blank line
o standardize offsetof macros whitespace style

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stddef.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/stddef.h~stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten include/linux/stddef.h
--- a/include/linux/stddef.h~stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten
+++ a/include/linux/stddef.h
@@ -3,7 +3,6 @@
 
 #include <uapi/linux/stddef.h>
 
-
 #undef NULL
 #define NULL ((void *)0)
 
@@ -14,10 +13,9 @@ enum {
 
 #undef offsetof
 #ifdef __compiler_offsetof
-#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
+#define offsetof(TYPE, MEMBER)	__compiler_offsetof(TYPE, MEMBER)
 #else
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
+#define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)
 #endif
 
 /**
@@ -28,3 +26,5 @@ enum {
  */
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof(((TYPE *)0)->MEMBER))
+
+#endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
mailmap-add-rdunlap-email-auto-correction.patch
stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
get_maintainer-emit-longer-section-headers.patch
get_maintainer-fix-perl-522-524-deprecated-incompatible-c-use.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
maintainers-add-quotation-marks-around-names-with-periods.patch
maintainers-add-quotation-marks-around-names-with-commas.patch
lib-string-introduce-strreplace.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
checkpatch-improve-output-with-multiple-command-line-files.patch
checkpatch-colorize-output-to-terminal.patch
checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
checkpatch-remove-local-from-codespell-path.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
checkpatch-validate-module_license-content.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
checkpatch-emit-note-types-message-only-once-after-multiple-files.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

