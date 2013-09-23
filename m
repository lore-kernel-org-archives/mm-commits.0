From: akpm@linux-foundation.org
Subject: + kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch
 added to -mm tree
Date: Mon, 23 Sep 2013 14:29:15 -0700
Message-ID: <5240b2ab.P6Qqhcj+3WULbLZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3IWV3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 17:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp

Subject: + kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch added to -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,oleg@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 14:29:15 -0700


The patch titled
     Subject: kernel/kmod.c: check for NULL in call_usermodehelper_exec()
has been added to the -mm tree.  Its filename is
     kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kernel/kmod.c: check for NULL in call_usermodehelper_exec()

If /proc/sys/kernel/core_pattern contains only "|", NULL pointer
dereference happens upon core dump because argv_split("") returns argv[0]
== NULL.

This bug was once fixed by commit 264b83c0 ("usermodehelper: check
subprocess_info->path != NULL") but was by error reintroduced by commit
7f57cfa4 ("usermodehelper: kill the sub_info->path[0] check").

This bug seems to exist since 2.6.19 (the version which core dump to pipe
was added).  Depending on kernel version and config, some side effect
might happen immediately after this oops (e.g.  kernel panic with
2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec
+++ a/kernel/kmod.c
@@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -ENOENT;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch

