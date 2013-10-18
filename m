From: akpm@linux-foundation.org
Subject: + init-make-init-failures-more-explicit.patch added to -mm tree
Date: Fri, 18 Oct 2013 13:22:18 -0700
Message-ID: <5261987a.bIzHXVq5z4cuS+1D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3JRUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Oct 2013 16:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, Janne.Karhunen@gmail.com, michael.opdenacker@free-electrons.com

Subject: + init-make-init-failures-more-explicit.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,Janne.Karhunen@gmail.com,geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Fri, 18 Oct 2013 13:22:18 -0700


The patch titled
     Subject: init: make init failures more explicit
has been added to the -mm tree.  Its filename is
     init-make-init-failures-more-explicit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-make-init-failures-more-explicit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-make-init-failures-more-explicit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: init: make init failures more explicit

This patch proposes to make init failures more explicit.

Before this, the "No init found" message didn't help much.  It could
sometimes be misleading and actually mean "No *working* init found".

This message could hide many different issues:
- no init program candidates found at all
- some init program candidates exist but can't be executed
  (missing execute permissions, failed to load shared libraries,
  executable compiled for an unknown architecture...)

This patch notifies the kernel user when a candidate init program is found
but can't be executed.  In each failure situation, the error code is
displayed, to quickly find the root cause.  "No init found" is also
replaced by "No working init found", which is more correct.

This will help embedded Linux developers (especially the newcomers),
regularly making and debugging new root filesystems.

Credits to Geert Uytterhoeven and Janne Karhunen for their improvement
suggestions.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Janne Karhunen <Janne.Karhunen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff -puN init/main.c~init-make-init-failures-more-explicit init/main.c
--- a/init/main.c~init-make-init-failures-more-explicit
+++ a/init/main.c
@@ -811,10 +811,26 @@ static int run_init_process(const char *
 		(const char __user *const __user *)envp_init);
 }
 
+static int try_to_run_init_process(const char *init_filename)
+{
+	int ret;
+
+	ret = run_init_process(init_filename);
+
+	if (ret && ret != -ENOENT) {
+		pr_err("Starting init: %s exists but couldn't execute it (error %d)\n",
+		       init_filename, ret);
+	}
+
+	return ret;
+}
+
 static noinline void __init kernel_init_freeable(void);
 
 static int __ref kernel_init(void *unused)
 {
+	int ret;
+
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
@@ -826,9 +842,11 @@ static int __ref kernel_init(void *unuse
 	flush_delayed_fput();
 
 	if (ramdisk_execute_command) {
-		if (!run_init_process(ramdisk_execute_command))
+		ret = run_init_process(ramdisk_execute_command);
+		if (!ret)
 			return 0;
-		pr_err("Failed to execute %s\n", ramdisk_execute_command);
+		pr_err("Failed to execute %s (error %d)\n",
+		       ramdisk_execute_command, ret);
 	}
 
 	/*
@@ -838,18 +856,19 @@ static int __ref kernel_init(void *unuse
 	 * trying to recover a really broken machine.
 	 */
 	if (execute_command) {
-		if (!run_init_process(execute_command))
+		ret = run_init_process(execute_command);
+		if (!ret)
 			return 0;
-		pr_err("Failed to execute %s.  Attempting defaults...\n",
-			execute_command);
+		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
+			execute_command, ret);
 	}
-	if (!run_init_process("/sbin/init") ||
-	    !run_init_process("/etc/init") ||
-	    !run_init_process("/bin/init") ||
-	    !run_init_process("/bin/sh"))
+	if (!try_to_run_init_process("/sbin/init") ||
+	    !try_to_run_init_process("/etc/init") ||
+	    !try_to_run_init_process("/bin/init") ||
+	    !try_to_run_init_process("/bin/sh"))
 		return 0;
 
-	panic("No init found.  Try passing init= option to kernel. "
+	panic("No working init found.  Try passing init= option to kernel. "
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
cramfs-mark-as-obsolete.patch
init-make-init-failures-more-explicit.patch
linux-next.patch

