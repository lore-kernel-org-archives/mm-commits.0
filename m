From: akpm@linux-foundation.org
Subject: + alsa-fix-compilation-warning-in-gcc.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:44:30 -0800
Message-ID: <200801120144.m0C1iUep008394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021AbYALBoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:44:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mboton.lkml@gmail.com, mboton@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     alsa: fix compilation warning in GCC
has been added to the -mm tree.  Its filename is
     alsa-fix-compilation-warning-in-gcc.patch

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
Subject: alsa: fix compilation warning in GCC
From: Miguel Boton <mboton.lkml@gmail.com>

'snd_shutdown_f_ops' is not a pointer so its address will never be NULL.
GCC will complain because 'fops_get' will do an unnecessary check because
'&snd_shutdown_f_ops' is always true.

Signed-off-by: Miguel Boton <mboton@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/core/init.c~alsa-fix-compilation-warning-in-gcc sound/core/init.c
--- a/sound/core/init.c~alsa-fix-compilation-warning-in-gcc
+++ a/sound/core/init.c
@@ -340,8 +340,8 @@ int snd_card_disconnect(struct snd_card 
 		list_add(&mfile->shutdown_list, &shutdown_files);
 		spin_unlock(&shutdown_lock);
 
-		fops_get(&snd_shutdown_f_ops);
 		mfile->file->f_op = &snd_shutdown_f_ops;
+		fops_get(mfile->file->f_op);
 		
 		mfile = mfile->next;
 	}
_

Patches currently in -mm which might be from mboton.lkml@gmail.com are

alsa-fix-compilation-warning-in-gcc.patch
git-netdev-all.patch
iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch
