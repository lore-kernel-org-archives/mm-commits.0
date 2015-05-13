From: akpm@linux-foundation.org
Subject: +
 prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line.patch added to -mm tree
Date: Wed, 13 May 2015 14:50:09 -0700
Message-ID: <5553c711.9Q4MunF9toRuw3OZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442AbbEMVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 May 2015 17:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karahmed@amazon.de, ebiederm@xmission.com, hbabu@us.ibm.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/kexec: prepend elfcorehdr instead of appending it to the crash-kernel command-line.
has been added to the -mm tree.  Its filename is
     prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KarimAllah Ahmed <karahmed@amazon.de>
Subject: x86/kexec: prepend elfcorehdr instead of appending it to the crash-kernel command-line.

Any parameter passed after '--' in the kernel command-line will not be
parsed by the kernel at all, instead it will be passed directly to init
process.

Currently the kernel appends elfcorehdr=<paddr> to the cmdline passed from
kexec load, and if this command-line is used to pass parameters to init
process this means that 'elfcorehdr' will not be parsed as a kernel
parameter at all which will be a problem for vmcore subsystem since it
will know nothing about the location of the ELF structure!

Prepending 'elfcorehdr' instead of appending it fixes this problem since
it ensures that it always comes before '--' and so it's always parsed as a
kernel command-line parameter.

Even with this patch things can still go wrong if 'CONFIG_CMDLINE' was
also used to embedd a command-line to the crash dump kernel and this
command-line contains '--' since the current behavior of the kernel is to
actually append the boot loader command-line to the embedded command-line.

Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/kexec-bzimage64.c~prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -72,15 +72,16 @@ static int setup_cmdline(struct kimage *
 			 unsigned long cmdline_len)
 {
 	char *cmdline_ptr = ((char *)params) + cmdline_offset;
-	unsigned long cmdline_ptr_phys, len;
+	unsigned long cmdline_ptr_phys, len = 0;
 	uint32_t cmdline_low_32, cmdline_ext_32;
 
-	memcpy(cmdline_ptr, cmdline, cmdline_len);
 	if (image->type == KEXEC_TYPE_CRASH) {
-		len = sprintf(cmdline_ptr + cmdline_len - 1,
-			" elfcorehdr=0x%lx", image->arch.elf_load_addr);
-		cmdline_len += len;
+		len = sprintf(cmdline_ptr,
+			"elfcorehdr=0x%lx ", image->arch.elf_load_addr);
 	}
+	memcpy(cmdline_ptr + len, cmdline, cmdline_len);
+	cmdline_len += len;
+
 	cmdline_ptr[cmdline_len - 1] = '\0';
 
 	pr_debug("Final command line is: %s\n", cmdline_ptr);
_

Patches currently in -mm which might be from karahmed@amazon.de are

prepend-elfcorehdr-instead-of-appending-it-to-the-crash-kernel-command-line.patch

