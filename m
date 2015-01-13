From: akpm@linux-foundation.org
Subject: + fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 15:49:33 -0800
Message-ID: <54b5af0d.hYCDu+Qq5/1d/Ng6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbAMXte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 18:49:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/namespace: convert devname allocation to kstrdup_const
has been added to the -mm tree.  Its filename is
     fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: fs/namespace: convert devname allocation to kstrdup_const

VFS frequently performs duplication of strings located in read-only memory
section.  Replacing kstrdup by kstrdup_const allows to avoid such
operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/namespace.c~fs-namespace-convert-devname-allocation-to-kstrdup_const fs/namespace.c
--- a/fs/namespace.c~fs-namespace-convert-devname-allocation-to-kstrdup_const
+++ a/fs/namespace.c
@@ -201,7 +201,7 @@ static struct mount *alloc_vfsmnt(const
 			goto out_free_cache;
 
 		if (name) {
-			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+			mnt->mnt_devname = kstrdup_const(name, GFP_KERNEL);
 			if (!mnt->mnt_devname)
 				goto out_free_id;
 		}
@@ -234,7 +234,7 @@ static struct mount *alloc_vfsmnt(const
 
 #ifdef CONFIG_SMP
 out_free_devname:
-	kfree(mnt->mnt_devname);
+	kfree_const(mnt->mnt_devname);
 #endif
 out_free_id:
 	mnt_free_id(mnt);
@@ -568,7 +568,7 @@ int sb_prepare_remount_readonly(struct s
 
 static void free_vfsmnt(struct mount *mnt)
 {
-	kfree(mnt->mnt_devname);
+	kfree_const(mnt->mnt_devname);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
 #endif
_

Patches currently in -mm which might be from a.hajda@samsung.com are

mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

