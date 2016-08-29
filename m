From: akpm@linux-foundation.org
Subject: +
 kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch added to -mm tree
Date: Mon, 29 Aug 2016 14:50:43 -0700
Message-ID: <57c4ae33.yfXDfdUVceFUiXiD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbcH2VvA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 17:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, stable@vger.kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix double-free when failing to relocate the purgatory
has been added to the -mm tree.  Its filename is
     kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: kexec: fix double-free when failing to relocate the purgatory

If kexec_apply_relocations fails, kexec_load_purgatory frees pi->sechdrs
and pi->purgatory_buf.  This is redundant, because in case of error
kimage_file_prepare_segments calls kimage_file_post_load_cleanup, which
will also free those buffers.

This causes two warnings like the following, one for pi->sechdrs and the
other for pi->purgatory_buf:

[   18.112843] kexec-bzImage64: Loading purgatory failed
[   18.113257] ------------[ cut here ]------------
[   18.113263] WARNING: CPU: 1 PID: 2119 at mm/vmalloc.c:1490 __vunmap+0xc1/0xd0
[   18.113264] Trying to vfree() nonexistent vm area (ffffc90000e91000)
[   18.113367] Modules linked in:
[   18.113371] CPU: 1 PID: 2119 Comm: kexec Not tainted 4.8.0-rc3+ #5
[   18.113372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   18.113373]  0000000000000000 ffff88003bbb7dc8 ffffffff8132eca8 ffff88003bbb7e18
[   18.113376]  0000000000000000 ffff88003bbb7e08 ffffffff8105f1bb 000005d281175bf8
[   18.113377]  ffffc90000e91000 0000000000000000 0000000000000001 ffff88003e5f8c00
[   18.113379] Call Trace:
[   18.113384]  [<ffffffff8132eca8>] dump_stack+0x4d/0x65
[   18.113386]  [<ffffffff8105f1bb>] __warn+0xcb/0xf0
[   18.113388]  [<ffffffff8105f22f>] warn_slowpath_fmt+0x4f/0x60
[   18.113390]  [<ffffffff81176469>] ? find_vmap_area+0x19/0x70
[   18.113393]  [<ffffffff810dbb57>] ? kimage_file_post_load_cleanup+0x47/0xb0
[   18.113394]  [<ffffffff81177451>] __vunmap+0xc1/0xd0
[   18.113396]  [<ffffffff811774ce>] vfree+0x2e/0x70
[   18.113397]  [<ffffffff810dbb6e>] kimage_file_post_load_cleanup+0x5e/0xb0
[   18.113398]  [<ffffffff810dc718>] SyS_kexec_file_load+0x448/0x680
[   18.113401]  [<ffffffff811a6834>] ? putname+0x54/0x60
[   18.113403]  [<ffffffff81195d70>] ? do_sys_open+0x190/0x1f0
[   18.113407]  [<ffffffff81824e5b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[   18.113408] ---[ end trace 158bb74f5950ca2b ]---

Fix by setting pi->sechdrs an pi->purgatory_buf to NULL, since vfree
won't try to free a NULL pointer.

Link: http://lkml.kernel.org/r/1472083546-23683-1-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kexec_file.c~kexec-fix-double-free-when-failing-to-relocate-the-purgatory kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec-fix-double-free-when-failing-to-relocate-the-purgatory
+++ a/kernel/kexec_file.c
@@ -887,7 +887,10 @@ int kexec_load_purgatory(struct kimage *
 	return 0;
 out:
 	vfree(pi->sechdrs);
+	pi->sechdrs = NULL;
+
 	vfree(pi->purgatory_buf);
+	pi->purgatory_buf = NULL;
 	return ret;
 }
 
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch
kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-demonstration-code-for-kexec-buffer-passing.patch

