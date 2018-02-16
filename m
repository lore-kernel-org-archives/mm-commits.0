From: akpm@linux-foundation.org
Subject: + taint-convert-to-enum-and-indexed-initialization.patch added to -mm tree
Date: Fri, 16 Feb 2018 13:03:32 -0800
Message-ID: <5a874724.yvZbsRznE6rrzRLj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeBPVDd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 16:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, adobriyan@gmail.com, akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: taint: convert to enum and indexed initialization
has been added to the -mm tree.  Its filename is
     taint-convert-to-enum-and-indexed-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taint-convert-to-enum-and-indexed-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taint-convert-to-enum-and-indexed-initialization.patch

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
Subject: taint: convert to enum and indexed initialization

This converts the taint bit defines to an enum, uses indexed initializers
instead of comments, and make sure that no one forgets to update the
taint_flags when adding new bits.

Link: http://lkml.kernel.org/r/1518752264-47238-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   40 +++++++++++++++++++++------------------
 kernel/panic.c         |   36 ++++++++++++++++++-----------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff -puN include/linux/kernel.h~taint-convert-to-enum-and-indexed-initialization include/linux/kernel.h
--- a/include/linux/kernel.h~taint-convert-to-enum-and-indexed-initialization
+++ a/include/linux/kernel.h
@@ -533,24 +533,28 @@ extern enum system_states {
 	SYSTEM_RESTART,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_CPU_OUT_OF_SPEC		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-#define TAINT_FIRMWARE_WORKAROUND	11
-#define TAINT_OOT_MODULE		12
-#define TAINT_UNSIGNED_MODULE		13
-#define TAINT_SOFTLOCKUP		14
-#define TAINT_LIVEPATCH			15
-#define TAINT_AUX			16
-#define TAINT_FLAGS_COUNT		17
+enum taint_enum {
+	TAINT_PROPRIETARY_MODULE = 0,
+	TAINT_FORCED_MODULE,
+	TAINT_CPU_OUT_OF_SPEC,
+	TAINT_FORCED_RMMOD,
+	TAINT_MACHINE_CHECK,
+	TAINT_BAD_PAGE,
+	TAINT_USER,
+	TAINT_DIE,
+	TAINT_OVERRIDDEN_ACPI_TABLE,
+	TAINT_WARN,
+	TAINT_CRAP,
+	TAINT_FIRMWARE_WORKAROUND,
+	TAINT_OOT_MODULE,
+	TAINT_UNSIGNED_MODULE,
+	TAINT_SOFTLOCKUP,
+	TAINT_LIVEPATCH,
+	TAINT_AUX,
+
+	/* End of taint bits */
+	TAINT_FLAGS_COUNT
+};
 
 struct taint_flag {
 	char c_true;	/* character printed when tainted */
diff -puN kernel/panic.c~taint-convert-to-enum-and-indexed-initialization kernel/panic.c
--- a/kernel/panic.c~taint-convert-to-enum-and-indexed-initialization
+++ a/kernel/panic.c
@@ -308,23 +308,23 @@ EXPORT_SYMBOL(panic);
  * is being removed anyway.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
-	{ 'P', 'G', true },	/* TAINT_PROPRIETARY_MODULE */
-	{ 'F', ' ', true },	/* TAINT_FORCED_MODULE */
-	{ 'S', ' ', false },	/* TAINT_CPU_OUT_OF_SPEC */
-	{ 'R', ' ', false },	/* TAINT_FORCED_RMMOD */
-	{ 'M', ' ', false },	/* TAINT_MACHINE_CHECK */
-	{ 'B', ' ', false },	/* TAINT_BAD_PAGE */
-	{ 'U', ' ', false },	/* TAINT_USER */
-	{ 'D', ' ', false },	/* TAINT_DIE */
-	{ 'A', ' ', false },	/* TAINT_OVERRIDDEN_ACPI_TABLE */
-	{ 'W', ' ', false },	/* TAINT_WARN */
-	{ 'C', ' ', true },	/* TAINT_CRAP */
-	{ 'I', ' ', false },	/* TAINT_FIRMWARE_WORKAROUND */
-	{ 'O', ' ', true },	/* TAINT_OOT_MODULE */
-	{ 'E', ' ', true },	/* TAINT_UNSIGNED_MODULE */
-	{ 'L', ' ', false },	/* TAINT_SOFTLOCKUP */
-	{ 'K', ' ', true },	/* TAINT_LIVEPATCH */
-	{ 'X', ' ', true },	/* TAINT_AUX */
+	[ TAINT_PROPRIETARY_MODULE ]	= { 'P', 'G', true },
+	[ TAINT_FORCED_MODULE ]		= { 'F', ' ', true },
+	[ TAINT_CPU_OUT_OF_SPEC ]	= { 'S', ' ', false },
+	[ TAINT_FORCED_RMMOD ]		= { 'R', ' ', false },
+	[ TAINT_MACHINE_CHECK ]		= { 'M', ' ', false },
+	[ TAINT_BAD_PAGE ]		= { 'B', ' ', false },
+	[ TAINT_USER ]			= { 'U', ' ', false },
+	[ TAINT_DIE ]			= { 'D', ' ', false },
+	[ TAINT_OVERRIDDEN_ACPI_TABLE ]	= { 'A', ' ', false },
+	[ TAINT_WARN ]			= { 'W', ' ', false },
+	[ TAINT_CRAP ]			= { 'C', ' ', true },
+	[ TAINT_FIRMWARE_WORKAROUND ]	= { 'I', ' ', false },
+	[ TAINT_OOT_MODULE ]		= { 'O', ' ', true },
+	[ TAINT_UNSIGNED_MODULE ]	= { 'E', ' ', true },
+	[ TAINT_SOFTLOCKUP ]		= { 'L', ' ', false },
+	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
+	[ TAINT_AUX ]			= { 'X', ' ', true },
 };
 
 /**
@@ -354,6 +354,8 @@ const char *print_tainted(void)
 {
 	static char buf[TAINT_FLAGS_COUNT + sizeof("Tainted: ")];
 
+	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
+
 	if (tainted_mask) {
 		char *s;
 		int i;
_

Patches currently in -mm which might be from keescook@chromium.org are

taint-convert-to-enum-and-indexed-initialization.patch
taint-consolidate-documentation.patch
taint-add-taint-for-randstruct.patch
exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch

