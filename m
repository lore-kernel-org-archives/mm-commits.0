From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-uncommented-waitqueue_active.patch added
 to -mm tree
Date: Thu, 14 May 2015 13:20:39 -0700
Message-ID: <55550397.zjkrUxt37jICw1fC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161079AbbENUUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for uncommented waitqueue_active()
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-uncommented-waitqueue_active.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-for-uncommented-waitqueue_active.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-for-uncommented-waitqueue_active.patch

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
Subject: checkpatch: check for uncommented waitqueue_active()

Linus sayeth:

: Pretty much every single time people use this "if
: (waitqueue_active())" model, it tends to be a bug, because it means
: that there is zero serialization with people who are just about to go
: to sleep. It's fundamentally racy against all the "wait_event()" loops
: that carefully do memory barriers between testing conditions and going
: to sleep, because the memory barriers now don't exist on the waking
: side.
: 
: So I'm making a new rule: if you use waitqueue_active(), I want an
: explanation for why it's not racy with the waiter. A big comment about
: the memory ordering, or about higher-level locks that are held by the
: caller, or something.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-uncommented-waitqueue_active scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-uncommented-waitqueue_active
+++ a/scripts/checkpatch.pl
@@ -4898,6 +4898,13 @@ sub process {
 				     "memory barrier without comment\n" . $herecurr);
 			}
 		}
+# check for waitqueue_active without a comment.
+		if ($line =~ /\bwaitqueue_active\s*\(/) {
+			if (!ctx_has_comment($first_line, $linenr)) {
+				WARN("WAITQUEUE_ACTIVE",
+				     "waitqueue_active without comment\n" . $herecurr);
+			}
+		}
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("ARCH_DEFINES",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

