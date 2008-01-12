From: akpm@linux-foundation.org
Subject: + drivers-media-common-add-missing-video_device_release.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:03:42 -0800
Message-ID: <200801120103.m0C13ghn006835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440AbYALBD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:03:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media/common: Add missing video_device_release
has been added to the -mm tree.  Its filename is
     drivers-media-common-add-missing-video_device_release.patch

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
git-powerpc.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
drivers-media-common-add-missing-video_device_release.patch
git-input.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
