From: akpm@linux-foundation.org
Subject: + mm-mmapc-use-while-instead-of-ifgoto.patch added to -mm tree
Date: Mon, 30 Mar 2015 14:58:31 -0700
Message-ID: <5519c707.IlK0MYBQz7tDJbur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbC3V6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 17:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gorcunov@openvz.org, hughd@google.com, kirill.shutemov@linux.intel.com, klamm@yandex-team.ru, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use while instead of if+goto
has been added to the -mm tree.  Its filename is
     mm-mmapc-use-while-instead-of-ifgoto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-use-while-instead-of-ifgoto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-use-while-instead-of-ifgoto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/mmap.c: use while instead of if+goto

The creators of the C language gave us the while keyword. Let's use
that instead of synthesizing it from if+goto.

Made possible by 6597d783397a ("mm/mmap.c: replace find_vma_prepare()
with clearer find_vma_links()").

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto
+++ a/mm/mmap.c
@@ -1551,11 +1551,9 @@ unsigned long mmap_region(struct file *f
 
 	/* Clear old maps */
 	error = -ENOMEM;
-munmap_back:
-	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
-		goto munmap_back;
 	}
 
 	/*
@@ -2739,11 +2737,9 @@ static unsigned long do_brk(unsigned lon
 	/*
 	 * Clear old maps.  this also does some error checking for us
 	 */
- munmap_back:
-	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
-		goto munmap_back;
 	}
 
 	/* Check against address space limits *after* clearing old maps... */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
linux-next.patch

