From: akpm@linux-foundation.org
Subject: [patch 17/78] /proc/kcore: update physical address for kcore ram
 and text
Date: Mon, 27 Feb 2017 14:27:31 -0800
Message-ID: <58b4a7d3.gllcSIlVj+Ve4FoO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbdB0WgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, panand@redhat.com, anderson@redhat.com, bhe@redhat.com, dyoung@redhat.com, keescook@chromium.org, kumagai-atsushi@mxc.nes.nec.co.jp, simon.horman@netronome.com

From: Pratyush Anand <panand@redhat.com>
Subject: /proc/kcore: update physical address for kcore ram and text

Currently all the p_paddr of PT_LOAD headers are assigned to 0, which is
not true and could be misleading, since 0 is a valid physical address.

User space tools like makedumpfile needs to know physical address for
PT_LOAD segments of direct mapped regions.  Therefore this patch updates
paddr for such regions.  It also sets an invalid paddr (-1) for other
regions, so that user space tool can know whether a physical address
provided in PT_LOAD is correct or not.

I do not know why it was 0, which is a valid physical address.  But
certainly, it might break some user space tools, and those need to be
fixed.  For example, see following code from kexec-tools

kexec/kexec-elf.c:build_mem_phdrs()

435                 if ((phdr->p_paddr + phdr->p_memsz) < phdr->p_paddr) {
436                         /* The memory address wraps */
437                         if (probe_debug) {
438                                 fprintf(stderr, "ELF address wrap 
around\n");
439                         }
440                         return -1;
441                 }

We do not need to perform above check for an invalid physical address.

I think, kexec-tools and makedumpfile will need fixup.  I already have
those fixup which will be sent upstream once this patch makes through. 
Pro with this approach is that, it will help to calculate variable like
page_offset, phys_base from PT_LOAD even when they are randomized and
therefore will reduce many variable and version specific values in user
space tools.

Having an ASLR offset information can help to translate an identity
mapped virtual address to a physical address.  But that would be an
additional field in PT_LOAD header structure and an arch dependent
value.

Moreover, sending a valid physical address like 0 does not seem right. 
So, IMHO it is better to fix that and send valid physical address when
available (identity mapped).

Link: http://lkml.kernel.org/r/f951340d2917cdd2a329fae9837a83f2059dc3b2.1485318868.git.panand@redhat.com
Signed-off-by: Pratyush Anand <panand@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Simon Horman <simon.horman@netronome.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~proc-kcore-update-physical-address-for-kcore-ram-and-text fs/proc/kcore.c
--- a/fs/proc/kcore.c~proc-kcore-update-physical-address-for-kcore-ram-and-text
+++ a/fs/proc/kcore.c
@@ -373,7 +373,10 @@ static void elf_kcore_store_hdr(char *bu
 		phdr->p_flags	= PF_R|PF_W|PF_X;
 		phdr->p_offset	= kc_vaddr_to_offset(m->addr) + dataoff;
 		phdr->p_vaddr	= (size_t)m->addr;
-		phdr->p_paddr	= 0;
+		if (m->type == KCORE_RAM || m->type == KCORE_TEXT)
+			phdr->p_paddr	= __pa(m->addr);
+		else
+			phdr->p_paddr	= (elf_addr_t)-1;
 		phdr->p_filesz	= phdr->p_memsz	= m->size;
 		phdr->p_align	= PAGE_SIZE;
 	}
_
