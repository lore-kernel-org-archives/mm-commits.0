From: akpm@linux-foundation.org
Subject: + mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:52:50 -0700
Message-ID: <200806252152.m5PLqovq028619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbYFYVxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, riel@redhat.com


The patch titled
     fix migration_entry_wait() for speculative page cache
has been added to the -mm tree.  Its filename is
     mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch

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
Subject: fix migration_entry_wait() for speculative page cache
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In speculative page cache lookup protocol, page_count(page) is set to 0
while radix-tree modification is going on, truncation, migration, etc...

While page migration, a page fault to page under migration should wait
unlock_page() and migration_entry_wait() waits for the page from its pte
entry.  It does get_page() -> wait_on_page_locked() -> put_page() now.

In page migration, page_freeze_refs() -> page_unfreeze_refs() is called.

Here, page_unfreeze_refs() expects page_count(page) == 0 and panics if
page_count(page) != 0.  To avoid this, we shouldn't touch page_count() if
it is zero.  This patch uses page_cache_get_speculative() to avoid the
panic.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache mm/migrate.c
--- a/mm/migrate.c~mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache
+++ a/mm/migrate.c
@@ -285,7 +285,15 @@ void migration_entry_wait(struct mm_stru
 
 	page = migration_entry_to_page(entry);
 
-	get_page(page);
+	/*
+	 * Once radix-tree replacement of page migration started, page_count
+	 * *must* be zero. And, we don't want to call wait_on_page_locked()
+	 * against a page without get_page().
+	 * So, we use get_page_unless_zero(), here. Even failed, page fault
+	 * will occur again.
+	 */
+	if (!get_page_unless_zero(page))
+		goto out;
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch

