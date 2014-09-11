From: akpm@linux-foundation.org
Subject: + fsnotify-dont-put-user-context-if-it-was-never-assigned.patch
 added to -mm tree
Date: Thu, 11 Sep 2014 13:44:48 -0700
Message-ID: <541209c0.wU3kzwIW6L7/AE2+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaIKUot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 16:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: don't put user context if it was never assigned
has been added to the -mm tree.  Its filename is
     fsnotify-dont-put-user-context-if-it-was-never-assigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-dont-put-user-context-if-it-was-never-assigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-dont-put-user-context-if-it-was-never-assigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: fsnotify: don't put user context if it was never assigned

On some failure paths we may attempt to free user context even if it
wasn't assigned yet.  This will cause a NULL ptr deref and a kernel BUG.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Reviewed-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-dont-put-user-context-if-it-was-never-assigned fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-dont-put-user-context-if-it-was-never-assigned
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -165,8 +165,10 @@ static void inotify_free_group_priv(stru
 	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_destroy(&group->inotify_data.idr);
-	atomic_dec(&group->inotify_data.user->inotify_devs);
-	free_uid(group->inotify_data.user);
+	if (group->inotify_data.user) {
+		atomic_dec(&group->inotify_data.user->inotify_devs);
+		free_uid(group->inotify_data.user);
+	}
 }
 
 static void inotify_free_event(struct fsnotify_event *fsn_event)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fsnotify-dont-put-user-context-if-it-was-never-assigned.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-dump_vma-fix-2.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

