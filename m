From: akpm@linux-foundation.org
Subject: [merged]
 userns-unshare_usernscred-should-not-populate-cred-on-failure.patch removed from -mm tree
Date: Wed, 07 Aug 2013 13:07:59 -0700
Message-ID: <5202a91f.pzQD4ViO8oL9lcFV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3HGUIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, pmatouse@redhat.com, luto@amacapital.net, ebiederm@xmission.com, dhowells@redhat.com, oleg@redhat.com

Subject: [merged] userns-unshare_usernscred-should-not-populate-cred-on-failure.patch removed from -mm tree
To: oleg@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,luto@amacapital.net,pmatouse@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:07:59 -0700


The patch titled
     Subject: userns: unshare_userns(&cred) should not populate cred on failure
has been removed from the -mm tree.  Its filename was
     userns-unshare_usernscred-should-not-populate-cred-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: userns: unshare_userns(&cred) should not populate cred on failure

unshare_userns(new_cred) does *new_cred = prepare_creds() before
create_user_ns() which can fail.  However, the caller expects that it
doesn't need to take care of new_cred if unshare_userns() fails.

We could change the single caller, sys_unshare(), but I think it would be
more clean to avoid the side effects on failure, so with this patch
unshare_userns() does put_cred() itself and initializes *new_cred only if
create_user_ns() succeeeds.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN kernel/user_namespace.c~userns-unshare_usernscred-should-not-populate-cred-on-failure kernel/user_namespace.c
--- a/kernel/user_namespace.c~userns-unshare_usernscred-should-not-populate-cred-on-failure
+++ a/kernel/user_namespace.c
@@ -105,16 +105,21 @@ int create_user_ns(struct cred *new)
 int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 {
 	struct cred *cred;
+	int err = -ENOMEM;
 
 	if (!(unshare_flags & CLONE_NEWUSER))
 		return 0;
 
 	cred = prepare_creds();
-	if (!cred)
-		return -ENOMEM;
+	if (cred) {
+		err = create_user_ns(cred);
+		if (err)
+			put_cred(cred);
+		else
+			*new_cred = cred;
+	}
 
-	*new_cred = cred;
-	return create_user_ns(cred);
+	return err;
 }
 
 void free_user_ns(struct user_namespace *ns)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

