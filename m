From: akpm@linux-foundation.org
Subject: + genalloc-warning-fixes.patch added to -mm tree
Date: Thu, 15 Feb 2007 02:37:37 -0800
Message-ID: <200702151038.l1FAcr8b027143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965820AbXBOKi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 05:38:59 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1FAcrhB007903
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2007 02:38:53 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     genalloc warning fixes
has been added to the -mm tree.  Its filename is
     genalloc-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
git-block-vs-ext4-ext4-delayed-allocation.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
genalloc-warning-fixes.patch
