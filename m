From: akpm@linux-foundation.org
Subject: + sh-off-by-one-bug_on-in-setup_bootmem_node.patch added to -mm
 tree
Date: Thu, 04 Dec 2014 15:50:33 -0800
Message-ID: <5480f349.PKGrE436Ic5Bqzio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaLDXue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Dec 2014 18:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, geert+renesas@glider.be, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: off by one BUG_ON() in setup_bootmem_node()
has been added to the -mm tree.  Its filename is
     sh-off-by-one-bug_on-in-setup_bootmem_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-off-by-one-bug_on-in-setup_bootmem_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-off-by-one-bug_on-in-setup_bootmem_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sh: off by one BUG_ON() in setup_bootmem_node()

This off by one bug is harmless but it upsets the static checkers and the
code is obvious so it doesn't hurt to fix it.  The Smatch warning is:

	arch/sh/mm/numa.c:47 setup_bootmem_node()
	error: buffer overflow 'node_data' 1024 <= 1024

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/numa.c~sh-off-by-one-bug_on-in-setup_bootmem_node arch/sh/mm/numa.c
--- a/arch/sh/mm/numa.c~sh-off-by-one-bug_on-in-setup_bootmem_node
+++ a/arch/sh/mm/numa.c
@@ -31,7 +31,7 @@ void __init setup_bootmem_node(int nid,
 	unsigned long bootmem_paddr;
 
 	/* Don't allow bogus node assignment */
-	BUG_ON(nid > MAX_NUMNODES || nid <= 0);
+	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
 
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

sh-off-by-one-bug_on-in-setup_bootmem_node.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch
ocfs2-remove-unneeded-null-check.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
checkpatch-add-strict-pointer-comparison-to-null-test.patch
checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines.patch
rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

