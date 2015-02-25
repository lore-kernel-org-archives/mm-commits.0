From: akpm@linux-foundation.org
Subject: + ocfs2-copy-fs-uuid-to-superblock.patch added to -mm tree
Date: Wed, 25 Feb 2015 14:41:16 -0800
Message-ID: <54ee4f8c.vJhLtmQ42dproSUN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbBYWlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:41:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: copy fs uuid to superblock
has been added to the -mm tree.  Its filename is
     ocfs2-copy-fs-uuid-to-superblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-copy-fs-uuid-to-superblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-copy-fs-uuid-to-superblock.patch

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
Subject: ocfs2: copy fs uuid to superblock

Currently, maximal number of cleancache enabled filesystems equals 32,
which is insufficient nowadays, because a Linux host can have hundreds of
containers on board, each of which might want its own filesystem.  This
patch set targets at removing this limitation - see patch 4 for more
details.  Patches 1-3 prepare the code for this change.

This patch (of 4):

This will allow us to remove the uuid argument from
cleancache_init_shared_fs.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
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

 fs/ocfs2/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/super.c~ocfs2-copy-fs-uuid-to-superblock fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-copy-fs-uuid-to-superblock
+++ a/fs/ocfs2/super.c
@@ -2069,6 +2069,8 @@ static int ocfs2_initialize_super(struct
 	cbits = le32_to_cpu(di->id2.i_super.s_clustersize_bits);
 	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
+	memcpy(sb->s_uuid, di->id2.i_super.s_uuid,
+	       sizeof(di->id2.i_super.s_uuid));
 
 	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
 
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

