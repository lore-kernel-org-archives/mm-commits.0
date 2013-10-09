From: akpm@linux-foundation.org
Subject: + devpts-plug-the-memory-leak-in-kill_sb.patch added to -mm tree
Date: Wed, 09 Oct 2013 15:09:00 -0700
Message-ID: <5255d3fc.fUqr2frdFPSBMCQV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3JIWJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Oct 2013 18:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sukadev@linux.vnet.ibm.com, stable@vger.kernel.org, ihadzic@research.bell-labs.com

Subject: + devpts-plug-the-memory-leak-in-kill_sb.patch added to -mm tree
To: ihadzic@research.bell-labs.com,stable@vger.kernel.org,sukadev@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 09 Oct 2013 15:09:00 -0700


The patch titled
     Subject: devpts: plug the memory leak in kill_sb
has been added to the -mm tree.  Its filename is
     devpts-plug-the-memory-leak-in-kill_sb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/devpts-plug-the-memory-leak-in-kill_sb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/devpts-plug-the-memory-leak-in-kill_sb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: devpts: plug the memory leak in kill_sb

When devpts is unmounted, there may be a no-longer-used IDR tree hanging
off the superblock we are about to kill.  This needs to be cleaned up
before destroying the SB.

The leak is usually not a big deal because unmounting devpts is typically
done when shutting down the whole machine.  However, shutting down an LXC
container instead of a physical machine exposes the problem (the garbage
is detectable with kmemleak).

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/devpts/inode.c~devpts-plug-the-memory-leak-in-kill_sb fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-plug-the-memory-leak-in-kill_sb
+++ a/fs/devpts/inode.c
@@ -498,6 +498,7 @@ static void devpts_kill_sb(struct super_
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }
_

Patches currently in -mm which might be from ihadzic@research.bell-labs.com are

devpts-plug-the-memory-leak-in-kill_sb.patch

