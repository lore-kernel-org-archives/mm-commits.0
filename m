From: akpm@linux-foundation.org
Subject: - genalloc-warning-fixes.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:21 -0800
Message-ID: <200702211046.l1LAkLaA006460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46936 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbXBUKq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:26 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1LAkLhB016022
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2007 02:46:21 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     genalloc warning fixes
has been removed from the -mm tree.  Its filename was
     genalloc-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genalloc warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

lib/genalloc.c: In function 'gen_pool_alloc':
lib/genalloc.c:151: warning: passing argument 2 of '__set_bit' from incompatible pointer type
lib/genalloc.c: In function 'gen_pool_free':
lib/genalloc.c:190: warning: passing argument 2 of '__clear_bit' from incompatible pointer type


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/genalloc.c~genalloc-warning-fixes lib/genalloc.c
--- a/lib/genalloc.c~genalloc-warning-fixes
+++ a/lib/genalloc.c
@@ -148,7 +148,7 @@ unsigned long gen_pool_alloc(struct gen_
 			addr = chunk->start_addr +
 					    ((unsigned long)start_bit << order);
 			while (nbits--)
-				__set_bit(start_bit++, &chunk->bits);
+				__set_bit(start_bit++, chunk->bits);
 			spin_unlock_irqrestore(&chunk->lock, flags);
 			read_unlock(&pool->lock);
 			return addr;
@@ -187,7 +187,7 @@ void gen_pool_free(struct gen_pool *pool
 			spin_lock_irqsave(&chunk->lock, flags);
 			bit = (addr - chunk->start_addr) >> order;
 			while (nbits--)
-				__clear_bit(bit++, &chunk->bits);
+				__clear_bit(bit++, chunk->bits);
 			spin_unlock_irqrestore(&chunk->lock, flags);
 			break;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
