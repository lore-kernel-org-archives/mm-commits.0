From: akpm@linux-foundation.org
Subject: + jffs2-fix-memory-corruption-in-jffs2_read_inode_range.patch added to -mm tree
Date: Fri, 20 Nov 2009 16:42:34 -0800
Message-ID: <200911210042.nAL0gYsV017331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZKUAmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 19:42:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dwmw2@infradead.org, neilb@suse.de


The patch titled
     jffs2: fix memory corruption in jffs2_read_inode_range()
has been added to the -mm tree.  Its filename is
     jffs2-fix-memory-corruption-in-jffs2_read_inode_range.patch

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
Subject: jffs2: fix memory corruption in jffs2_read_inode_range()
From: Anton Vorontsov <avorontsov@ru.mvista.com>

In 2.6.23 kernel, commit a32ea1e1f925399e0d81ca3f7394a44a6dafa12c ("Fix
read/truncate race") fixed a race in the generic code, and as a side
effect, now do_generic_file_read() can ask us to readpage() past the
i_size, which seems to be correctly handled by the block routines (e.g. 
block_read_full_page() fills the page with zeroes in case if somebody is
trying to read past the last inode's block).

JFFS2 doesn't handle this, instead jffs2_read_inode_range() is trying to
lookup the fragments which do not belong to anything, and
jffs2_lookup_node_frag() happily returns "the closest smaller match" which
is OK for most cases (I guess), but in our case there wasn't anything
meaningful to lookup in the first place.

After we found the bogus fragment, the code can branch to 'Filling frag
hole' case that does

  memset(buf, 0, min(end, frag->ofs + frag->size) - offset);

and since 'frag' is bogus, its ofs + size can be smaller than the real
'offset' (i.e.  index << PAGE_CACHE_SHIFT), and so the code turns into

  memset(buf, 0, <huge unsigned negative>);

Hopefully, in most cases the corruption is fatal, and quickly causing
random oopses, like this:

  root@10.0.0.4:~/ltp-fs-20090531# ./testcases/kernel/fs/ftest/ftest01
  Unable to handle kernel paging request for data at address 0x00000008
  Faulting instruction address: 0xc01cd980
  Oops: Kernel access of bad area, sig: 11 [#1]
  [...]
  NIP [c01cd980] rb_insert_color+0x38/0x184
  LR [c0043978] enqueue_hrtimer+0x88/0xc4
  Call Trace:
  [c6c63b60] [c004f9a8] tick_sched_timer+0xa0/0xe4 (unreliable)
  [c6c63b80] [c0043978] enqueue_hrtimer+0x88/0xc4
  [c6c63b90] [c0043a48] __run_hrtimer+0x94/0xbc
  [c6c63bb0] [c0044628] hrtimer_interrupt+0x140/0x2b8
  [c6c63c10] [c000f8e8] timer_interrupt+0x13c/0x254
  [c6c63c30] [c001352c] ret_from_except+0x0/0x14
  --- Exception: 901 at memset+0x38/0x5c
      LR = jffs2_read_inode_range+0x144/0x17c
  [c6c63cf0] [00000000] (null) (unreliable)

This patch fixes the issue, plus fixes all LTP tests on NAND/UBI with
JFFS2 filesystem that were failing since 2.6.23 (seems like the bug above
also broke the truncation).

Note that the bug is only reproducible with write-buffered MTD devices
(e.g.  NAND, UBI), which is a mystery to me (though I didn't look close
enough, possibly there is a race between gc and wbuf code, but I don't see
it and obviously it isn't that fatal).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/jffs2/file.c~jffs2-fix-memory-corruption-in-jffs2_read_inode_range fs/jffs2/file.c
--- a/fs/jffs2/file.c~jffs2-fix-memory-corruption-in-jffs2_read_inode_range
+++ a/fs/jffs2/file.c
@@ -85,7 +85,13 @@ static int jffs2_do_readpage_nolock (str
 	pg_buf = kmap(pg);
 	/* FIXME: Can kmap fail? */
 
-	ret = jffs2_read_inode_range(c, f, pg_buf, pg->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
+	if (pg->index > ((i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT)) {
+		ret = 0;
+		memset(pg_buf, 0, PAGE_CACHE_SIZE);
+	} else {
+		ret = jffs2_read_inode_range(c, f, pg_buf,
+			pg->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
+	}
 
 	if (ret) {
 		ClearPageUptodate(pg);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
jffs2-fix-memory-corruption-in-jffs2_read_inode_range.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch

