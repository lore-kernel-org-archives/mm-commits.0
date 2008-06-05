From: akpm@linux-foundation.org
Subject: + cgroup-anotate-two-variables-with-__read_mostly.patch added to -mm tree
Date: Wed, 04 Jun 2008 23:30:46 -0700
Message-ID: <200806050630.m556Ukjt029553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYFEGb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 02:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: anotate two variables with __read_mostly
has been added to the -mm tree.  Its filename is
     cgroup-anotate-two-variables-with-__read_mostly.patch

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
Subject: cgroup: anotate two variables with __read_mostly
From: Li Zefan <lizf@cn.fujitsu.com>

- need_forkexit_callback will be read only after system boot.
- use_task_css_set_links will be read only after it's set.

And these 2 variables are checked when a new process is forked.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-anotate-two-variables-with-__read_mostly kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-anotate-two-variables-with-__read_mostly
+++ a/kernel/cgroup.c
@@ -118,7 +118,7 @@ static int root_count;
  * extra work in the fork/exit path if none of the subsystems need to
  * be called.
  */
-static int need_forkexit_callback;
+static int need_forkexit_callback __read_mostly;
 static int need_mm_owner_callback __read_mostly;
 
 /* convenient tests for these bits */
@@ -220,7 +220,7 @@ static struct hlist_head *css_set_hash(s
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
  * compiled into their kernel but not actually in use */
-static int use_task_css_set_links;
+static int use_task_css_set_links __read_mostly;
 
 /* When we create or destroy a css_set, the operation simply
  * takes/releases a reference count on all the cgroups referenced
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
git-leds.patch
scsi-libiscsic-return-errno-rather-than-errno.patch
call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

