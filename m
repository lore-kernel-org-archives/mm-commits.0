From: akpm@linux-foundation.org
Subject: [merged]
 proc-fix-null-dereference-when-reading-proc-pid-auxv.patch removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:42 -0700
Message-ID: <58139952.6CV9Elv5FXKKgne+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030240AbcJ1San (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chianglungyu@gmail.com, jdanis@google.com, john.stultz@linaro.org, keescook@chromium.org, mguzik@redhat.com, mhocko@suse.com, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix NULL dereference when reading /proc/<pid>/auxv
has been removed from the -mm tree.  Its filename was
     proc-fix-null-dereference-when-reading-proc-pid-auxv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Leon Yu <chianglungyu@gmail.com>
Subject: proc: fix NULL dereference when reading /proc/<pid>/auxv

Reading auxv of any kernel thread results in NULL pointer dereferencing in
auxv_read() where mm can be NULL.  Fix that by checking for NULL mm and
bailing out early.  This is also the original behavior changed by recent
commit c5317167854e ("proc: switch auxv to use of __mem_open()").

# cat /proc/2/auxv
[    8.964445] Unable to handle kernel NULL pointer dereference at virtual address 000000a8
[    8.972555] pgd = e99e0000
[    8.975282] [000000a8] *pgd=399e6835, *pte=00000000, *ppte=00000000
[    8.981572] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[    8.986967] Modules linked in:
[    8.990029] CPU: 3 PID: 113 Comm: cat Not tainted 4.9.0-rc1-ARCH+ #1
[    8.996379] Hardware name: BCM2709
[    8.999778] task: ea3b0b00 task.stack: e99b2000
[    9.004314] PC is at auxv_read+0x24/0x4c
[    9.008241] LR is at do_readv_writev+0x2fc/0x37c
[    9.012860] pc : [<b0135f80>]    lr : [<b00e5900>]    psr: 80070013
[    9.012860] sp : e99b3d08  ip : 00000000  fp : 00000000
[    9.024337] r10: 00000000  r9 : b0135f5c  r8 : e99b3d24
[    9.029561] r7 : 00001000  r6 : 00000000  r5 : 00000000  r4 : 00000000
[    9.036087] r3 : 00000008  r2 : e99b3de0  r1 : 00001000  r0 : e98ea000
[    9.042615] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    9.049750] Control: 10c5387d  Table: 399e006a  DAC: 00000055
[    9.055495] Process cat (pid: 113, stack limit = 0xe99b2210)
[    9.061152] Stack: (0xe99b3d08 to 0xe99b4000)
[    9.065513] 3d00:                   00000000 00000000 ea0d46c0 b00e5900 e99b3d20 e99b3d24
[    9.073696] 3d20: e9960b80 00000002 00000000 00010000 e9960b80 00000010 00000000 024200ca
[    9.081878] 3d40: ea8855f0 00000000 e9cac8f0 00000000 ffffffff e9960c00 0000000f 00001000
[    9.090060] 3d60: b0407b68 024200c0 b05494c0 00010000 e9960c00 b020863c 01000000 e99b3ddc
[    9.098243] 3d80: e99b3dd8 e99651c0 e9960c00 00000000 00010000 b020aca0 e9c041e8 00000010
[    9.106424] 3da0: e99b3e00 ffffe000 00000000 e99b3ec0 e99b3e00 b00e59c0 e99b3de0 00000000
[    9.114606] 3dc0: e9960c00 b010eed4 00000000 00020000 ea0d46c0 af000000 e99651c0 00000000
[    9.122788] 3de0: 00000000 00000000 e99b2000 00000008 00000000 01000000 e9960c00 00000000
[    9.130970] 3e00: e98ea000 00001000 e9970000 00001000 e9975000 00001000 e9971000 00001000
[    9.139152] 3e20: e99e5000 00001000 e98e8000 00001000 e9976000 00001000 e9977000 00001000
[    9.147334] 3e40: e9978000 00001000 e9979000 00001000 e997a000 00001000 e997b000 00001000
[    9.155516] 3e60: e9a03000 00001000 e99d6000 00001000 e99d7000 00001000 e9a14000 00001000
[    9.163698] 3e80: 01000000 e9960c00 e99b3ef0 01000000 00000000 ea0d46c0 00000000 00000000
[    9.171880] 3ea0: 00000000 b010eb4c 00000000 e98f2700 00000817 00000000 b010e268 00000000
[    9.180061] 3ec0: 00000000 00000000 00000000 e9964480 01000000 e99b3f50 e99b3f48 ea0d46c0
[    9.188244] 3ee0: 00000000 e99b3f50 01000000 b010ed6c 01000000 01000000 00000000 e9964480
[    9.196425] 3f00: 00000000 00000000 e99b3f50 00000000 00000000 00000000 00000400 ea0d46c0
[    9.204607] 3f20: ea0d46c0 7fffffff 00000000 e9964480 e9964480 b00e5e38 01000000 00000000
[    9.212788] 3f40: 00000000 ea0f21b8 00000000 00000000 00000000 00000000 ea0d46c8 00000000
[    9.220970] 3f60: 00000000 01000000 000000ef b000f4a4 e99b2000 00000000 00000000 b00e67d4
[    9.229152] 3f80: 7fffffff 00000000 e99b2000 00000000 01000000 00000000 01000000 000000ef
[    9.237334] 3fa0: b000f4a4 b000f300 01000000 00000000 00000001 00000003 00000000 01000000
[    9.245515] 3fc0: 01000000 00000000 01000000 000000ef 00000001 00000000 00000001 00000000
[    9.253698] 3fe0: a6ee73c0 aeeaecf4 00014bbc a6ee73cc 60070010 00000001 55555555 55555555
[    9.261895] [<b0135f80>] (auxv_read) from [<b00e5900>] (do_readv_writev+0x2fc/0x37c)
[    9.269651] [<b00e5900>] (do_readv_writev) from [<b00e59c0>] (vfs_readv+0x40/0x58)
[    9.277234] [<b00e59c0>] (vfs_readv) from [<b010eed4>] (default_file_splice_read+0x140/0x240)
[    9.285769] [<b010eed4>] (default_file_splice_read) from [<b010eb4c>] (splice_direct_to_actor+0xa0/0x230)
[    9.295345] [<b010eb4c>] (splice_direct_to_actor) from [<b010ed6c>] (do_splice_direct+0x90/0xb8)
[    9.304140] [<b010ed6c>] (do_splice_direct) from [<b00e5e38>] (do_sendfile+0x1a0/0x308)
[    9.312155] [<b00e5e38>] (do_sendfile) from [<b00e67d4>] (SyS_sendfile64+0xd4/0xe8)
[    9.319823] [<b00e67d4>] (SyS_sendfile64) from [<b000f300>] (ret_fast_syscall+0x0/0x34)
[    9.327829] Code: e1a01002 e1a02003 e1a03004 e2833008 (e593e0a0)
[    9.333973] ---[ end trace d3f50081f24b99ce ]---

Fixes: c5317167854e ("proc: switch auxv to use of __mem_open()")
Link: http://lkml.kernel.org/r/1476966200-14457-1-git-send-email-chianglungyu@gmail.com
Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Janis Danisevskis <jdanis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/base.c~proc-fix-null-dereference-when-reading-proc-pid-auxv fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-null-dereference-when-reading-proc-pid-auxv
+++ a/fs/proc/base.c
@@ -1012,6 +1012,9 @@ static ssize_t auxv_read(struct file *fi
 {
 	struct mm_struct *mm = file->private_data;
 	unsigned int nwords = 0;
+
+	if (!mm)
+		return 0;
 	do {
 		nwords += 2;
 	} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
_

Patches currently in -mm which might be from chianglungyu@gmail.com are


