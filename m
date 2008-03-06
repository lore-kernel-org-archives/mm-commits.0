From: akpm@linux-foundation.org
Subject: - frv-fix-up-parse-error-in-linker-script.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:30:52 -0800
Message-ID: <200803062230.m26MUq2P021687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758282AbYCFWm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     FRV: fix up parse error in linker script
has been removed from the -mm tree.  Its filename was
     frv-fix-up-parse-error-in-linker-script.patch

This patch was dropped because it is obsolete

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

git-hrt.patch
git-net.patch
git-unionfs.patch
romfs-prevent-romfs_lookup-from-always-failing.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch

