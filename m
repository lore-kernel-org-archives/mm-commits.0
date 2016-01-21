From: akpm@linux-foundation.org
Subject: [merged]
 prctl-take-mmap-sem-for-writing-to-protect-against-others.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:28:25 -0800
Message-ID: <56a16999.ZOu14V7JfJPBVgfM%akpm__24833.5702265196$1453418924$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mguzik@redhat.com, adobriyan@gmail.com, anshuman.linux@gmail.com, gorcunov@openvz.org, jarod@redhat.com, jstancek@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: take mmap sem for writing to protect against others
has been removed from the -mm tree.  Its filename was
     prctl-take-mmap-sem-for-writing-to-protect-against-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Guzik <mguzik@redhat.com>
Subject: prctl: take mmap sem for writing to protect against others

An unprivileged user can trigger an oops on a kernel with
CONFIG_CHECKPOINT_RESTORE.

proc_pid_cmdline_read takes mmap_sem for reading and obtains args + env
start/end values. These get sanity checked as follows:
        BUG_ON(arg_start > arg_end);
        BUG_ON(env_start > env_end);

These can be changed by prctl_set_mm. Turns out also takes the semaphore for
reading, effectively rendering it useless. This results in:

[   50.530255] kernel BUG at fs/proc/base.c:240!
[   50.543351] invalid opcode: 0000 [#1] SMP 
[   50.556389] Modules linked in: virtio_net
[   50.569320] CPU: 0 PID: 925 Comm: a.out Not tainted 4.4.0-rc8-next-20160105dupa+ #71
[   50.594875] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.607972] task: ffff880077a68000 ti: ffff8800784d0000 task.ti: ffff8800784d0000
[   50.633486] RIP: 0010:[<ffffffff812c5b70>]  [<ffffffff812c5b70>] proc_pid_cmdline_read+0x520/0x530
[   50.659469] RSP: 0018:ffff8800784d3db8  EFLAGS: 00010206
[   50.672420] RAX: ffff880077c5b6b0 RBX: ffff8800784d3f18 RCX: 0000000000000000
[   50.697771] RDX: 0000000000000002 RSI: 00007f78e8857000 RDI: 0000000000000246
[   50.723783] RBP: ffff8800784d3e40 R08: 0000000000000008 R09: 0000000000000001
[   50.749176] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000050
[   50.775319] R13: 00007f78e8857800 R14: ffff88006fcef000 R15: ffff880077c5b600
[   50.800986] FS:  00007f78e884a740(0000) GS:ffff88007b200000(0000) knlGS:0000000000000000
[   50.826426] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   50.839435] CR2: 00007f78e8361770 CR3: 00000000790a5000 CR4: 00000000000006f0
[   50.865024] Stack:
[   50.877583]  ffffffff81d69c95 ffff8800784d3de8 0000000000000246 ffffffff81d69c95
[   50.903400]  0000000000000104 ffff880077c5b6b0 00007f78e8857000 00007fffffffe6df
[   50.929364]  00007fffffffe6d7 00007ffd519b6d60 ffff88006fc68038 000000005934de93
[   50.954794] Call Trace:
[   50.967405]  [<ffffffff81247027>] __vfs_read+0x37/0x100
[   50.980353]  [<ffffffff8142bfa6>] ? security_file_permission+0xa6/0xc0
[   50.993623]  [<ffffffff812475e2>] ? rw_verify_area+0x52/0xe0
[   51.007089]  [<ffffffff812476f2>] vfs_read+0x82/0x130
[   51.020528]  [<ffffffff812487e8>] SyS_read+0x58/0xd0
[   51.033914]  [<ffffffff81a0a132>] entry_SYSCALL_64_fastpath+0x12/0x76
[   51.046976] Code: 4c 8b 7d a8 eb e9 48 8b 9d 78 ff ff ff 4c 8b 7d 90 48 8b 03 48 39 45 a8 0f 87 f0 fe ff ff e9 d1 fe ff ff 4c 8b 7d 90 eb c6 0f 0b <0f> 0b 0f 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
[   51.087392] RIP  [<ffffffff812c5b70>] proc_pid_cmdline_read+0x520/0x530
[   51.100659]  RSP <ffff8800784d3db8>
[   51.113353] ---[ end trace 97882617ae9c6818 ]---

Turns out there are instances where the code just reads aformentioned
values without locking whatsoever - namely environ_read and get_cmdline.

Interestingly these functions look quite resilient against bogus values,
but I don't believe this should be relied upon.

The first patch gets rid of the oops bug by grabbing mmap_sem for writing.

The second patch is optional and puts locking around aformentioned
consumers for safety.  Consumers of other fields don't seem to benefit
from similar treatment and are left untouched.


This patch (of 2):

The code was taking the semaphore for reading, which does not protect
against readers nor concurrent modifications.

The problem could cause a sanity checks to fail in procfs's cmdline
reader, resulting in an OOPS.

Note that some functions perform an unlocked read of various mm fields,
but they seem to be fine despite possible modificaton.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anshuman Khandual <anshuman.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/sys.c~prctl-take-mmap-sem-for-writing-to-protect-against-others kernel/sys.c
--- a/kernel/sys.c~prctl-take-mmap-sem-for-writing-to-protect-against-others
+++ a/kernel/sys.c
@@ -1853,11 +1853,13 @@ static int prctl_set_mm_map(int opt, con
 		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
 	}
 
-	if (prctl_map.exe_fd != (u32)-1)
+	if (prctl_map.exe_fd != (u32)-1) {
 		error = prctl_set_mm_exe_file(mm, prctl_map.exe_fd);
-	down_read(&mm->mmap_sem);
-	if (error)
-		goto out;
+		if (error)
+			return error;
+	}
+
+	down_write(&mm->mmap_sem);
 
 	/*
 	 * We don't validate if these members are pointing to
@@ -1894,10 +1896,8 @@ static int prctl_set_mm_map(int opt, con
 	if (prctl_map.auxv_size)
 		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 
-	error = 0;
-out:
-	up_read(&mm->mmap_sem);
-	return error;
+	up_write(&mm->mmap_sem);
+	return 0;
 }
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
@@ -1963,7 +1963,7 @@ static int prctl_set_mm(int opt, unsigne
 
 	error = -EINVAL;
 
-	down_read(&mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
 	prctl_map.start_code	= mm->start_code;
@@ -2056,7 +2056,7 @@ static int prctl_set_mm(int opt, unsigne
 
 	error = 0;
 out:
-	up_read(&mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 	return error;
 }
 
_

Patches currently in -mm which might be from mguzik@redhat.com are


