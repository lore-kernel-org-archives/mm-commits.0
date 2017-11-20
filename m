From: akpm@linux-foundation.org
Subject: [merged] kernel-panic-add-taint_aux.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:26:20 -0800
Message-ID: <20171120212620._g7luxGTG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbdKTV0W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, jeffm@suse.com, jeyu@redhat.com, jkosina@suse.cz, jolsa@kernel.org, jslaby@suse.cz, keescook@chromium.org, mm-commits@vger.kernel.org, mmarek@suse.cz, peterz@infradead.org, pmladek@suse.com, tiwai@suse.de


The patch titled
     Subject: kernel/panic.c: add TAINT_AUX
has been removed from the -mm tree.  Its filename was
     kernel-panic-add-taint_aux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: kernel/panic.c: add TAINT_AUX

This is the gist of a patch which we've been forward-porting in our
kernels for a long time now and it probably would make a good sense to
have such TAINT_AUX flag upstream which can be used by each distro etc,
how they see fit.  This way, we won't need to forward-port a distro-only
version indefinitely.

Add an auxiliary taint flag to be used by distros and others. This
obviates the need to forward-port whatever internal solutions people
have in favor of a single flag which they can map arbitrarily to a
definition of their pleasing.

The "X" mnemonic could also mean eXternal, which would be taint from a
distro or something else but not the upstream kernel.  We will use it to
mark modules for which we don't provide support.  I.e., a really eXternal
module.

Link: http://lkml.kernel.org/r/20170911134533.dp5mtyku5bongx4c@pd.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 kernel/panic.c         |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernel-panic-add-taint_aux include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-panic-add-taint_aux
+++ a/include/linux/kernel.h
@@ -549,7 +549,8 @@ extern enum system_states {
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
 #define TAINT_LIVEPATCH			15
-#define TAINT_FLAGS_COUNT		16
+#define TAINT_AUX			16
+#define TAINT_FLAGS_COUNT		17
 
 struct taint_flag {
 	char c_true;	/* character printed when tainted */
diff -puN kernel/panic.c~kernel-panic-add-taint_aux kernel/panic.c
--- a/kernel/panic.c~kernel-panic-add-taint_aux
+++ a/kernel/panic.c
@@ -324,6 +324,7 @@ const struct taint_flag taint_flags[TAIN
 	{ 'E', ' ', true },	/* TAINT_UNSIGNED_MODULE */
 	{ 'L', ' ', false },	/* TAINT_SOFTLOCKUP */
 	{ 'K', ' ', true },	/* TAINT_LIVEPATCH */
+	{ 'X', ' ', true },	/* TAINT_AUX */
 };
 
 /**
@@ -345,6 +346,7 @@ const struct taint_flag taint_flags[TAIN
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
  *  'K' - Kernel has been live patched.
+ *  'X' - Auxiliary taint, for distros' use.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
_

Patches currently in -mm which might be from bp@suse.de are


