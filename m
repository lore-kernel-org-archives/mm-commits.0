From: akpm@linux-foundation.org
Subject: - drivers-media-radio-use-video_device_release-rather-than-kfree.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:20 -0800
Message-ID: <200801160139.m0G1dK8G013999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbYAPBs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/media/radio: Use video_device_release rather than kfree
has been removed from the -mm tree.  Its filename was
     drivers-media-radio-use-video_device_release-rather-than-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/radio: Use video_device_release rather than kfree
From: Julia Lawall <julia@diku.dk>

The file drivers/media/video/videodev.c defines both video_device_alloc and
video_device_release.  These are essentially just kzmalloc and kfree,
respectively, but it seems better to use video_device_release, as done in
the other media files, rather than kfree, in case the implementation some
day changes.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-maestro.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/radio/radio-maestro.c~drivers-media-radio-use-video_device_release-rather-than-kfree drivers/media/radio/radio-maestro.c
--- a/drivers/media/radio/radio-maestro.c~drivers-media-radio-use-video_device_release-rather-than-kfree
+++ a/drivers/media/radio/radio-maestro.c
@@ -423,7 +423,7 @@ static int __devinit maestro_probe(struc
 errunr:
 	video_unregister_device(maestro_radio_inst);
 errfr1:
-	kfree(maestro_radio_inst);
+	video_device_release(maestro_radio_inst);
 errfr:
 	kfree(radio_unit);
 err:
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
