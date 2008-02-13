From: akpm@linux-foundation.org
Subject: + frv-fix-up-parse-error-in-linker-script.patch added to -mm tree
Date: Wed, 13 Feb 2008 11:28:18 -0800
Message-ID: <200802131928.m1DJSLfj009468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755590AbYBMT3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 14:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, sam@ravnborg.org


The patch titled
     FRV: fix up parse error in linker script
has been added to the -mm tree.  Its filename is
     frv-fix-up-parse-error-in-linker-script.patch

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
Subject: FRV: fix up parse error in linker script
From: David Howells <dhowells@redhat.com>

Fix up parse error in FRV linker script, presumably introduced through
changes to the INIT_TEXT and EXIT_TEXT macros.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/vmlinux.lds.S |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/frv/kernel/vmlinux.lds.S~frv-fix-up-parse-error-in-linker-script arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~frv-fix-up-parse-error-in-linker-script
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -105,11 +105,9 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
-	*(
 	INIT_TEXT
 	EXIT_TEXT
-	.exitcall.exit
-	)
+	*(.exitcall.exit)
 #endif
 	*(.fixup)
 	*(.gnu.warning)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fix-frv-cmpxchg_local.patch
final-removal-of-fastcall-fastcall.patch
frv-fix-up-parse-error-in-linker-script.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
