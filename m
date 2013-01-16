From: akpm@linux-foundation.org
Subject: + signal-allow-to-send-any-siginfo-to-itself.patch added to -mm tree
Date: Wed, 16 Jan 2013 12:37:49 -0800
Message-ID: <20130116203752.1C034100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:38051 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3APUhy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 15:37:54 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so214486ghb.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 12:37:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, mtk.manpages@gmail.com, oleg@redhat.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: signal: allow to send any siginfo to itself
has been added to the -mm tree.  Its filename is
     signal-allow-to-send-any-siginfo-to-itself.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: signal: allow to send any siginfo to itself

The kernel prevents sending of siginfo with positive si_code, because
these codes are reserved for kernel.  I think we can allow a task to send
such a siginfo to itself.  This operation should not be dangerous.

This functionality is required for restoring signals in
checkpoint/restart.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signal-allow-to-send-any-siginfo-to-itself kernel/signal.c
--- a/kernel/signal.c~signal-allow-to-send-any-siginfo-to-itself
+++ a/kernel/signal.c
@@ -2993,7 +2993,8 @@ static int do_rt_sigqueueinfo(pid_t pid,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
@@ -3042,7 +3043,8 @@ static int do_rt_tgsigqueueinfo(pid_t tg
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if (((info.si_code >= 0 || info.si_code == SI_TKILL)) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
_

Patches currently in -mm which might be from avagin@openvz.org are

signal-allow-to-send-any-siginfo-to-itself.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4.patch

