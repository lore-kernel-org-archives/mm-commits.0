From: akpm@linux-foundation.org
Subject: +
 cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch added to -mm tree
Date: Wed, 25 Feb 2015 14:41:24 -0800
Message-ID: <54ee4f94.SWgSpKjtzMPHTK/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbbBYWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix
has been added to the -mm tree.  Its filename is
     cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

