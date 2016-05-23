From: akpm@linux-foundation.org
Subject: [patch 70/84] mm, elf: handle vm_brk error
Date: Mon, 23 May 2016 16:25:39 -0700
Message-ID: <57439173.2EhmqKyLFg5+vZrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbcEWXZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: mm, elf: handle vm_brk error

load_elf_library doesn't handle vm_brk failure although nothing really
indicates it cannot do that because the function is allowed to fail due to
vm_mmap failures already.  This might be not a problem now but later patch
will make vm_brk killable (resp.  mmap_sem for write waiting will become
killable) and so the failure will be more probable.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~mm-elf-handle-vm_brk-error fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-elf-handle-vm_brk-error
+++ a/fs/binfmt_elf.c
@@ -1176,8 +1176,11 @@ static int load_elf_library(struct file
 	len = ELF_PAGESTART(eppnt->p_filesz + eppnt->p_vaddr +
 			    ELF_MIN_ALIGN - 1);
 	bss = eppnt->p_memsz + eppnt->p_vaddr;
-	if (bss > len)
-		vm_brk(len, bss - len);
+	if (bss > len) {
+		error = vm_brk(len, bss - len);
+		if (BAD_ADDR(error))
+			goto out_free_ph;
+	}
 	error = 0;
 
 out_free_ph:
_
