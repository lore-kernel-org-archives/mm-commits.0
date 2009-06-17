From: akpm@linux-foundation.org
Subject: [merged] readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:50 -0700
Message-ID: <200906171832.n5HIWoim031438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759842AbZFQSdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: enforce full readahead size on async mmap readahead
has been removed from the -mm tree.  Its filename was
     readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: enforce full readahead size on async mmap readahead
From: Wu Fengguang <fengguang.wu@intel.com>

We need this in one particular case and two more general ones.

Now we do async readahead for sequential mmap reads, and do it with the
help of PG_readahead.  For normal reads, PG_readahead is the sufficient
condition to do a sequential readahead.  But unfortunately, for mmap
reads, there is a tiny nuisance:

[11736.998347] readahead-init0(process: sh/23926, file: sda1/w3m, offset=0:4503599627370495, ra=0+4-3) = 4
[11737.014985] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=290+32-0) = 17
[11737.019488] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=118+32-0) = 32
[11737.024921] readahead-interleaved(process: w3m/23926, file: sda1/w3m, offset=0:2, ra=4+6-6) = 6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                                 ~~~~~~~~~~~~~

An unfavorably small readahead.  The original dumb read-around size could
be more efficient.

That happened because ld-linux.so does a read(832) in L1 before mmap(),
which triggers a 4-page readahead, with the second page tagged
PG_readahead.

L0: open("/lib/libc.so.6", O_RDONLY)        = 3
L1: read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\342"..., 832) = 832
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
L2: fstat(3, {st_mode=S_IFREG|0755, st_size=1420624, ...}) = 0
L3: mmap(NULL, 3527256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fac6e51d000
L4: mprotect(0x7fac6e671000, 2097152, PROT_NONE) = 0
L5: mmap(0x7fac6e871000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x154000) = 0x7fac6e871000
L6: mmap(0x7fac6e876000, 16984, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fac6e876000
L7: close(3)                                = 0

In general, the PG_readahead flag will also be hit in cases

- sequential reads

- clustered random reads

A full readahead size is desirable in both cases.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-enforce-full-readahead-size-on-async-mmap-readahead mm/filemap.c
--- a/mm/filemap.c~readahead-enforce-full-readahead-size-on-async-mmap-readahead
+++ a/mm/filemap.c
@@ -1516,7 +1516,8 @@ static void do_async_mmap_readahead(stru
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
 	if (PageReadahead(page))
-		page_cache_async_readahead(mapping, ra, file, page, offset, 1);
+		page_cache_async_readahead(mapping, ra, file,
+					   page, offset, ra->ra_pages);
 }
 
 /**
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

