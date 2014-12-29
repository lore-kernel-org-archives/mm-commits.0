From: akpm@linux-foundation.org
Subject: + ptrace-remove-linux-compath-inclusion-under-config_compat.patch added to -mm tree
Date: Mon, 29 Dec 2014 14:04:12 -0800
Message-ID: <54a1cfdc.QXTVIR+2bYgtSpkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL2WEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 17:04:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: remove linux/compat.h inclusion under CONFIG_COMPAT
has been added to the -mm tree.  Its filename is
     ptrace-remove-linux-compath-inclusion-under-config_compat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-remove-linux-compath-inclusion-under-config_compat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-remove-linux-compath-inclusion-under-config_compat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ptrace: remove linux/compat.h inclusion under CONFIG_COMPAT

Commit 84c751bd4aeb ("ptrace: add ability to retrieve signals without
removing from a queue (v4)") includes <linux/compat.h> globally in
ptrace.c

This patch removes inclusion under if defined CONFIG_COMPAT.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-remove-linux-compath-inclusion-under-config_compat kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-remove-linux-compath-inclusion-under-config_compat
+++ a/kernel/ptrace.c
@@ -1077,7 +1077,6 @@ int generic_ptrace_pokedata(struct task_
 }
 
 #if defined CONFIG_COMPAT
-#include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 			  compat_ulong_t addr, compat_ulong_t data)
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
linux-next.patch

