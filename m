From: akpm@linux-foundation.org
Subject: [merged]
 proc-pid-status-show-all-sets-of-pid-according-to-ns.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:12 -0700
Message-ID: <552fe934.9JeA0fLUp2FI7XbO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbbDPQsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenhanxiao@cn.fujitsu.com, ebiederm@xmission.com, nathans@redhat.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/PID/status: show all sets of pid according to ns
has been removed from the -mm tree.  Its filename was
     proc-pid-status-show-all-sets-of-pid-according-to-ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: add CONFIG_PID_NS ifdef]
Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns fs/proc/array.c
--- a/fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns
+++ a/fs/proc/array.c
@@ -188,6 +188,24 @@ static inline void task_state(struct seq
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 
+#ifdef CONFIG_PID_NS
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
+#endif
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from chenhanxiao@cn.fujitsu.com are

origin.patch
docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos.patch

