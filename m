From: akpm@linux-foundation.org
Subject: + proc-report-no_new_privs-state.patch added to -mm tree
Date: Thu, 03 Nov 2016 15:24:14 -0700
Message-ID: <581bb90e.riIDyzzcwZjMknfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932105AbcKCWYP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 18:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, adobriyan@gmail.com, corbet@lwn.net, hannes@cmpxchg.org, hughd@google.com, jann@thejh.net, jmarchan@redhat.com, joe@perches.com, john.stultz@linaro.org, koct9i@gmail.com, luto@kernel.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rfreire@redhat.com, rjones@redhat.com, robert.hu@intel.com, ross.zwisler@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: report no_new_privs state
has been added to the -mm tree.  Its filename is
     proc-report-no_new_privs-state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-report-no_new_privs-state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-report-no_new_privs-state.patch

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
Subject: proc: report no_new_privs state

Similar to being able to examine if a process has been correctly confined
with seccomp, the state of no_new_privs is equally interesting, so this
adds it to /proc/$pid/status.

Link: http://lkml.kernel.org/r/20161103214041.GA58566@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jann Horn <jann@thejh.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rodrigo Freire <rfreire@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Robert Ho <robert.hu@intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/array.c                    |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-report-no_new_privs-state Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-report-no_new_privs-state
+++ a/Documentation/filesystems/proc.txt
@@ -191,6 +191,7 @@ read the file /proc/PID/status:
   CapPrm: 0000000000000000
   CapEff: 0000000000000000
   CapBnd: ffffffffffffffff
+  NoNewPrivs:     0
   Seccomp:        0
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
@@ -262,6 +263,7 @@ Table 1-2: Contents of the status files
  CapPrm                      bitmap of permitted capabilities
  CapEff                      bitmap of effective capabilities
  CapBnd                      bitmap of capabilities bounding set
+ NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
diff -puN fs/proc/array.c~proc-report-no_new_privs-state fs/proc/array.c
--- a/fs/proc/array.c~proc-report-no_new_privs-state
+++ a/fs/proc/array.c
@@ -342,10 +342,11 @@ static inline void task_cap(struct seq_f
 
 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
 {
+	seq_put_decimal_ull(m, "NoNewPrivs:\t", task_no_new_privs(p));
 #ifdef CONFIG_SECCOMP
-	seq_put_decimal_ull(m, "Seccomp:\t", p->seccomp.mode);
-	seq_putc(m, '\n');
+	seq_put_decimal_ull(m, "\nSeccomp:\t", p->seccomp.mode);
 #endif
+	seq_putc(m, '\n');
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
_

Patches currently in -mm which might be from keescook@chromium.org are

proc-report-no_new_privs-state.patch

