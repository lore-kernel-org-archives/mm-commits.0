From: akpm@linux-foundation.org
Subject: [merged] kmod-release-sub_info-on-cred-allocation-failure.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:31 -0700
Message-ID: <200905272055.n4RKtVcN025800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbZE0U4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, dhowells@redhat.compenguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     kmod: release sub_info on cred allocation failure
has been removed from the -mm tree.  Its filename was
     kmod-release-sub_info-on-cred-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

