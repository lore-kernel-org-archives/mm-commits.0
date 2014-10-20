From: akpm@linux-foundation.org
Subject: +
 init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch
 added to -mm tree
Date: Mon, 20 Oct 2014 14:28:40 -0700
Message-ID: <54457e88.n/4AEwYW8yB7DEou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaJTV2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, cebbert.lkml@gmail.com, frowand.list@gmail.com, josh@joshtriplett.org, rdunlap@infradead.org, rob@landley.net, rusty@rustcorp.com.au, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init: allow CONFIG_INIT_FALLBACK=n to disable defaults if init= fails
has been added to the -mm tree.  Its filename is
     init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: init: allow CONFIG_INIT_FALLBACK=n to disable defaults if init= fails

If a user puts init=/whatever on the command line and /whatever can't be
run, then the kernel will try a few default options before giving up.  If
init=/whatever came from a bootloader prompt, then this is unexpected but
probably harmless.  On the other hand, if it comes from a script (e.g.  a
tool like virtme or perhaps a future kselftest script), then the fallbacks
are likely to exist, but they'll do the wrong thing.  For example, they
might unexpectedly invoke systemd.

This adds a config option CONFIG_INIT_FALLBACK.  If unset, then a failure
to run the specified init= process be fatal.

The intent is to switch the default to N after a while and to possibly
even remove the option entirely

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Rob Landley <rob@landley.net>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ++++++++++++++++
 init/main.c  |    7 ++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails init/Kconfig
--- a/init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails
+++ a/init/Kconfig
@@ -1299,6 +1299,22 @@ source "usr/Kconfig"
 
 endif
 
+config INIT_FALLBACK
+	bool "Fall back to defaults if init= parameter is bad"
+	default y
+	help
+	  If enabled, the kernel will try the default init binaries if an
+	  explicit request from the init= parameter fails.
+
+	  This can have unexpected effects.  For example, booting
+	  with init=/sbin/kiosk_app will run /sbin/init or even /bin/sh
+	  if /sbin/kiosk_app cannot be executed.
+
+	  The default value of Y is consistent with historical behavior.
+	  Selecting N is likely to be more appropriate for most uses,
+	  especially on kiosks and on kernels that are indended to be
+	  run under the control of a script.
+
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
diff -puN init/main.c~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails init/main.c
--- a/init/main.c~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails
+++ a/init/main.c
@@ -959,8 +959,13 @@ static int __ref kernel_init(void *unuse
 		ret = run_init_process(execute_command);
 		if (!ret)
 			return 0;
+#ifndef CONFIG_INIT_FALLBACK
+		panic("Requested init %s failed (error %d).",
+		      execute_command, ret);
+#else
 		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
-			execute_command, ret);
+		       execute_command, ret);
+#endif
 	}
 	if (!try_to_run_init_process("/sbin/init") ||
 	    !try_to_run_init_process("/etc/init") ||
_

Patches currently in -mm which might be from luto@amacapital.net are

init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch

