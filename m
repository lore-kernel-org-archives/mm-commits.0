From: akpm@linux-foundation.org
Subject: + tcrypt-init-test-sg-tables.patch added to -mm tree
Date: Fri, 30 May 2008 18:15:33 -0700
Message-ID: <200805310115.m4V1FXZ9020832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbYEaBQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 21:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, herbert@gondor.apana.org.au


The patch titled
     tcrypt: init test SG tables
has been added to the -mm tree.  Its filename is
     tcrypt-init-test-sg-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tcrypt: init test SG tables
From: Alexey Dobriyan <adobriyan@gmail.com>

Steps to reproduce:

	modprobe tcrypt		# with CONFIG_DEBUG_SG=y

testing cts(cbc(aes)) encryption
test 1 (128 bit key):
------------[ cut here ]------------
kernel BUG at include/linux/scatterlist.h:65!
invalid opcode: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0
Modules linked in: tea xts twofish twofish_common tcrypt(+) [maaaany]
Pid: 16151, comm: modprobe Not tainted 2.6.26-rc4-fat #7
RIP: 0010:[<ffffffffa0bf032e>]  [<ffffffffa0bf032e>] :cts:cts_cbc_encrypt+0x151/0x355
RSP: 0018:ffff81016f497a88  EFLAGS: 00010286
RAX: ffffe20009535d58 RBX: ffff81016f497af0 RCX: 0000000087654321
RDX: ffff8100010d4f28 RSI: ffff81016f497ee8 RDI: ffff81016f497ac0
RBP: ffff81016f497c38 R08: 0000000000000000 R09: 0000000000000011
R10: ffffffff00000008 R11: ffff8100010d4f28 R12: ffff81016f497ac0
R13: ffff81016f497b30 R14: 0000000000000010 R15: 0000000000000010
FS:  00007fac6fa276f0(0000) GS:ffffffff8060e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f12ca7cc000 CR3: 000000016f441000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process modprobe (pid: 16151, threadinfo ffff81016f496000, task ffff8101755b4ae0)
Stack:  0000000000000001 ffff81016f496000 ffffffff80719f78 0000000000000001
 0000000000000001 ffffffff8020c87c ffff81016f99c918 20646c756f772049
 65687420656b696c 0000000000000020 0000000000000000 0000000033341102
Call Trace:
 [<ffffffff8020c87c>] ? restore_args+0x0/0x30
 [<ffffffffa04aa311>] ? :aes_generic:crypto_aes_expand_key+0x311/0x369
 [<ffffffff802ab453>] ? check_object+0x15a/0x213
 [<ffffffff802aad22>] ? init_object+0x6e/0x76
 [<ffffffff802ac3ae>] ? __slab_free+0xfc/0x371
 [<ffffffffa0bf05ed>] :cts:crypto_cts_encrypt+0xbb/0xca
 [<ffffffffa07108de>] ? :crypto_blkcipher:setkey+0xc7/0xec
 [<ffffffffa07110b8>] :crypto_blkcipher:async_encrypt+0x38/0x3a
 [<ffffffffa2ce9341>] :tcrypt:test_cipher+0x261/0x7c6
 [<ffffffffa2cfd9df>] :tcrypt:tcrypt_mod_init+0x9df/0x1b30
 [<ffffffff80261e35>] sys_init_module+0x9e/0x1b2
 [<ffffffff8020c15a>] system_call_after_swapgs+0x8a/0x8f
Code: 45 c0 e8 aa 24 63 df 48 c1 e8 0c 48 b9 00 00 00 00 00 e2 ff ff 48 8b 55 88 48 6b c0 68 48 01 c8 b9 21 43 65 87 48 39 4d 80 74 04 <0f> 0b eb fe f6 c2 01 74 04 0f 0b eb fe 83 e2 03 4c 89 ef 44 89
RIP  [<ffffffffa0bf032e>] :cts:cts_cbc_encrypt+0x151/0x355
 RSP <ffff81016f497a88>
---[ end trace e8bahiarjand37fd ]---

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/cts.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN crypto/cts.c~tcrypt-init-test-sg-tables crypto/cts.c
--- a/crypto/cts.c~tcrypt-init-test-sg-tables
+++ a/crypto/cts.c
@@ -89,6 +89,9 @@ static int cts_cbc_encrypt(struct crypto
 	if (lastn < 0)
 		return -EINVAL;
 
+	sg_init_table(sgsrc, 1);
+	sg_init_table(sgdst, 1);
+
 	memset(s, 0, sizeof(s));
 	scatterwalk_map_and_copy(s, src, offset, nbytes, 0);
 
@@ -172,6 +175,9 @@ static int cts_cbc_decrypt(struct crypto
 	if (lastn < 0)
 		return -EINVAL;
 
+	sg_init_table(sgsrc, 1);
+	sg_init_table(sgdst, 1);
+
 	scatterwalk_map_and_copy(s, src, offset, nbytes, 0);
 
 	lcldesc.tfm = ctx->child;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

edd-fix-incorrect-return-of-1-from-module_init.patch
linux-next.patch
cifs-switch-to-seq_files.patch
isdn-divas-fix-proc-creation.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
tcrypt-init-test-sg-tables.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

