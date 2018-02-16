From: akpm@linux-foundation.org
Subject: + taint-add-taint-for-randstruct.patch added to -mm tree
Date: Fri, 16 Feb 2018 13:03:38 -0800
Message-ID: <5a87472a.mEhLdsb/JRK9kqCi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeBPVDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 16:03:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, adobriyan@gmail.com, akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: taint: add taint for randstruct
has been added to the -mm tree.  Its filename is
     taint-add-taint-for-randstruct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taint-add-taint-for-randstruct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taint-add-taint-for-randstruct.patch

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
Subject: taint: add taint for randstruct

Since the randstruct plugin can intentionally produce extremely unusual
kernel structure layouts (even performance pathological ones), some
maintainers want to be able to trivially determine if an Oops is coming
from a randstruct-built kernel, so as to keep their sanity when debugging.
This adds the new flag and initializes taint_mask immediately when built
with randstruct.

Link: http://lkml.kernel.org/r/1518752264-47238-4-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    1 +
 include/linux/kernel.h          |    1 +
 kernel/panic.c                  |    4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~taint-add-taint-for-randstruct Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~taint-add-taint-for-randstruct
+++ a/Documentation/sysctl/kernel.txt
@@ -991,6 +991,7 @@ ORed together. The letters are seen in "
  16384 (L): A soft lockup has previously occurred on the system.
  32768 (K): The kernel has been live patched.
  65536 (X): Auxiliary taint, defined and used by for distros.
+131072 (T): The kernel was built with the struct randomization plugin.
 
 ==============================================================
 
diff -puN include/linux/kernel.h~taint-add-taint-for-randstruct include/linux/kernel.h
--- a/include/linux/kernel.h~taint-add-taint-for-randstruct
+++ a/include/linux/kernel.h
@@ -551,6 +551,7 @@ enum taint_enum {
 	TAINT_SOFTLOCKUP,
 	TAINT_LIVEPATCH,
 	TAINT_AUX,
+	TAINT_RANDSTRUCT,
 
 	/* End of taint bits */
 	TAINT_FLAGS_COUNT
diff -puN kernel/panic.c~taint-add-taint-for-randstruct kernel/panic.c
--- a/kernel/panic.c~taint-add-taint-for-randstruct
+++ a/kernel/panic.c
@@ -34,7 +34,8 @@
 #define PANIC_BLINK_SPD 18
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
-static unsigned long tainted_mask;
+static unsigned long tainted_mask =
+	IS_ENABLED(CONFIG_GCC_PLUGIN_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -325,6 +326,7 @@ const struct taint_flag taint_flags[TAIN
 	[ TAINT_SOFTLOCKUP ]		= { 'L', ' ', false },
 	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
 	[ TAINT_AUX ]			= { 'X', ' ', true },
+	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
 };
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

taint-convert-to-enum-and-indexed-initialization.patch
taint-consolidate-documentation.patch
taint-add-taint-for-randstruct.patch
exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch

