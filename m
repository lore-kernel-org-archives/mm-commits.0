From: akpm@linux-foundation.org
Subject: [merged] ocfs2-copy-fs-uuid-to-superblock.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:10:39 -0700
Message-ID: <552eb7af.Y9/QTiFrpBPtCVVq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbbDOTKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: copy fs uuid to superblock
has been removed from the -mm tree.  Its filename was
     ocfs2-copy-fs-uuid-to-superblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2070,6 +2070,8 @@ static int ocfs2_initialize_super(struct
 	cbits = le32_to_cpu(di->id2.i_super.s_clustersize_bits);
 	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
+	memcpy(sb->s_uuid, di->id2.i_super.s_uuid,
+	       sizeof(di->id2.i_super.s_uuid));
 
 	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-zap-mem_cgroup_lookup.patch
memcg-remove-obsolete-comment.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch
linux-next.patch

