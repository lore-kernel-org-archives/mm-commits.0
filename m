From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 13:45:11 -0700
Message-ID: <53a49d57.aH265o348GPQHF6C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaFTUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 16:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, fengguang.wu@intel.com


The patch titled
     Subject: ocfs2/dlm: dlm_lockres_grab_inflight_worker() can be static
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: ocfs2/dlm: dlm_lockres_grab_inflight_worker() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -694,7 +694,7 @@ void __dlm_lockres_grab_inflight_worker(
 			res->inflight_assert_workers);
 }
 
-void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+static void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
 		struct dlm_lock_resource *res)
 {
 	spin_lock(&res->spinlock);
@@ -702,7 +702,7 @@ void dlm_lockres_grab_inflight_worker(st
 	spin_unlock(&res->spinlock);
 }
 
-void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+static void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
 		struct dlm_lock_resource *res)
 {
 	assert_spin_locked(&res->spinlock);
@@ -713,7 +713,7 @@ void __dlm_lockres_drop_inflight_worker(
 			res->inflight_assert_workers);
 }
 
-void dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+static void dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
 		struct dlm_lock_resource *res)
 {
 	spin_lock(&res->spinlock);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

kexec-save-pg_head_mask-in-vmcoreinfo.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
add-lib-globc-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

