From: akpm@linux-foundation.org
Subject: + invalid-return-value-of-execve-resulting-in-oopses.patch added to -mm tree
Date: Thu, 03 May 2007 13:04:40 -0700
Message-ID: <200705032004.l43K4e1Q018677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbXECUGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey@openvz.org, dev@openvz.org, xemul@openvz.org


The patch titled
     Invalid return value of execve() resulting in oopses
has been added to the -mm tree.  Its filename is
     invalid-return-value-of-execve-resulting-in-oopses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Invalid return value of execve() resulting in oopses
From: Alexey Kuznetsov <alexey@openvz.org>

When elf loader fails to map executable (due to memory shortage or because
binary is malformed), it can return 0.  Normally, this is invisible because
process is killed with SIGKILL and it never returns to user space.

But if exec() is called from kernel thread (hotplug, whatever)
consequences are more interesting and vary depending on architecture.

i386.   Nothing especially interesting, execve() just returns
        with "success"  :-)

x86_64. Fake zero frame is used on way to caller, RSP/RIP are loaded
        with zeros, ergo... double fault.

ia64.   Similar to i386, but r32...r95 are corrupted. Sometimes it
        oopses due to return to zero PC, sometimes it sees NaT in
        rXX and oopses due to NaT consumption.

Signed-off-by: Alexey Kuznetsov <alexey@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN fs/binfmt_elf.c~invalid-return-value-of-execve-resulting-in-oopses fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~invalid-return-value-of-execve-resulting-in-oopses
+++ a/fs/binfmt_elf.c
@@ -871,6 +871,8 @@ static int load_elf_binary(struct linux_
 				elf_prot, elf_flags);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
+			retval = IS_ERR((void *)error) ?
+				PTR_ERR((void*)error) : -EINVAL;
 			goto out_free_dentry;
 		}
 
@@ -900,6 +902,7 @@ static int load_elf_binary(struct linux_
 		    TASK_SIZE - elf_ppnt->p_memsz < k) {
 			/* set_brk can never work. Avoid overflows. */
 			send_sig(SIGKILL, current, 0);
+			retval = -EINVAL;
 			goto out_free_dentry;
 		}
 
_

Patches currently in -mm which might be from alexey@openvz.org are

invalid-return-value-of-execve-resulting-in-oopses.patch
