From: akpm@linux-foundation.org
Subject: + procfs-make-proc-pagemap-0400.patch added to -mm tree
Date: Fri, 28 Mar 2014 15:33:02 -0700
Message-ID: <5335f89e.VtmV7CWNXNr4yHQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaC1WdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, mingo@kernel.org, luto@amacapital.net, keescook@chromium.org, ebiederm@xmission.com, tixxdz@opendz.org

Subject: + procfs-make-proc-pagemap-0400.patch added to -mm tree
To: tixxdz@opendz.org,ebiederm@xmission.com,keescook@chromium.org,luto@amacapital.net,mingo@kernel.org,oleg@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:33:02 -0700


The patch titled
     Subject: procfs: make /proc/*/pagemap 0400
has been added to the -mm tree.  Its filename is
     procfs-make-proc-pagemap-0400.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-make-proc-pagemap-0400.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-make-proc-pagemap-0400.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: procfs: make /proc/*/pagemap 0400

The /proc/*/pagemap contain sensitive information and currently its mode
is 0444.  Change this to 0400, so the VFS will prevent unprivileged
processes from getting file descriptors on arbitrary privileged
/proc/*/pagemap files.

This reduces the scope of address space leaking and bypasses by protecting
already running processes.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-make-proc-pagemap-0400 fs/proc/base.c
--- a/fs/proc/base.c~procfs-make-proc-pagemap-0400
+++ a/fs/proc/base.c
@@ -2617,7 +2617,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -2955,7 +2955,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
_

Patches currently in -mm which might be from tixxdz@opendz.org are

procfs-make-proc-stacksyscallpersonality-0400.patch
procfs-make-proc-pagemap-0400.patch

