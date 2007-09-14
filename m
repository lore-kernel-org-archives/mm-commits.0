From: akpm@linux-foundation.org
Subject: + fix-uts-corruption-during-cloneclone_newuts.patch added to -mm tree
Date: Fri, 14 Sep 2007 14:59:19 -0700
Message-ID: <200709142159.l8ELxJwO026363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbXINWA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 18:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, serue@us.ibm.com


The patch titled
     Fix UTS corruption during clone(CLONE_NEWUTS)
has been added to the -mm tree.  Its filename is
     fix-uts-corruption-during-cloneclone_newuts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix UTS corruption during clone(CLONE_NEWUTS)
From: Alexey Dobriyan <adobriyan@sw.ru>

struct utsname is copied from master one without any exclusion.

Here is sample output from one proggie doing

	sethostname("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
	sethostname("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");

and another

	clone(,, CLONE_NEWUTS, ...)
	uname()

	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaabbbbb'
	hostname = 'bbbaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	hostname = 'aaaaaaaabbbbbbbbbbbbbbbbbbbbbb'
	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaabbbb'
	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaabb'
	hostname = 'aaabbbbbbbbbbbbbbbbbbbbbbbbbbb'
	hostname = 'bbbbbbbbbbbbbbbbaaaaaaaaaaaaaa'

Hostname is sometimes corrupted.

Yes, even _the_ simplest namespace activity had bug in it. :-(

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/utsname.c~fix-uts-corruption-during-cloneclone_newuts kernel/utsname.c
--- a/kernel/utsname.c~fix-uts-corruption-during-cloneclone_newuts
+++ a/kernel/utsname.c
@@ -28,7 +28,9 @@ static struct uts_namespace *clone_uts_n
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
+	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
+	up_read(&uts_sem);
 	kref_init(&ns->kref);
 	return ns;
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-uts-corruption-during-cloneclone_newuts.patch
consolidate-ptrace_detach.patch
git-kbuild.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
single_open-seq_release-leak-diagnostics.patch
