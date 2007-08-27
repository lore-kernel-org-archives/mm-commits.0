From: akpm@linux-foundation.org
Subject: + fix-kobject-uevent-string-handling-errors.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:55:03 -0700
Message-ID: <200708272155.l7RLt4jo030477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933011AbXH0VzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Fix kobject uevent string handling errors
has been added to the -mm tree.  Its filename is
     fix-kobject-uevent-string-handling-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix kobject uevent string handling errors
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix kobject uevent string handling errors

- increment env->buflen in dmi-id.c
- fix off-by-one in add_uevent_var in error checking of vsnprintf
- add warnings when add_uevent_var. Proper handling of its return values should
  really be done by the callers, but they aren't, so things currently
  fail silently. This is why I add warnings.

Fixes the following BUG in 2.6.23-rc3-mm1:

[   23.876358] skb_over_panic: text:c0252e5b len:97 put:11 head:c2b54400 data:c2b54400 tail:0xc2b54461 end:0xc2b54460 dev:<NULL>
[   23.910278] ------------[ cut here ]------------
[   23.924080] Kernel BUG at c039e12c [verbose debug info unavailable]
[   23.942809] invalid opcode: 0000 [#1] PREEMPT SMP
[   23.957213] last sysfs file: /devices/pci0000:00/0000:00:1f.1/ide0/0.0/media
[   23.978275] Modules linked in:
[   23.987429]
[   23.991884] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #286)
[   24.014773] EIP: 0060:[<c039e12c>] EFLAGS: 00010286 CPU: 0
[   24.031168] EIP is at skb_over_panic+0x5c/0x60
[   24.044444] EAX: 00000084 EBX: c2b54400 ECX: 00000001 EDX: 00000000
[   24.063171] ESI: 00000000 EDI: c2b54456 EBP: c2b67eb4 ESP: c2b67e88
[   24.081895]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   24.098027] Process udevtrigger (pid: 1038, ti=c2b66000 task=c2b08030 task.ti=c2b66000)
[   24.121423] Stack: c050110c c0252e5b 00000061 0000000b c2b54400 c2b54400 c2b54461 c2b54460
[   24.146658]        c04d21e0 c2ad8e80 00000005 c2b67efc c0252e60 c2b54400 c04d2183 c04ce0e4
[   24.171897]        c2f60c40 00000000 c04ce0e4 c2f60c40 c04e2ecb c05401e0 c2f58000 c2b67f04
[   24.197135] Call Trace:
[   24.205001]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
[   24.220388]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
[   24.235772]  [<c01098da>] show_registers+0xca/0x250
[   24.250378]  [<c0109b75>] die+0x115/0x280
[   24.262389]  [<c04187d1>] do_trap+0x91/0xc0
[   24.274919]  [<c0109fc9>] do_invalid_op+0x89/0xa0
[   24.289004]  [<c041858a>] error_code+0x72/0x78
[   24.302313]  [<c0252e60>] kobject_uevent_env+0x370/0x390
[   24.318217]  [<c0252e8a>] kobject_uevent+0xa/0x10
[   24.332303]  [<c02c524b>] store_uevent+0x2b/0x70
[   24.346130]  [<c02c4f6f>] dev_attr_store+0x2f/0x40
[   24.360476]  [<c01cd080>] sysfs_write_file+0xa0/0x100
[   24.375602]  [<c018cb89>] vfs_write+0x99/0x130
[   24.388910]  [<c018d26d>] sys_write+0x3d/0x70
[   24.401958]  [<c0108596>] syscall_call+0x7/0xb
[   24.415265]  =======================
[   24.425947] INFO: lockdep is turned off.
[   24.437665] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 0c 11 50 c0 89 44 24 08 e8 84 20 d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec 0c 8b 40 50 39
[   24.496006] EIP: [<c039e12c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2b67e88

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi-id.c |    5 +++--
 lib/kobject_uevent.c      |   12 ++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/firmware/dmi-id.c~fix-kobject-uevent-string-handling-errors drivers/firmware/dmi-id.c
--- a/drivers/firmware/dmi-id.c~fix-kobject-uevent-string-handling-errors
+++ a/drivers/firmware/dmi-id.c
@@ -152,9 +152,10 @@ static int dmi_dev_uevent(struct device 
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
 	len = get_modalias(&env->buf[env->buflen - 1],
-			   sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen))
+			   sizeof(env->buf) - (env->buflen - 1));
+	if (len >= (sizeof(env->buf) - (env->buflen - 1)))
 		return -ENOMEM;
+	env->buflen += len + 1;
 	return 0;
 }
 
diff -puN lib/kobject_uevent.c~fix-kobject-uevent-string-handling-errors lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~fix-kobject-uevent-string-handling-errors
+++ a/lib/kobject_uevent.c
@@ -247,8 +247,12 @@ int add_uevent_var(struct kobj_uevent_en
 	va_list args;
 	int len;
 
-	if (env->envp_idx >= ARRAY_SIZE(env->envp))
+	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
+		printk("add_uevent_var: too small array size %u %u\n",
+			env->envp_idx, ARRAY_SIZE(env->envp));
+		WARN_ON(1);
 		return -ENOMEM;
+	}
 
 	va_start(args, format);
 	len = vsnprintf(&env->buf[env->buflen],
@@ -256,8 +260,12 @@ int add_uevent_var(struct kobj_uevent_en
 			format, args);
 	va_end(args);
 
-	if (len + 1 >= (sizeof(env->buf) - env->buflen))
+	if (len >= (sizeof(env->buf) - env->buflen)) {
+		printk("add_uevent_var: failed vsnprintf %d %u\n",
+			len, (sizeof(env->buf) - env->buflen));
+		WARN_ON(1);
 		return -ENOMEM;
+	}
 
 	env->envp[env->envp_idx++] = &env->buf[env->buflen];
 	env->buflen += len + 1;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
sysfs-crash-debugging.patch
fix-kobject-uevent-string-handling-errors.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
