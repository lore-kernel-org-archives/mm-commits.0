From: akpm@linux-foundation.org
Subject: - drivers-media-common-add-missing-video_device_release.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:24 -0800
Message-ID: <200801160139.m0G1dOtj014002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbYAPBtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/common: Add missing video_device_release
has been removed from the -mm tree.  Its filename was
     drivers-media-common-add-missing-video_device_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/common: Add missing video_device_release
From: Julia Lawall <julia@diku.dk>

Video_device_alloc returns the result of a kzalloc.  In this case, the
value is stored in a local variable which is not copied elsewhere before
the point of the error return (video_register_device does not save its
first argument anywhere if it returns a negative value).  Thus, a
video_device_release it needed before the error return.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = video_device_alloc(...);
  if (E == NULL) S
  ... when != video_device_release(...,(T1)E,...)
      when != if (E != NULL) { ... video_device_release(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != video_device_release(...,(T2)E,...)
        when != if (E != NULL) { ... video_device_release(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/saa7146_fops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/common/saa7146_fops.c~drivers-media-common-add-missing-video_device_release drivers/media/common/saa7146_fops.c
--- a/drivers/media/common/saa7146_fops.c~drivers-media-common-add-missing-video_device_release
+++ a/drivers/media/common/saa7146_fops.c
@@ -538,6 +538,7 @@ int saa7146_register_device(struct video
 	// fixme: -1 should be an insmod parameter *for the extension* (like "video_nr");
 	if (video_register_device(vfd, type, -1) < 0) {
 		ERR(("cannot register v4l2 device. skipping.\n"));
+		video_device_release(vfd);
 		return -1;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
git-agpgart.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
git-powerpc.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
git-dvb.patch
git-input.patch
git-mtd.patch
git-net.patch
drivers-pcmcia-add-missing-iounmap.patch
drivers-pcmcia-add-missing-pci_dev_get.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
drivers-video-add-missing-pci_dev_get.patch
