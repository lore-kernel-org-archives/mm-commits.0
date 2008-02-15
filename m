From: akpm@linux-foundation.org
Subject: + mn10300-define-hz-as-a-config-option.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:22:56 -0800
Message-ID: <200802152022.m1FKMuvC022053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578AbYBOUXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:23:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     MN10300: define HZ as a config option
has been added to the -mm tree.  Its filename is
     mn10300-define-hz-as-a-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MN10300: define HZ as a config option
From: David Howells <dhowells@redhat.com>

Define HZ as a config option.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Kconfig        |    4 ++++
 include/asm-mn10300/param.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/mn10300/Kconfig~mn10300-define-hz-as-a-config-option arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~mn10300-define-hz-as-a-config-option
+++ a/arch/mn10300/Kconfig
@@ -63,6 +63,10 @@ config GENERIC_HARDIRQS
 config HOTPLUG_CPU
 	def_bool n
 
+config HZ
+	int
+	default 1000
+
 mainmenu "Matsushita MN10300/AM33 Kernel Configuration"
 
 source "init/Kconfig"
diff -puN include/asm-mn10300/param.h~mn10300-define-hz-as-a-config-option include/asm-mn10300/param.h
--- a/include/asm-mn10300/param.h~mn10300-define-hz-as-a-config-option
+++ a/include/asm-mn10300/param.h
@@ -12,7 +12,7 @@
 #define _ASM_PARAM_H
 
 #ifdef __KERNEL__
-#define HZ		1000		/* Internal kernel timer frequency */
+#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 #define USER_HZ		100		/* .. some user interfaces are in
 					 * "ticks" */
 #define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-define-hz-as-a-config-option.patch
mn10300-define-so_mark.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
inflate-refactor-inflate-malloc-code.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
