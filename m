From: akpm@linux-foundation.org
Subject: [patch 055/114] elf: fix NT_FILE integer overflow
Date: Tue, 06 Feb 2018 15:39:13 -0800
Message-ID: <20180206233913.NBjj1FTu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -1599,6 +1599,8 @@ static int fill_files_note(struct memelf
 
 	/* *Estimated* file count and total data size needed */
 	count = current->mm->map_count;
+	if (count > UINT_MAX / 64)
+		return -EINVAL;
 	size = count * 64;
 
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
_
