From: akpm@linux-foundation.org
Subject: - usbaudio-handle-kcalloc-failure.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:23 -0800
Message-ID: <200803062222.m26MMNss020806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765742AbYCFWXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, greg@kroah.com, meyering@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usbaudio: handle kcalloc failure
has been removed from the -mm tree.  Its filename was
     usbaudio-handle-kcalloc-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch

