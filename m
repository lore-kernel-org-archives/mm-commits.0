From: akpm@linux-foundation.org
Subject: + elf-enforce-map_fixed-on-overlaying-elf-segments.patch added to -mm tree
Date: Tue, 13 Feb 2018 15:25:19 -0800
Message-ID: <5a8373df.haWx4G1mNoOQxH9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965783AbeBMXZV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 18:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, abdhalee@linux.vnet.ibm.com, avagin@openvz.org, broonie@kernel.org, joel@jms.id.au, keescook@chromium.org, khalid.aziz@oracle.com, khandual@linux.vnet.ibm.com, mpe@ellerman.id.au, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: elf: enforce MAP_FIXED on overlaying elf segments
has been added to the -mm tree.  Its filename is
     elf-enforce-map_fixed-on-overlaying-elf-segments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/elf-enforce-map_fixed-on-overlaying-elf-segments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/elf-enforce-map_fixed-on-overlaying-elf-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: elf: enforce MAP_FIXED on overlaying elf segments

Anshuman has reported that with "fs, elf: drop MAP_FIXED usage from
elf_map" applied, some ELF binaries in his environment fail to start with

 [   23.423642] 9148 (sed): Uhuuh, elf segment at 0000000010030000 requested but the memory is mapped already
 [   23.423706] requested [10030000, 10040000] mapped [10030000, 10040000] 100073 anon

The reason is that the above binary has overlapping elf segments:
  LOAD           0x0000000000000000 0x0000000010000000 0x0000000010000000
                 0x0000000000013a8c 0x0000000000013a8c  R E    10000
  LOAD           0x000000000001fd40 0x000000001002fd40 0x000000001002fd40
                 0x00000000000002c0 0x00000000000005e8  RW     10000
  LOAD           0x0000000000020328 0x0000000010030328 0x0000000010030328
                 0x0000000000000384 0x00000000000094a0  RW     10000

That binary has two RW LOAD segments, the first crosses a page border into
the second

0x1002fd40 (LOAD2-vaddr) + 0x5e8 (LOAD2-memlen) == 0x10030328 (LOAD3-vaddr)

Handle this situation by enforcing MAP_FIXED when we establish a temporary
brk VMA to handle overlapping segments.  All other mappings will still use
MAP_FIXED_NOREPLACE.

Link: http://lkml.kernel.org/r/20180213100440.GM3443@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Andrei Vagin <avagin@openvz.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kees Cook <keescook@chromium.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~elf-enforce-map_fixed-on-overlaying-elf-segments fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-enforce-map_fixed-on-overlaying-elf-segments
+++ a/fs/binfmt_elf.c
@@ -895,7 +895,7 @@ static int load_elf_binary(struct linux_
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
-		int elf_prot = 0, elf_flags;
+		int elf_prot = 0, elf_flags, elf_fixed = MAP_FIXED_NOREPLACE;
 		unsigned long k, vaddr;
 		unsigned long total_size = 0;
 
@@ -927,6 +927,13 @@ static int load_elf_binary(struct linux_
 					 */
 				}
 			}
+
+			/*
+			 * Some binaries have overlapping elf segments and then
+			 * we have to forcefully map over an existing mapping
+			 * e.g. over this newly established brk mapping.
+			 */
+			elf_fixed = MAP_FIXED;
 		}
 
 		if (elf_ppnt->p_flags & PF_R)
@@ -944,7 +951,7 @@ static int load_elf_binary(struct linux_
 		 * the ET_DYN load_addr calculations, proceed normally.
 		 */
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
-			elf_flags |= MAP_FIXED_NOREPLACE;
+			elf_flags |= elf_fixed;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
 			/*
 			 * This logic is run once for the first LOAD Program
@@ -980,7 +987,7 @@ static int load_elf_binary(struct linux_
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
-				elf_flags |= MAP_FIXED_NOREPLACE;
+				elf_flags |= elf_fixed;
 			} else
 				load_bias = 0;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
elf-enforce-map_fixed-on-overlaying-elf-segments.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch

