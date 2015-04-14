From: akpm@linux-foundation.org
Subject: [folded-merged]
 cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:16:36 -0700
Message-ID: <552d91c4.PRwcA11P1PU7Kp6w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbDNWQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix
has been removed from the -mm tree.  Its filename was
     cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch

This patch was dropped because it was folded into cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix

I admit the synchronization between cleancache_register_ops and
cleancache_init_fs is far not obvious.  I should have updated the comment
instead of merely dropping it, sorry.  What about the following patch
proving correctness of register_ops-vs-init_fs synchronization?  It is
meant to be applied incrementally on top of patch #4.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cleancache.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff -puN mm/cleancache.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix mm/cleancache.c
--- a/mm/cleancache.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix
+++ a/mm/cleancache.c
@@ -54,6 +54,57 @@ int cleancache_register_ops(struct clean
 	if (cmpxchg(&cleancache_ops, NULL, ops))
 		return -EBUSY;
 
+	/*
+	 * A cleancache backend can be built as a module and hence loaded after
+	 * a cleancache enabled filesystem has called cleancache_init_fs. To
+	 * handle such a scenario, here we call ->init_fs or ->init_shared_fs
+	 * for each active super block. To differentiate between local and
+	 * shared filesystems, we temporarily initialize sb->cleancache_poolid
+	 * to CLEANCACHE_NO_BACKEND or CLEANCACHE_NO_BACKEND_SHARED
+	 * respectively in case there is no backend registered at the time
+	 * cleancache_init_fs or cleancache_init_shared_fs is called.
+	 *
+	 * Since filesystems can be mounted concurrently with cleancache
+	 * backend registration, we have to be careful to guarantee that all
+	 * cleancache enabled filesystems that has been mounted by the time
+	 * cleancache_register_ops is called has got and all mounted later will
+	 * get cleancache_poolid. This is assured by the following statements
+	 * tied together:
+	 *
+	 * a) iterate_supers skips only those super blocks that has started
+	 *    ->kill_sb
+	 *
+	 * b) if iterate_supers encounters a super block that has not finished
+	 *    ->mount yet, it waits until it is finished
+	 *
+	 * c) cleancache_init_fs is called from ->mount and
+	 *    cleancache_invalidate_fs is called from ->kill_sb
+	 *
+	 * d) we call iterate_supers after cleancache_ops has been set
+	 *
+	 * From a) it follows that if iterate_supers skips a super block, then
+	 * either the super block is already dead, in which case we do not need
+	 * to bother initializing cleancache for it, or it was mounted after we
+	 * initiated iterate_supers. In the latter case, it must have seen
+	 * cleancache_ops set according to d) and initialized cleancache from
+	 * ->mount by itself according to c). This proves that we call
+	 * ->init_fs at least once for each active super block.
+	 *
+	 * From b) and c) it follows that if iterate_supers encounters a super
+	 * block that has already started ->init_fs, it will wait until ->mount
+	 * and hence ->init_fs has finished, then check cleancache_poolid, see
+	 * that it has already been set and therefore do nothing. This proves
+	 * that we call ->init_fs no more than once for each super block.
+	 *
+	 * Combined together, the last two paragraphs prove the function
+	 * correctness.
+	 *
+	 * Note that various cleancache callbacks may proceed before this
+	 * function is called or even concurrently with it, but since
+	 * CLEANCACHE_NO_BACKEND is negative, they will all result in a noop
+	 * until the corresponding ->init_fs has been actually called and
+	 * cleancache_ops has been set.
+	 */
 	iterate_supers(cleancache_register_ops_sb, NULL);
 	return 0;
 }
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch

