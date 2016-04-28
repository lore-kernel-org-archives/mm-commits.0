From: akpm@linux-foundation.org
Subject: + proc-prevent-accessing-proc-pid-environ-until-its-ready.patch
 added to -mm tree
Date: Thu, 28 Apr 2016 14:31:14 -0700
Message-ID: <57228122.aFuphvCOE6z/3R4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbcD1VbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 17:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, adobriyan@gmail.com, gorcunov@openvz.org, jarod@redhat.com, mguzik@redhat.com, pageexec@freemail.hu, re.emese@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: prevent accessing /proc/<PID>/environ until it's ready
has been added to the -mm tree.  Its filename is
     proc-prevent-accessing-proc-pid-environ-until-its-ready.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-prevent-accessing-proc-pid-environ-until-its-ready.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-prevent-accessing-proc-pid-environ-until-its-ready.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

proc-prevent-accessing-proc-pid-environ-until-its-ready.patch

