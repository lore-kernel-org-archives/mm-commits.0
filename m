From: akpm@linux-foundation.org
Subject: + frv-move-stack_top_max-up.patch added to -mm tree
Date: Thu, 10 Apr 2008 13:46:18 -0700
Message-ID: <200804102046.m3AKkIpx016692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727AbYDJUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: move STACK_TOP_MAX up
has been added to the -mm tree.  Its filename is
     frv-move-stack_top_max-up.patch

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
Subject: frv: move STACK_TOP_MAX up
From: David Howells <dhowells@redhat.com>

Move STACK_TOP_MAX up so that we don't try moving the stack above it as that
causes setup_arg_pages() to malfunction.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/mem-layout.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-frv/mem-layout.h~frv-move-stack_top_max-up include/asm-frv/mem-layout.h
--- a/include/asm-frv/mem-layout.h~frv-move-stack_top_max-up
+++ a/include/asm-frv/mem-layout.h
@@ -60,7 +60,7 @@
  */
 #define BRK_BASE			__UL(2 * 1024 * 1024 + PAGE_SIZE)
 #define STACK_TOP			__UL(2 * 1024 * 1024)
-#define STACK_TOP_MAX	STACK_TOP
+#define STACK_TOP_MAX			__UL(0xc0000000)
 
 /* userspace process size */
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch
frv-move-stack_top_max-up.patch
frv-add-support-for-emulation-of-userspace-atomic-ops.patch
frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch
frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch
remove-the-macro-get_personality.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
mutex-subsystem-synchro-test-module.patch

