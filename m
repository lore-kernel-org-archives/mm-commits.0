From: akpm@linux-foundation.org
Subject: [merged] signal-allow-to-send-any-siginfo-to-itself.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:33 -0800
Message-ID: <20130228201134.0F55D31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:42717 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:35 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244599vea.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, mtk.manpages@gmail.com, oleg@redhat.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: allow to send any siginfo to itself
has been removed from the -mm tree.  Its filename was
     signal-allow-to-send-any-siginfo-to-itself.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: signal: allow to send any siginfo to itself

The idea is simple.  We need to get the siginfo for each signal on
checkpointing dump, and then return it back on restore.

The first problem is that the kernel doesn't report complete siginfos to
userspace.  In a signal handler the kernel strips SI_CODE from siginfo. 
When a siginfo is received from signalfd, it has a different format with
fixed sizes of fields.  The interface of signalfd was extended.  If a
signalfd is created with the flag SFD_RAW, it returns siginfo in a raw
format.

rt_sigqueueinfo looks suitable for restoring signals, but it can't
send siginfo with a positive si_code, because these codes are reserved for
the kernel.  In the real world each person has right to do anything with
himself, so I think a process should able to send any siginfo to itself.


This patch:

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
@@ -2996,7 +2996,8 @@ static int do_rt_sigqueueinfo(pid_t pid,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
@@ -3045,7 +3046,8 @@ static int do_rt_tgsigqueueinfo(pid_t tg
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if (((info->si_code >= 0 || info->si_code == SI_TKILL)) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

