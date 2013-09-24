From: akpm@linux-foundation.org
Subject: +
 kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch added
 to -mm tree
Date: Tue, 24 Sep 2013 13:54:16 -0700
Message-ID: <5241fbf8.Jemn+wQdelcSGEie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3IXUyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 16:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp

Subject: + kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch added to -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,oleg@redhat.com,penguin-kernel@I-love.SAKURA.ne.jp
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 13:54:16 -0700


The patch titled
     Subject: kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update
has been added to the -mm tree.  Its filename is
     kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update

Switch to EINVAL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update
+++ a/kernel/kmod.c
@@ -573,7 +573,7 @@ int call_usermodehelper_exec(struct subp
 
 	if (!sub_info->path) {
 		call_usermodehelper_freeinfo(sub_info);
-		return -ENOENT;
+		return -EINVAL;
 	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

