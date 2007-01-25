From: akpm@osdl.org
Subject: + uml-fix-style-violations.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:03:49 -0800
Message-ID: <200701250603.l0P63nNN007587@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXAYGDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: fix style violations
has been added to the -mm tree.  Its filename is
     uml-fix-style-violations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix style violations
From: Jeff Dike <jdike@addtoit.com>

Fix a bunch of style violations in mem.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/os-Linux/mem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/mem.c~uml-fix-style-violations arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-fix-style-violations
+++ a/arch/um/os-Linux/mem.c
@@ -35,7 +35,8 @@ static void __init find_tempdir(void)
 	int i;
 	char *dir = NULL;
 
-	if(tempdir != NULL) return;	/* We've already been called */
+	if(tempdir != NULL) /* We've already been called */
+		return;
 	for(i = 0; dirs[i]; i++){
 		dir = getenv(dirs[i]);
 		if((dir != NULL) && (*dir != '\0'))
@@ -193,7 +194,7 @@ int make_tempfile(const char *template, 
 	} else {
 		free(tempname);
 	}
-	return(fd);
+	return fd;
 out:
 	free(tempname);
 	return -1;
@@ -238,7 +239,7 @@ int create_tmp_file(unsigned long long l
 		exit(1);
 	}
 
-	return(fd);
+	return fd;
 }
 
 int create_mem_file(unsigned long long len)
@@ -252,7 +253,7 @@ int create_mem_file(unsigned long long l
 		errno = -err;
 		perror("exec_close");
 	}
-	return(fd);
+	return fd;
 }
 
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

fix-uml-on-non-standard-vm-split-hosts.patch
uml-fix-mknod.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
