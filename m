From: akpm@linux-foundation.org
Subject: + cachefiles-fix-error-handling-in-cachefiles_determine_cache_security.patch added to -mm tree
Date: Wed, 12 May 2010 12:36:53 -0700
Message-ID: <201005121936.o4CJarE0016095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab0ELThD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 15:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     cachefiles: fix error handling in cachefiles_determine_cache_security()
has been added to the -mm tree.  Its filename is
     cachefiles-fix-error-handling-in-cachefiles_determine_cache_security.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cachefiles: fix error handling in cachefiles_determine_cache_security()
From: David Howells <dhowells@redhat.com>

cachefiles_determine_cache_security() is expected to return with a
security override in place.  However, if set_create_files_as() fails, we
fail to do this.  In this case, we should just reinstate the security
override that was set by the caller.

Furthermore, if set_create_files_as() fails, we should dispose of the new
credentials we were in the process of creating.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/security.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/cachefiles/security.c~cachefiles-fix-error-handling-in-cachefiles_determine_cache_security fs/cachefiles/security.c
--- a/fs/cachefiles/security.c~cachefiles-fix-error-handling-in-cachefiles_determine_cache_security
+++ a/fs/cachefiles/security.c
@@ -77,6 +77,8 @@ static int cachefiles_check_cache_dir(st
 /*
  * check the security details of the on-disk cache
  * - must be called with security override in force
+ * - must return with a security override in force - even in the case of an
+ *   error
  */
 int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
 					struct dentry *root,
@@ -99,6 +101,8 @@ int cachefiles_determine_cache_security(
 	 * which create files */
 	ret = set_create_files_as(new, root->d_inode);
 	if (ret < 0) {
+		abort_creds(new);
+		cachefiles_begin_secure(cache, _saved_cred);
 		_leave(" = %d [cfa]", ret);
 		return ret;
 	}
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
cachefiles-fix-error-handling-in-cachefiles_determine_cache_security.patch
linux-next.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
mn10300-use-generic-atomich.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

