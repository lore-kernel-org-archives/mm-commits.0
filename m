From: akpm@linux-foundation.org
Subject: - oss-strlcpy-is-smart-enough.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:55 -0700
Message-ID: <200705090245.l492jtZw008789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031630AbXEICqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     oss: strlcpy is smart enough
has been removed from the -mm tree.  Its filename was
     oss-strlcpy-is-smart-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oss: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/btaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
x86-msr-add-support-for-safe-variants.patch
