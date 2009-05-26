From: akpm@linux-foundation.org
Subject: + kmod-release-sub_info-on-cred-allocation-failure.patch added to -mm tree
Date: Tue, 26 May 2009 13:36:32 -0700
Message-ID: <200905262036.n4QKaW8Y016429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbZEZUgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 16:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jp, dhowells@redhat.compenguin-kernel@i-love.sakura.ne.jp


The patch titled
     kmod: release sub_info on cred allocation failure
has been added to the -mm tree.  Its filename is
     kmod-release-sub_info-on-cred-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmod: release sub_info on cred allocation failure
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

call_usermodehelper_setup() forgot to kfree(sub_info) when
prepare_usermodehelper_creds() failed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/kmod.c~kmod-release-sub_info-on-cred-allocation-failure kernel/kmod.c
--- a/kernel/kmod.c~kmod-release-sub_info-on-cred-allocation-failure
+++ a/kernel/kmod.c
@@ -370,8 +370,10 @@ struct subprocess_info *call_usermodehel
 	sub_info->argv = argv;
 	sub_info->envp = envp;
 	sub_info->cred = prepare_usermodehelper_creds();
-	if (!sub_info->cred)
+	if (!sub_info->cred) {
+		kfree(sub_info);
 		return NULL;
+	}
 
   out:
 	return sub_info;
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

kmod-release-sub_info-on-cred-allocation-failure.patch

