From: akpm@linux-foundation.org
Subject: + virtio_balloon-fix-race-by-fill-and-leak.patch added to -mm
 tree
Date: Tue, 29 Dec 2015 13:25:50 -0800
Message-ID: <5682fa5e.vYUDlgeTNyIcenqV%akpm__20221.1811593317$1451424372$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbbL2VZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:25:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, koct9i@gmail.com, mst@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon: fix race by fill and leak
has been added to the -mm tree.  Its filename is
     virtio_balloon-fix-race-by-fill-and-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtio_balloon-fix-race-by-fill-and-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtio_balloon-fix-race-by-fill-and-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: virtio_balloon: fix race by fill and leak

During my compaction-related stuff, I encountered a bug with ballooning.

With repeated inflating and deflating cycle, guest memory( ie, cat
/proc/meminfo | grep MemTotal) is decreased and couldn't be recovered.

The reason is balloon_lock doesn't cover release_pages_balloon so struct
virtio_balloon fields could be overwritten by race of fill_balloon(e,g,
vb->*pfns could be critical).

This patch fixes it in my test.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-fix-race-by-fill-and-leak drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-fix-race-by-fill-and-leak
+++ a/drivers/virtio/virtio_balloon.c
@@ -209,8 +209,8 @@ static unsigned leak_balloon(struct virt
 	 */
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->deflate_vq);
-	mutex_unlock(&vb->balloon_lock);
 	release_pages_balloon(vb);
+	mutex_unlock(&vb->balloon_lock);
 	return num_freed_pages;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

virtio_balloon-fix-race-by-fill-and-leak.patch
virtio_balloon-fix-race-between-migration-and-ballooning.patch
zram-pass-gfp-from-zcomp-frontend-to-backend.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-define-madv_free-for-some-arches.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazily-freed-pages-to-inactive-list.patch
mm-mark-stable-page-dirty-in-ksm.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_mkclean-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch

