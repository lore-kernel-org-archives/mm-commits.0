From: akpm@linux-foundation.org
Subject: + mm-slabc-add-__init-to-init_lock_keys.patch added to -mm tree
Date: Wed, 11 Jun 2014 14:32:33 -0700
Message-ID: <5398caf1.q7orO5wgoNjz4V9y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaFKVce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, fabf@skynet.be

Subject: + mm-slabc-add-__init-to-init_lock_keys.patch added to -mm tree
To: fabf@skynet.be,cl@linux.com,iamjoonsoo.kim@lge.com,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:32:33 -0700


The patch titled
     Subject: mm/slab.c: add __init to init_lock_keys
has been added to the -mm tree.  Its filename is
     mm-slabc-add-__init-to-init_lock_keys.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabc-add-__init-to-init_lock_keys.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabc-add-__init-to-init_lock_keys.patch

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
Subject: mm/slab.c: add __init to init_lock_keys

init_lock_keys is only called by __init kmem_cache_init_late

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slabc-add-__init-to-init_lock_keys mm/slab.c
--- a/mm/slab.c~mm-slabc-add-__init-to-init_lock_keys
+++ a/mm/slab.c
@@ -536,7 +536,7 @@ static inline void on_slab_lock_classes(
 		on_slab_lock_classes_node(cachep, node);
 }
 
-static inline void init_lock_keys(void)
+static inline void __init init_lock_keys(void)
 {
 	int node;
 
@@ -544,7 +544,7 @@ static inline void init_lock_keys(void)
 		init_node_lock_keys(node);
 }
 #else
-static void init_node_lock_keys(int q)
+static void __init init_node_lock_keys(int q)
 {
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

