From: akpm@linux-foundation.org
Subject: + mm-install_special_mapping-skips-security_file_mmap-check.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:28:41 -0800
Message-ID: <201012092028.oB9KSfB1005258__25296.0809776143$1291926558$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721Ab0LIU3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: taviso@cmpxchg8b.com, eugene@redhat.com, greg@kroah.com, jmorris@namei.org, kees.cook@canonical.com, randy.dunlap@oracle.com, stable@kernel.org, swiecki@google.com, taviso@google.com


The patch titled
     mm: install_special_mapping skips security_file_mmap() check
has been added to the -mm tree.  Its filename is
     mm-install_special_mapping-skips-security_file_mmap-check.patch

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
Subject: mm: install_special_mapping skips security_file_mmap() check
From: Tavis Ormandy <taviso@cmpxchg8b.com>

The install_special_mapping routine (used, for example, to setup the vdso)
skips the security check before insert_vm_struct, allowing a local
attacker to bypass the mmap_min_addr security restriction by limiting the
available pages for special mappings.  bprm_mm_init() also skips the
check, although I don't think this can be used to bypass any restrictions,
I don't see any reason not to have the security check.

$ uname -m
x86_64
$ cat /proc/sys/vm/mmap_min_addr
65536
$ cat install_special_mapping.s
section .bss
    resb BSS_SIZE
section .text
    global _start
    _start:
        mov     eax, __NR_pause
        int     0x80
$ nasm -D__NR_pause=29 -DBSS_SIZE=0xfffed000 -f elf -o install_special_mapping.o install_special_mapping.s
$ ld -m elf_i386 -Ttext=0x10000 -Tbss=0x11000 -o install_special_mapping install_special_mapping.o
$ ./install_special_mapping &
[1] 14303
$ cat /proc/14303/maps
0000f000-00010000 r-xp 00000000 00:00 0                                  [vdso]
00010000-00011000 r-xp 00001000 00:19 2453665                            /home/taviso/install_special_mapping
00011000-ffffe000 rwxp 00000000 00:00 0                                  [stack]

It's worth noting that Red Hat are shipping with mmap_min_addr set to 4096.

Signed-off-by: Tavis Ormandy <taviso@google.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Robert Swiecki <swiecki@google.com>
Cc: James Morris <jmorris@namei.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Eugene Teo <eugene@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++++++
 mm/mmap.c |    5 +++++
 2 files changed, 12 insertions(+)

diff -puN fs/exec.c~mm-install_special_mapping-skips-security_file_mmap-check fs/exec.c
--- a/fs/exec.c~mm-install_special_mapping-skips-security_file_mmap-check
+++ a/fs/exec.c
@@ -275,7 +275,14 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
+
 	if (err)
 		goto err;
 
diff -puN mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check mm/mmap.c
--- a/mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check
+++ a/mm/mmap.c
@@ -2479,6 +2479,11 @@ int install_special_mapping(struct mm_st
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
+	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
+		kmem_cache_free(vm_area_cachep, vma);
+		return -EPERM;
+	}
+
 	if (unlikely(insert_vm_struct(mm, vma))) {
 		kmem_cache_free(vm_area_cachep, vma);
 		return -ENOMEM;
_

Patches currently in -mm which might be from taviso@cmpxchg8b.com are

mm-install_special_mapping-skips-security_file_mmap-check.patch
mm-install_special_mapping-skips-security_file_mmap-check-fix.patch

