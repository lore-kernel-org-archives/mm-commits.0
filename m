From: akpm@linux-foundation.org
Subject: + proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 13:01:57 -0800
Message-ID: <54eb9545.0wJT3linm0MZcpzc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbBWVB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenhanxiao@cn.fujitsu.com, ebiederm@xmission.com, nathans@redhat.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/PID/status: show all sets of pid according to ns
has been added to the -mm tree.  Its filename is
     proc-pid-status-show-all-sets-of-pid-according-to-ns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-pid-status-show-all-sets-of-pid-according-to-ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Subject: /proc/PID/status: show all sets of pid according to ns

If some issues occurred inside a container guest, host user could not know
which process is in trouble just by guest pid: the users of container
guest only knew the pid inside containers.  This will bring obstacle for
trouble shooting.

This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:

a) In init_pid_ns, nothing changed;

b) In one pidns, will tell the pid inside containers:
  NStgid: 21776   5       1
  NSpid:  21776   5       1
  NSpgid: 21776   5       1
  NSsid:  21729   1       0
  ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.

c) If pidns is nested, it depends on which pidns are you in.
  NStgid: 5       1
  NSpid:  5       1
  NSpgid: 5       1
  NSsid:  1       0
  ** Views from level 1

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns fs/proc/array.c
--- a/fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns
+++ a/fs/proc/array.c
@@ -188,6 +188,22 @@ static inline void task_state(struct seq
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 
+	seq_puts(m, "\nNStgid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d",
+			task_tgid_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nNSpid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d",
+			task_pid_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nNSpgid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d",
+			task_pgrp_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nNSsid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d",
+			task_session_nr_ns(p, pid->numbers[g].ns));
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from chenhanxiao@cn.fujitsu.com are

proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos.patch

