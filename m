From: akpm@linux-foundation.org
Subject: + vfs-fix-switch_names-breakage-in-short-to-short-case.patch added to -mm tree
Date: Tue, 11 Nov 2008 14:14:16 -0800
Message-ID: <200811112214.mABMEHfc010014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbYKKWO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 17:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, adobriyan@gmail.com, mingo@elte.hu, rjw@sisk.pl, stable@kernel.org, vegard.nossum@gmail.comviro@ZenIV.linux.org.uk


The patch titled
     vfs: fix switch_names() breakage in short-to-short case
has been added to the -mm tree.  Its filename is
     vfs-fix-switch_names-breakage-in-short-to-short-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix switch_names() breakage in short-to-short case
From: Al Viro <viro@ZenIV.linux.org.uk>

Vegard sayeth:

When I run readlink on the /proc/*/exe-file for udevd, the kernel
returns some unitialized data to userspace:

# strace -e trace=readlink readlink /proc/4762/exe
readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30

You can see it because the kernel thinks that the string is 30 bytes
long, but in fact it is only 12 (including the '\0').

If we explicitly clear the buffer before calling readlink, we can also
see that some garbage has been filled in there, after the string:

# ./readlink /proc/4762/exe
readlink(/proc/4762/exe) = 30
2f7362696e2f7564657664000000ffffffad4effffffadffffffdeffffffffffffffff202864656c657465642900000000000000000000000000000

(Output is from following simple program:)

#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        char buf[1024];
        int i;
        ssize_t n;

        memset(buf, 0, sizeof(buf));
        n = readlink(argv[1], buf, sizeof(buf));

        printf("readlink(%s) = %d\n", argv[1], n);

        for (i = 0; i < sizeof(buf); ++i)
                printf("%02x", buf[i]);
        printf("\n");

        return 0;
}

It was discovered by kmemcheck:

WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6a109e4)
64000000ad4eaddeffffffffffffffff000000000200000000000000c0838ff8
 i i u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
         ^

Pid: 21511, comm: readlink Not tainted (2.6.28-rc1 #58) 945P-A
EIP: 0060:[<c04f988d>] EFLAGS: 00000296 CPU: 0
EIP is at __d_path+0x8d/0x1c0
EAX: 0000000e EBX: d7ba0fe7 ECX: 00000001 EDX: f68b0b40
ESI: f6a109e4 EDI: d7ba0fef EBP: e58c3f28 ESP: c2569c08
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6c1d704 CR3: 31fc7000 CR4: 00000650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c04fa4b0>] d_path+0xb0/0xd0
 [<c052c37c>] proc_pid_readlink+0x6c/0xc0
 [<c04eda34>] sys_readlinkat+0x94/0xa0
 [<c04eda67>] sys_readlink+0x27/0x30
 [<c0422f83>] sysenter_do_call+0x12/0x3f
 [<ffffffff>] 0xffffffff





We want ->name.len to match the resulting name on *both* source and target.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~vfs-fix-switch_names-breakage-in-short-to-short-case fs/dcache.c
--- a/fs/dcache.c~vfs-fix-switch_names-breakage-in-short-to-short-case
+++ a/fs/dcache.c
@@ -1621,8 +1621,11 @@ static void switch_names(struct dentry *
 			 */
 			memcpy(dentry->d_iname, target->d_name.name,
 					target->d_name.len + 1);
+			dentry->d_name.len = target->d_name.len;
+			return;
 		}
 	}
+	do_switch(dentry->d_name.len, target->d_name.len);
 }
 
 /*
@@ -1682,7 +1685,6 @@ already_unhashed:
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	do_switch(dentry->d_name.len, target->d_name.len);
 	do_switch(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
@@ -1792,7 +1794,6 @@ static void __d_materialise_dentry(struc
 	struct dentry *dparent, *aparent;
 
 	switch_names(dentry, anon);
-	do_switch(dentry->d_name.len, anon->d_name.len);
 	do_switch(dentry->d_name.hash, anon->d_name.hash);
 
 	dparent = dentry->d_parent;
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

vfs-fix-shrink_submounts.patch
linux-next.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch

