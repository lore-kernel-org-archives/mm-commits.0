From: akpm@linux-foundation.org
Subject: + usbaudio-handle-kcalloc-failure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:07 -0800
Message-ID: <200802230731.m1N7VuBV018043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYBWHyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, greg@kroah.com, meyering@redhat.com


The patch titled
     usbaudio: handle kcalloc failure
has been added to the -mm tree.  Its filename is
     usbaudio-handle-kcalloc-failure.patch

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
Subject: usbaudio: handle kcalloc failure
From: Jim Meyering <jim@meyering.net>

sound/usb/usbaudio.c (check_hw_params_convention): Handle kcalloc failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/usbaudio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN sound/usb/usbaudio.c~usbaudio-handle-kcalloc-failure sound/usb/usbaudio.c
--- a/sound/usb/usbaudio.c~usbaudio-handle-kcalloc-failure
+++ a/sound/usb/usbaudio.c
@@ -1735,6 +1735,8 @@ static int check_hw_params_convention(st
 
 	channels = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
 	rates = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
+	if (!channels || !rates)
+		goto __out;
 
 	list_for_each(p, &subs->fmt_list) {
 		struct audioformat *f;
_

Patches currently in -mm which might be from jim@meyering.net are

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
