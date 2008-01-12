From: akpm@linux-foundation.org
Subject: + drivers-media-radio-use-video_device_release-rather-than-kfree.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:50:05 -0800
Message-ID: <200801120050.m0C0o6rK006390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762703AbYALAuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/media/radio: Use video_device_release rather than kfree
has been added to the -mm tree.  Its filename is
     drivers-media-radio-use-video_device_release-rather-than-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-powerpc.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
git-input.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
