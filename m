From: akpm@linux-foundation.org
Subject: + security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:09:40 -0700
Message-ID: <20120329210940.A75B6A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53401 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576Ab2C2VJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:09:43 -0400
Received: by wibhj13 with SMTP id hj13so438wib.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:09:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     Subject: security/keys/keyctl.c: suppress memory allocation failure warning	
has been added to the -mm tree.  Its filename is
     security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: security/keys/keyctl.c: suppress memory allocation failure warning	

This allocation may be large.  The code is probing to see if it will
succeed and if not, it falls back to vmalloc().  We should suppress any
page-allocation failure messages when the fallback happens.

Reported-by: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/keys/keyctl.c~security-keys-keyctlc-suppress-memory-allocation-failure-warning security/keys/keyctl.c
--- a/security/keys/keyctl.c~security-keys-keyctlc-suppress-memory-allocation-failure-warning
+++ a/security/keys/keyctl.c
@@ -84,7 +84,7 @@ SYSCALL_DEFINE5(add_key, const char __us
 	vm = false;
 	if (_payload) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
+		payload = kmalloc(plen, GFP_KERNEL | __GFP_NOWARN);
 		if (!payload) {
 			if (plen <= PAGE_SIZE)
 				goto error2;
_
Subject: Subject: security/keys/keyctl.c: suppress memory allocation failure warning	

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

