From: akpm@linux-foundation.org
Subject: [merged] nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch removed from -mm tree
Date: Fri, 01 Mar 2013 12:47:17 -0800
Message-ID: <20130301204717.96FAE5A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:55780 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3CAUrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 15:47:19 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so378375ves.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 12:47:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfields@fieldses.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: idr_destroy() no longer needs idr_remove_all()
has been removed from the -mm tree.  Its filename was
     nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nfsd: idr_destroy() no longer needs idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop reference to idr_remove_all().

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-idr_destroy-no-longer-needs-idr_remove_all fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-idr_destroy-no-longer-needs-idr_remove_all
+++ a/fs/nfsd/nfs4state.c
@@ -1079,7 +1079,6 @@ free_client(struct nfs4_client *clp)
 	}
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
-	idr_remove_all(&clp->cl_stateids);
 	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
shmem-fix-build-regression-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

