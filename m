From: akpm@linux-foundation.org
Subject: + fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:22:28 -0700
Message-ID: <200807172122.m6HLMSYC006892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932902AbYGQVX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, davidel@xmailserver.org, stable@kernel.org


The patch titled
     Fix build on COMPAT platforms when CONFIG_EPOLL is disabled
has been added to the -mm tree.  Its filename is
     fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch

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
Subject: Fix build on COMPAT platforms when CONFIG_EPOLL is disabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add missing cond_syscall() entry for compat_sys_epoll_pwait.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys_ni.c~fix-build-on-compat-platforms-when-config_epoll-is-disabled kernel/sys_ni.c
--- a/kernel/sys_ni.c~fix-build-on-compat-platforms-when-config_epoll-is-disabled
+++ a/kernel/sys_ni.c
@@ -60,6 +60,7 @@ cond_syscall(sys_epoll_create);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);
+cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch

