From: akpm@linux-foundation.org
Subject: [folded-merged] sysctl-terminate-strings-also-on-r-fix.patch
 removed from -mm tree
Date: Mon, 15 Dec 2014 15:44:44 -0800
Message-ID: <548f726c.uUcIYbvpt+tFTY8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLOXop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Dec 2014 18:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atomlin@redhat.com, keescook@chromium.org, pabs3@bonedaddy.net, paulmck@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-terminate-strings-also-on-r-fix
has been removed from the -mm tree.  Its filename was
     sysctl-terminate-strings-also-on-r-fix.patch

This patch was dropped because it was folded into sysctl-terminate-strings-also-on-r.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-terminate-strings-also-on-r-fix

add missing comment

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Wise <pabs3@bonedaddy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sysctl.c~sysctl-terminate-strings-also-on-r-fix kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-terminate-strings-also-on-r-fix
+++ a/kernel/sysctl.c
@@ -1749,6 +1749,10 @@ static int _proc_do_string(char *data, i
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
+			/*
+			 * \r terminates input to partially prevent attackers
+			 * from hiding info from sysadmins who use cat
+			 */
 			if (c == 0 || c == '\n' || c == '\r')
 				break;
 			data[len++] = c;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
sysctl-terminate-strings-also-on-r.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

