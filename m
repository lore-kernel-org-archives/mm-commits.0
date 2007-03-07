From: akpm@linux-foundation.org
Subject: + oss-strlcpy-is-smart-enough.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:16:19 -0800
Message-ID: <200703070116.l271GJaq015217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161094AbXCGBQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     oss: strlcpy is smart enough
has been added to the -mm tree.  Its filename is
     oss-strlcpy-is-smart-enough.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oss: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/btaudio.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/oss/btaudio.c~oss-strlcpy-is-smart-enough sound/oss/btaudio.c
--- a/sound/oss/btaudio.c~oss-strlcpy-is-smart-enough
+++ a/sound/oss/btaudio.c
@@ -344,7 +344,7 @@ static int btaudio_mixer_ioctl(struct in
 	if (cmd == SOUND_OLD_MIXER_INFO) {
 		_old_mixer_info info;
 		memset(&info,0,sizeof(info));
-                strlcpy(info.id,"bt878",sizeof(info.id)-1);
+                strlcpy(info.id, "bt878", sizeof(info.id));
                 strlcpy(info.name,"Brooktree Bt878 audio",sizeof(info.name));
                 if (copy_to_user(argp, &info, sizeof(info)))
                         return -EFAULT;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-dvb.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
s390-strlcpy-is-smart-enough.patch
sound-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
xtensa-strlcpy-is-smart-enough.patch
ehea-strlcpy-is-smart-enough.patch
