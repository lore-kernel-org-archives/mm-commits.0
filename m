From: akpm@linux-foundation.org
Subject: + readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:24 -0700
Message-ID: <200904102339.n3ANdOjI021319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbZDJXmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     readahead: enforce full readahead size on async mmap readahead
has been added to the -mm tree.  Its filename is
     readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch

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
@@ -1515,7 +1515,8 @@ static void do_async_mmap_readahead(stru
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

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch

