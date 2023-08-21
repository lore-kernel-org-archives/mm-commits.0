Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DF8EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjHUUra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjHUUrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25610194
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0581C6350E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DA5C433C7;
        Mon, 21 Aug 2023 20:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650828;
        bh=RYORxy2XNZxt9D6jfruZnEwVMISEfXecnMz7CCP/Y9w=;
        h=Date:To:From:Subject:From;
        b=sYh/w92DA4e9b2x8A0xDGJd6+t1ho10ZyOndTEc0Yf04s2Gp/tk9QuQ7yiQFAc6Ns
         06Ju0pNXtpYtsBqaZAy9pZkNM1p1wnUAofaUCzFpQU4Ue7MOhS7OPK0wn/NGeVWUx2
         zvJRjL2Tk6AoIR4dkoV9kl45FkNOIwrEU26LLgjQ=
Date:   Mon, 21 Aug 2023 13:47:07 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oleg@redhat.com, koct9i@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, brauner@kernel.org,
        mjguzik@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-fork-stop-playing-lockless-games-for-exe_file-replacement.patch removed from -mm tree
Message-Id: <20230821204708.57DA5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/fork: stop playing lockless games for exe_file replacement
has been removed from the -mm tree.  Its filename was
     kernel-fork-stop-playing-lockless-games-for-exe_file-replacement.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: kernel/fork: stop playing lockless games for exe_file replacement
Date: Mon, 14 Aug 2023 19:21:40 +0200

xchg originated in 6e399cd144d8 ("prctl: avoid using mmap_sem for exe_file
serialization").  While the commit message does not explain *why* the
change, I found the original submission [1] which ultimately claims it
cleans things up by removing dependency of exe_file on the semaphore.

However, fe69d560b5bd ("kernel/fork: always deny write access to current
MM exe_file") added a semaphore up/down cycle to synchronize the state of
exe_file against fork, defeating the point of the original change.

This is on top of semaphore trips already present both in the replacing
function and prctl (the only consumer).

Normally replacing exe_file does not happen for busy processes, thus
write-locking is not an impediment to performance in the intended use
case.  If someone keeps invoking the routine for a busy processes they are
trying to play dirty and that's another reason to avoid any trickery.

As such I think the atomic here only adds complexity for no benefit.

Just write-lock around the replacement.

I also note that replacement races against the mapping check loop as
nothing synchronizes actual assignment with with said checks but I am not
addressing it in this patch.  (Is the loop of any use to begin with?)

Link: https://lore.kernel.org/linux-mm/1424979417.10344.14.camel@stgolabs.net/ [1]
Link: https://lkml.kernel.org/r/20230814172140.1777161-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    4 ++--
 kernel/fork.c |   22 +++++++++-------------
 2 files changed, 11 insertions(+), 15 deletions(-)

--- a/fs/exec.c~kernel-fork-stop-playing-lockless-games-for-exe_file-replacement
+++ a/fs/exec.c
@@ -1276,8 +1276,8 @@ int begin_new_exec(struct linux_binprm *
 
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
-	 * not visible until then. This also enables the update
-	 * to be lockless.
+	 * not visible until then. Doing it here also ensures
+	 * we don't race against replace_mm_exe_file().
 	 */
 	retval = set_mm_exe_file(bprm->mm, bprm->file);
 	if (retval)
--- a/kernel/fork.c~kernel-fork-stop-playing-lockless-games-for-exe_file-replacement
+++ a/kernel/fork.c
@@ -1396,8 +1396,8 @@ EXPORT_SYMBOL_GPL(mmput_async);
  * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
  *
  * Main users are mmput() and sys_execve(). Callers prevent concurrent
- * invocations: in mmput() nobody alive left, in execve task is single
- * threaded.
+ * invocations: in mmput() nobody alive left, in execve it happens before
+ * the new mm is made visible to anyone.
  *
  * Can only fail if new_exe_file != NULL.
  */
@@ -1432,9 +1432,7 @@ int set_mm_exe_file(struct mm_struct *mm
 /**
  * replace_mm_exe_file - replace a reference to the mm's executable file
  *
- * This changes mm's executable file (shown as symlink /proc/[pid]/exe),
- * dealing with concurrent invocation and without grabbing the mmap lock in
- * write mode.
+ * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
  *
  * Main user is sys_prctl(PR_SET_MM_MAP/EXE_FILE).
  */
@@ -1464,22 +1462,20 @@ int replace_mm_exe_file(struct mm_struct
 			return ret;
 	}
 
-	/* set the new file, lockless */
 	ret = deny_write_access(new_exe_file);
 	if (ret)
 		return -EACCES;
 	get_file(new_exe_file);
 
-	old_exe_file = xchg(&mm->exe_file, new_exe_file);
+	/* set the new file */
+	mmap_write_lock(mm);
+	old_exe_file = rcu_dereference_raw(mm->exe_file);
+	rcu_assign_pointer(mm->exe_file, new_exe_file);
+	mmap_write_unlock(mm);
+
 	if (old_exe_file) {
-		/*
-		 * Don't race with dup_mmap() getting the file and disallowing
-		 * write access while someone might open the file writable.
-		 */
-		mmap_read_lock(mm);
 		allow_write_access(old_exe_file);
 		fput(old_exe_file);
-		mmap_read_unlock(mm);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from mjguzik@gmail.com are


