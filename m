From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch
 removed from -mm tree
Date: Mon, 30 Sep 2013 13:41:08 -0700
Message-ID: <5249e1e4.gsViJHZ9+RGCxDJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3I3UlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 16:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp

Subject: [folded-merged] kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch removed from -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,oleg@redhat.com,penguin-kernel@I-love.SAKURA.ne.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 13:41:08 -0700


The patch titled
     Subject: kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update
has been removed from the -mm tree.  Its filename was
     kernel-kmodc-check-for-null-in-call_usermodehelper_exec-update.patch

This patch was dropped because it was folded into kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch

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

kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

