From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-remove-linux-compath-inclusion-under-config_compat.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:42:58 -0800
Message-ID: <54e4eb42.VkUrlAO5ezCoXLS2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbBRTm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: remove linux/compat.h inclusion under CONFIG_COMPAT
has been removed from the -mm tree.  Its filename was
     ptrace-remove-linux-compath-inclusion-under-config_compat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

