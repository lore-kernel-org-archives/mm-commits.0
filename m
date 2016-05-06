From: akpm@linux-foundation.org
Subject: [merged]
 proc-prevent-accessing-proc-pid-environ-until-its-ready.patch removed from
 -mm tree
Date: Fri, 06 May 2016 14:17:35 -0700
Message-ID: <572d09ef.cTevcpLKpRefcKGx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, adobriyan@gmail.com, gorcunov@openvz.org, jarod@redhat.com, mguzik@redhat.com, pageexec@freemail.hu, re.emese@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: prevent accessing /proc/<PID>/environ until it's ready
has been removed from the -mm tree.  Its filename was
     proc-prevent-accessing-proc-pid-environ-until-its-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: proc: prevent accessing /proc/<PID>/environ until it's ready

If /proc/<PID>/environ gets read before the envp[] array is fully set up
in create_{aout,elf,elf_fdpic,flat}_tables(), we might end up trying to
read more bytes than are actually written, as env_start will already be
set but env_end will still be zero, making the range calculation
underflow, allowing to read beyond the end of what has been written.

Fix this as it is done for /proc/<PID>/cmdline by testing env_end for
zero.  It is, apparently, intentionally set last in create_*_tables().

This bug was found by the PaX size_overflow plugin that detected the
arithmetic underflow of 'this_len = env_end - (env_start + src)' when
env_end is still zero.

The expected consequence is that userland trying to access
/proc/<PID>/environ of a not yet fully set up process may get inconsistent
data as we're in the middle of copying in the environment variables.

Fixes: https://forums.grsecurity.net/viewtopic.php?f=3&t=4363
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=116461
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: Pax Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-prevent-accessing-proc-pid-environ-until-its-ready fs/proc/base.c
--- a/fs/proc/base.c~proc-prevent-accessing-proc-pid-environ-until-its-ready
+++ a/fs/proc/base.c
@@ -955,7 +955,8 @@ static ssize_t environ_read(struct file
 	struct mm_struct *mm = file->private_data;
 	unsigned long env_start, env_end;
 
-	if (!mm)
+	/* Ensure the process spawned far enough to have an environment. */
+	if (!mm || !mm->env_end)
 		return 0;
 
 	page = (char *)__get_free_page(GFP_TEMPORARY);
_

Patches currently in -mm which might be from minipli@googlemail.com are


