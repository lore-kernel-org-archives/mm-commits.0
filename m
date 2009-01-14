From: akpm@linux-foundation.org
Subject: + proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch added to -mm tree
Date: Wed, 14 Jan 2009 14:08:22 -0800
Message-ID: <200901142208.n0EM8MbS018277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111AbZANWIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 17:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, mikew@google.com, yinghan@google.com


The patch titled
     /proc/pid/maps: don't show pgoff of pure ANON VMAs
has been added to the -mm tree.  Its filename is
     proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

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
Subject: /proc/pid/maps: don't show pgoff of pure ANON VMAs
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Recently, it's argued that what proc/pid/maps shows is ugly when a 32bit
binary runs on 64bit host.

/proc/pid/maps outputs vma's pgoff member but vma->pgoff is of no use
information is the vma is for ANON.  With this patch, /proc/pid/maps shows
just 0 if no file backing store.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Waychison <mikew@google.com>
Reported-by: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |    3 ++-
 fs/proc/task_nommu.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas
+++ a/fs/proc/task_mmu.c
@@ -220,7 +220,8 @@ static void show_map_vma(struct seq_file
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
+			(!vma->vm_file)? 0 :
+				((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
 	/*
diff -puN fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas
+++ a/fs/proc/task_nommu.c
@@ -143,7 +143,8 @@ static int nommu_vma_show(struct seq_fil
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   (unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
+		   (!vma->vm_file) ? 0 :
+			(unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroups-consolidate-cgroup-documents.patch
memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch
memcg-fix-error-path-of-mem_cgroup_move_parent.patch
memcg-fix-hierarchical-reclaim.patch
memcg-make-oom-less-frequently.patch
memcg-fix-section-mismatch.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

