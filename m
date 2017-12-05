From: akpm@linux-foundation.org
Subject: + stringh-work-around-for-increased-stack-usage-fix.patch added
 to -mm tree
Date: Tue, 05 Dec 2017 14:02:29 -0800
Message-ID: <5a271775.UI6FW3a25n9+NS1u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdLEWCa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 17:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: stringh-work-around-for-increased-stack-usage-fix
has been added to the -mm tree.  Its filename is
     stringh-work-around-for-increased-stack-usage-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stringh-work-around-for-increased-stack-usage-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stringh-work-around-for-increased-stack-usage-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: stringh-work-around-for-increased-stack-usage-fix

add comment

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/string.h~stringh-work-around-for-increased-stack-usage-fix include/linux/string.h
--- a/include/linux/string.h~stringh-work-around-for-increased-stack-usage-fix
+++ a/include/linux/string.h
@@ -259,6 +259,8 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 {
 	__kernel_size_t ret;
 	size_t p_size = __builtin_object_size(p, 0);
+
+	/* Work around gcc excess stack consumption issue */
 	if (p_size == (size_t)-1 ||
 	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
 		return __builtin_strlen(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

