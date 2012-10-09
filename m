From: akpm@linux-foundation.org
Subject: + proc-dont-show-nonexistent-capabilities.patch added to -mm tree
Date: Tue, 09 Oct 2012 12:13:52 -0700
Message-ID: <20121009191353.3E97920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52562 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2JITN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 15:13:57 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so365540lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 12:13:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, morgan@kernel.org, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: proc: don't show nonexistent capabilities
has been added to the -mm tree.  Its filename is
     proc-dont-show-nonexistent-capabilities.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Vagin <avagin@openvz.org>
Subject: proc: don't show nonexistent capabilities

Without this patch it is really hard to interpret a bounding set, if
CAP_LAST_CAP is unknown for a current kernel.

Non-existant capabilities can not be deleted from a bounding set with help
of prctl.

E.g.: Here are two examples without/with this patch.
CapBnd:	ffffffe0fdecffff
CapBnd:	00000000fdecffff

I suggest to hide non-existent capabilities. Here is two reasons.
* It's logically and easier for using.
* It helps to checkpoint-restore capabilities of tasks, because tasks
can be restored on another kernel, where CAP_LAST_CAP is bigger.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Andrew G. Morgan <morgan@kernel.org>
Reviewed-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/proc/array.c~proc-dont-show-nonexistent-capabilities fs/proc/array.c
--- a/fs/proc/array.c~proc-dont-show-nonexistent-capabilities
+++ a/fs/proc/array.c
@@ -308,6 +308,10 @@ static void render_cap_t(struct seq_file
 	seq_putc(m, '\n');
 }
 
+/* Remove non-existent capabilities */
+#define NORM_CAPS(v) (v.cap[CAP_TO_INDEX(CAP_LAST_CAP)] &= \
+				CAP_TO_MASK(CAP_LAST_CAP + 1) - 1)
+
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
 	const struct cred *cred;
@@ -321,6 +325,11 @@ static inline void task_cap(struct seq_f
 	cap_bset	= cred->cap_bset;
 	rcu_read_unlock();
 
+	NORM_CAPS(cap_inheritable);
+	NORM_CAPS(cap_permitted);
+	NORM_CAPS(cap_effective);
+	NORM_CAPS(cap_bset);
+
 	render_cap_t(m, "CapInh:\t", &cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &cap_permitted);
 	render_cap_t(m, "CapEff:\t", &cap_effective);
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
pidns-remove-recursion-from-free_pid_ns-v3.patch
proc-dont-show-nonexistent-capabilities.patch

