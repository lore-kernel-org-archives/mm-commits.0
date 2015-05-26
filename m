From: akpm@linux-foundation.org
Subject: + fs-proc-introduce-config_proc_children.patch added to -mm tree
Date: Tue, 26 May 2015 16:17:41 -0700
Message-ID: <5564ff15.olRShzop8vHkZZU7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbEZXRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 May 2015 19:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iago@endocode.com, alban@endocode.com, djalal@endocode.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, luto@amacapital.net, oleg@redhat.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: introduce CONFIG_PROC_CHILDREN
has been added to the -mm tree.  Its filename is
     fs-proc-introduce-config_proc_children.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-introduce-config_p=
roc_children.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-introduce-config_p=
roc_children.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Iago L=F3pez Galeiras <iago@endocode.com>
Subject: fs, proc: introduce CONFIG_PROC_CHILDREN

commit 818411616baf ("fs, proc: introduce /proc/<pid>/task/<tid>/childr=
en
entry") introduced the children entry for checkpoint restore and the fi=
le
is only available on kernels configured with CONFIG_EXPERT and
CONFIG_CHECKPOINT_RESTORE.

This is available in most distributions (Fedora, Debian, Ubuntu, CoreOS=
)
because they usually enable CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE=
=2E=20
But Arch does not enable CONFIG_EXPERT or CONFIG_CHECKPOINT_RESTORE.

However, the children proc file is useful outside of checkpoint restore=
=2E=20
I would like to use it in rkt.  The rkt process exec() another program =
it
does not control, and that other program will fork()+exec() a child
process.  I would like to find the pid of the child process from an
external tool without iterating in /proc over all processes to find whi=
ch
one has a parent pid equal to rkt.

This commit introduces CONFIG_PROC_CHILDREN and makes
CONFIG_CHECKPOINT_RESTORE select it.  This allows enabling
/proc/<pid>/task/<tid>/children without needing to enable
CONFIG_CHECKPOINT_RESTORE and CONFIG_EXPERT.

Alban tested that /proc/<pid>/task/<tid>/children is present when the
kernel is configured with CONFIG_PROC_CHILDREN=3Dy but without
CONFIG_CHECKPOINT_RESTORE

Signed-off-by: Iago L=F3pez Galeiras <iago@endocode.com>
Tested-by: Alban Crequy <alban@endocode.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <djalal@endocode.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    4 ++++
 fs/proc/array.c |    4 ++--
 fs/proc/base.c  |    2 +-
 init/Kconfig    |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/Kconfig~fs-proc-introduce-config_proc_children fs/pro=
c/Kconfig
--- a/fs/proc/Kconfig~fs-proc-introduce-config_proc_children
+++ a/fs/proc/Kconfig
@@ -71,3 +71,7 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximate=
ly 4kb.
+
+config PROC_CHILDREN
+	bool "Include /proc/<pid>/task/<tid>/children file"
+	default n
diff -puN fs/proc/array.c~fs-proc-introduce-config_proc_children fs/pro=
c/array.c
--- a/fs/proc/array.c~fs-proc-introduce-config_proc_children
+++ a/fs/proc/array.c
@@ -577,7 +577,7 @@ int proc_pid_statm(struct seq_file *m, s
 	return 0;
 }
=20
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_PROC_CHILDREN
 static struct pid *
 get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos=
)
 {
@@ -700,4 +700,4 @@ const struct file_operations proc_tid_ch
 	.llseek  =3D seq_lseek,
 	.release =3D children_seq_release,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
+#endif /* CONFIG_PROC_CHILDREN */
diff -puN fs/proc/base.c~fs-proc-introduce-config_proc_children fs/proc=
/base.c
--- a/fs/proc/base.c~fs-proc-introduce-config_proc_children
+++ a/fs/proc/base.c
@@ -3108,7 +3108,7 @@ static const struct pid_entry tid_base_s
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_PROC_CHILDREN
 	REG("children",  S_IRUGO, proc_tid_children_operations),
 #endif
 #ifdef CONFIG_NUMA
diff -puN init/Kconfig~fs-proc-introduce-config_proc_children init/Kcon=
fig
--- a/init/Kconfig~fs-proc-introduce-config_proc_children
+++ a/init/Kconfig
@@ -1145,6 +1145,7 @@ endif # CGROUPS
=20
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support" if EXPERT
+	select PROC_CHILDREN
 	default n
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
_

Patches currently in -mm which might be from iago@endocode.com are

fs-proc-introduce-config_proc_children.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
