From: akpm@linux-foundation.org
Subject: + binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch added to
 -mm tree
Date: Mon, 13 Apr 2015 16:02:29 -0700
Message-ID: <552c4b05.WLV2DMwcYH+ETYnP%akpm__3619.95837088234$1428966163$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbDMXCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Apr 2015 19:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: md@google.com, jkosina@suse.cz, keescook@chromium.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: fix bug in loading of PIE binaries
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Davidson <md@google.com>
Subject: fs/binfmt_elf.c: fix bug in loading of PIE binaries

With CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE enabled, and a normal top-down
address allocation strategy, load_elf_binary() will attempt to map a PIE
binary into an address range immediately below mm->mmap_base.

Unfortunately, load_elf_ binary() does not take account of the need to
allocate sufficient space for the entire binary which means that, while
the first PT_LOAD segment is mapped below mm->mmap_base, the subsequent
PT_LOAD segment(s) end up being mapped above mm->mmap_base into the are
that is supposed to be the "gap" between the stack and the binary.

Since the size of the "gap" on x86_64 is only guaranteed to be 128MB this
means that binaries with large data segments > 128MB can end up mapping
part of their data segment over their stack resulting in corruption of the
stack (and the data segment once the binary starts to run).

Any PIE binary with a data segment > 128MB is vulnerable to this although
address randomization means that the actual gap between the stack and the
end of the binary is normally greater than 128MB.  The larger the data
segment of the binary the higher the probability of failure.

Fix this by calculating the total size of the binary in the same way as
load_elf_interp().

Signed-off-by: Michael Davidson <md@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-bug-in-loading-of-pie-binaries fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-bug-in-loading-of-pie-binaries
+++ a/fs/binfmt_elf.c
@@ -862,6 +862,7 @@ static int load_elf_binary(struct linux_
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
 		int elf_prot = 0, elf_flags;
 		unsigned long k, vaddr;
+		unsigned long total_size = 0;
 
 		if (elf_ppnt->p_type != PT_LOAD)
 			continue;
@@ -924,10 +925,16 @@ static int load_elf_binary(struct linux_
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #endif
+			total_size = total_mapping_size(elf_phdata,
+							loc->elf_ex.e_phnum);
+			if (!total_size) {
+				error = -EINVAL;
+				goto out_free_dentry;
+			}
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags, 0);
+				elf_prot, elf_flags, total_size);
 		if (BAD_ADDR(error)) {
 			retval = IS_ERR((void *)error) ?
 				PTR_ERR((void*)error) : -EINVAL;
_

Patches currently in -mm which might be from md@google.com are

binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch

