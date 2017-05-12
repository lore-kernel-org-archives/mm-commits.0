From: akpm@linux-foundation.org
Subject: +
 powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch added to -mm tree
Date: Fri, 12 May 2017 14:06:17 -0700
Message-ID: <591623c9.UK/4nqcX18VcI1IH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932618AbdELVGS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 17:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, benh@kernel.crashing.org, dyoung@redhat.com, ebiederm@xmission.com, hbathini@linux.vnet.ibm.com, holzheu@linux.vnet.ibm.com, jgross@suse.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: use the correct VMCOREINFO_NOTE_SIZE for phdr
has been added to the -mm tree.  Its filename is
     powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: powerpc/fadump: use the correct VMCOREINFO_NOTE_SIZE for phdr

vmcoreinfo_max_size stands for the vmcoreinfo_data, the correct one we
should use is vmcoreinfo_note whose total size is VMCOREINFO_NOTE_SIZE.

Like explained in commit 77019967f06b ("kdump: fix exported size of
vmcoreinfo note"), it should not affect the actual function, but we better
fix it, also this change should be safe and backward compatible.

After this, we can get rid of variable vmcoreinfo_max_size, let's use the
corresponding macros directly, fewer variables means more safety for
vmcoreinfo operation.

Link: http://lkml.kernel.org/r/1493281021-20737-2-git-send-email-xlpang@redhat.com
Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Reviewed-by: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/fadump.c |    3 +--
 include/linux/crash_core.h   |    1 -
 kernel/crash_core.c          |    3 +--
 3 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/fadump.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr
+++ a/arch/powerpc/kernel/fadump.c
@@ -893,8 +893,7 @@ static int fadump_create_elfcore_headers
 
 	phdr->p_paddr	= fadump_relocate(paddr_vmcoreinfo_note());
 	phdr->p_offset	= phdr->p_paddr;
-	phdr->p_memsz	= vmcoreinfo_max_size;
-	phdr->p_filesz	= vmcoreinfo_max_size;
+	phdr->p_memsz	= phdr->p_filesz = VMCOREINFO_NOTE_SIZE;
 
 	/* Increment number of program headers. */
 	(elf->e_phnum)++;
diff -puN include/linux/crash_core.h~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr include/linux/crash_core.h
--- a/include/linux/crash_core.h~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr
+++ a/include/linux/crash_core.h
@@ -53,7 +53,6 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 
 extern u32 *vmcoreinfo_note;
 extern size_t vmcoreinfo_size;
-extern size_t vmcoreinfo_max_size;
 
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len);
diff -puN kernel/crash_core.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr kernel/crash_core.c
--- a/kernel/crash_core.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr
+++ a/kernel/crash_core.c
@@ -16,7 +16,6 @@
 /* vmcoreinfo stuff */
 static unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
-size_t vmcoreinfo_max_size = VMCOREINFO_BYTES;
 u32 *vmcoreinfo_note;
 
 /*
@@ -343,7 +342,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
+	r = min(r, VMCOREINFO_BYTES - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-move-vmcoreinfo-out-of-the-kernels-bss-section.patch
powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch
kdump-protect-vmcoreinfo-data-under-the-crash-memory.patch

