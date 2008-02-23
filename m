From: akpm@linux-foundation.org
Subject: - samples-build-fix.patch removed from -mm tree
Date: Sat, 23 Feb 2008 13:21:54 -0800
Message-ID: <200802232121.m1NLLsiD015664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbYBWVXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 16:23:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     samples: build fix
has been removed from the -mm tree.  Its filename was
     samples-build-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: samples: build fix
From: Roland McGrath <roland@redhat.com>

The samples/ subdirectory contains only modules.  But the only make run
done there is in commands for vmlinux.  I can't see why this was ever done
in this nonstandard fashion.  As things stand, the modules don't get built
by 'make modules'.

I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
because there is no other conditional like that in the top-level Makefile
and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
always to be included.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN Makefile~samples-build-fix Makefile
--- a/Makefile~samples-build-fix
+++ a/Makefile
@@ -602,7 +602,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ samples/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
@@ -802,9 +802,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
samples-build-fix.patch
git-x86.patch
ptrace-fix-2625-ptrace_bts_config-structure-declaration.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
