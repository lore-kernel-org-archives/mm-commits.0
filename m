From: akpm@linux-foundation.org
Subject: + mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme.patch added to -mm tree
Date: Wed, 19 May 2010 12:05:02 -0700
Message-ID: <201005191905.o4JJ52Hm030311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab0ESTFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroberto@cpti.cetuc.puc-rio.br, anemo@mba.ocn.ne.jp, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, rmk@arm.linux.org.uk, sshtylyov@mvista.com, yinghai@kernel.org


The patch titled
     mm: fix NR_SECTION_ROOTS == 0 when using using sparsemem extreme.
has been added to the -mm tree.  Its filename is
     mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme.patch

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
Subject: mm: fix NR_SECTION_ROOTS == 0 when using using sparsemem extreme.
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

Got this while compiling for ARM/SA1100:

mm/sparse.c: In function '__section_nr':
mm/sparse.c:135: warning: 'root' is used uninitialized in this function

This patch follows Russell King's suggestion for a new calculation for
NR_SECTION_ROOTS.  Thanks also to Sergei Shtylyov for pointing out the
existence of the macro DIV_ROUND_UP.

Atsushi Nemoto observed:
: This fix doesn't just silence the warning - it fixes a real problem.
: 
: Without this fix, mem_section[] might have 0 size so mem_section[0]
: will share other variable area.  For example, I got:
: 
: c030c700 b __warned.16478
: c030c700 B mem_section
: c030c701 b __warned.16483
: 
: This might cause very strange behavior.  Your patch actually fixes it.


Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme
+++ a/include/linux/mmzone.h
@@ -981,7 +981,7 @@ struct mem_section {
 #endif
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
-#define NR_SECTION_ROOTS	(NR_MEM_SECTIONS / SECTIONS_PER_ROOT)
+#define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
 #define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
_

Patches currently in -mm which might be from mroberto@cpti.cetuc.puc-rio.br are

mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme.patch

