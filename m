From: akpm@linux-foundation.org
Subject: + proc-pid-status-add-seccomp-field.patch added to -mm tree
Date: Thu, 01 Nov 2012 15:37:12 -0700
Message-ID: <20121101223712.9DD74100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36896 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992541Ab2KAWhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 18:37:14 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so356349ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 15:37:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, aarcange@redhat.com, gorcunov@openvz.org, jmorris@namei.org


The patch titled
     Subject: /proc/pid/status: add "Seccomp" field
has been added to the -mm tree.  Its filename is
     proc-pid-status-add-seccomp-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: /proc/pid/status: add "Seccomp" field

It is currently impossible to examine the state of seccomp for a given
process.  While attaching with gdb and attempting "call
prctl(PR_GET_SECCOMP,...)" will work with some situations, it is not
reliable.  If the process is in seccomp mode 1, this query will kill the
process (prctl not allowed), if the process is in mode 2 with prctl not
allowed, it will similarly be killed, and in weird cases, if prctl is
filtered to return errno 0, it can look like seccomp is disabled.

When reviewing the state of running processes, there should be a way to
externally examine the seccomp mode.  ("Did this build of Chrome end up
using seccomp?" "Did my distro ship ssh with seccomp enabled?")

This adds the "Seccomp" line to /proc/$pid/status.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/array.c                    |    8 ++++++++
 2 files changed, 10 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-pid-status-add-seccomp-field Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-pid-status-add-seccomp-field
+++ a/Documentation/filesystems/proc.txt
@@ -181,6 +181,7 @@ read the file /proc/PID/status:
   CapPrm: 0000000000000000
   CapEff: 0000000000000000
   CapBnd: ffffffffffffffff
+  Seccomp:        0
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -237,6 +238,7 @@ Table 1-2: Contents of the status files 
  CapPrm                      bitmap of permitted capabilities
  CapEff                      bitmap of effective capabilities
  CapBnd                      bitmap of capabilities bounding set
+ Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
diff -puN fs/proc/array.c~proc-pid-status-add-seccomp-field fs/proc/array.c
--- a/fs/proc/array.c~proc-pid-status-add-seccomp-field
+++ a/fs/proc/array.c
@@ -336,6 +336,13 @@ static inline void task_cap(struct seq_f
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
 }
 
+static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
+#endif
+}
+
 static inline void task_context_switch_counts(struct seq_file *m,
 						struct task_struct *p)
 {
@@ -369,6 +376,7 @@ int proc_pid_status(struct seq_file *m, 
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_seccomp(m, task);
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
proc-dont-show-nonexistent-capabilities.patch
proc-pid-status-add-seccomp-field.patch

