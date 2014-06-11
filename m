From: akpm@linux-foundation.org
Subject: + fs-cachefiles-bindc-remove-unnecessary-assertions.patch added
 to -mm tree
Date: Wed, 11 Jun 2014 15:44:18 -0700
Message-ID: <5398dbc2.G1kLwLPeDjV5fgfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaFKWoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: + fs-cachefiles-bindc-remove-unnecessary-assertions.patch added to -mm tree
To: fabf@skynet.be,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:44:18 -0700


The patch titled
     Subject: fs/cachefiles/bind.c: remove unnecessary assertions
has been added to the -mm tree.  Its filename is
     fs-cachefiles-bindc-remove-unnecessary-assertions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cachefiles-bindc-remove-unnecessary-assertions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cachefiles-bindc-remove-unnecessary-assertions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cachefiles/bind.c: remove unnecessary assertions

Unsigned values are always >=0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/bind.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/cachefiles/bind.c~fs-cachefiles-bindc-remove-unnecessary-assertions fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~fs-cachefiles-bindc-remove-unnecessary-assertions
+++ a/fs/cachefiles/bind.c
@@ -39,13 +39,11 @@ int cachefiles_daemon_bind(struct cachef
 	       args);
 
 	/* start by checking things over */
-	ASSERT(cache->fstop_percent >= 0 &&
-	       cache->fstop_percent < cache->fcull_percent &&
+	ASSERT(cache->fstop_percent < cache->fcull_percent &&
 	       cache->fcull_percent < cache->frun_percent &&
 	       cache->frun_percent  < 100);
 
-	ASSERT(cache->bstop_percent >= 0 &&
-	       cache->bstop_percent < cache->bcull_percent &&
+	ASSERT(cache->bstop_percent < cache->bcull_percent &&
 	       cache->bcull_percent < cache->brun_percent &&
 	       cache->brun_percent  < 100);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

