From: akpm@linux-foundation.org
Subject: + elf-fix-nt_file-integer-overflow.patch added to -mm tree
Date: Fri, 12 Jan 2018 14:52:20 -0800
Message-ID: <5a593c24.vv5YlKR/vintUSYH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965257AbeALWwV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 17:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: elf: fix NT_FILE integer overflow
has been added to the -mm tree.  Its filename is
     elf-fix-nt_file-integer-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/elf-fix-nt_file-integer-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/elf-fix-nt_file-integer-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: elf: fix NT_FILE integer overflow

If vm.max_map_count bumped above 2^26 (67+ mil) and system has enough RAM
to allocate all the VMAs (~12.8 GB on Fedora 27 with 200-byte VMAs), then
it should be possible to overflow 32-bit "size", pass paranoia check,
allocate very little vmalloc space and oops while writing into vmalloc
guard page...

But I didn't test this, only coredump of regular process.

Link: http://lkml.kernel.org/r/20180112203427.GA9109@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/binfmt_elf.c~elf-fix-nt_file-integer-overflow fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-fix-nt_file-integer-overflow
+++ a/fs/binfmt_elf.c
@@ -1604,6 +1604,8 @@ static int fill_files_note(struct memelf
 
 	/* *Estimated* file count and total data size needed */
 	count = current->mm->map_count;
+	if (count > UINT_MAX / 64)
+		return -EINVAL;
 	size = count * 64;
 
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
proc-delete-children_seq_release.patch
proc-rearrange-struct-proc_dir_entry.patch
proc-fixup-comment.patch
proc-spread-__ro_after_init.patch
proc-spread-likely-unlikely-a-bit.patch
proc-rearrange-args.patch
uuid-cleanup-uapi-linux-uuidh.patch
elf-fix-nt_file-integer-overflow.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_size-return-unsigned-int.patch

