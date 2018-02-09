From: akpm@linux-foundation.org
Subject: + mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch
 added to -mm tree
Date: Fri, 09 Feb 2018 13:03:57 -0800
Message-ID: <5a7e0cbd.5kwtRrYx/pqRZewH%akpm__30051.7517295249$1518210132$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbeBIVD7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 16:03:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, boris.ostrovsky@oracle.com, ddstreet@ieee.org, hannes@cmpxchg.org, jgross@suse.com, konrad.wilk@oracle.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, sergey.senozhatsky@gmail.com, shakeelb@google.com, shli@kernel.org, sjenning@redhat.com, stable@vger.kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap, frontswap: fix THP swap if frontswap enabled
has been added to the -mm tree.  Its filename is
     mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mm, swap, frontswap: fix THP swap if frontswap enabled

It was reported by Sergey Senozhatsky that if THP (Transparent Huge Page)
and frontswap (via zswap) are both enabled, when memory goes low so that
swap is triggered, segfault and memory corruption will occur in random
user space applications as follow,

kernel: urxvt[338]: segfault at 20 ip 00007fc08889ae0d sp 00007ffc73a7fc40 error 6 in libc-2.26.so[7fc08881a000+1ae000]
 #0  0x00007fc08889ae0d _int_malloc (libc.so.6)
 #1  0x00007fc08889c2f3 malloc (libc.so.6)
 #2  0x0000560e6004bff7 _Z14rxvt_wcstoutf8PKwi (urxvt)
 #3  0x0000560e6005e75c n/a (urxvt)
 #4  0x0000560e6007d9f1 _ZN16rxvt_perl_interp6invokeEP9rxvt_term9hook_typez (urxvt)
 #5  0x0000560e6003d988 _ZN9rxvt_term9cmd_parseEv (urxvt)
 #6  0x0000560e60042804 _ZN9rxvt_term6pty_cbERN2ev2ioEi (urxvt)
 #7  0x0000560e6005c10f _Z17ev_invoke_pendingv (urxvt)
 #8  0x0000560e6005cb55 ev_run (urxvt)
 #9  0x0000560e6003b9b9 main (urxvt)
 #10 0x00007fc08883af4a __libc_start_main (libc.so.6)
 #11 0x0000560e6003f9da _start (urxvt)

After bisection, it was found the first bad commit is bd4c82c22c367e068
("mm, THP, swap: delay splitting THP after swapped out").

The root cause is as follows:

When the pages are written to swap device during swapping out in
swap_writepage(), zswap (fontswap) is tried to compress the pages to
improve performance.  But zswap (frontswap) will treat THP as a normal
page, so only the head page is saved.  After swapping in, tail pages will
not be restored to their original contents, causing memory corruption in
the applications.

This is fixed by refusing to save page in the frontswap store functions if
the page is a THP.  So that the THP will be swapped out to swap device.

Another choice is to split THP if frontswap is enabled.  But it is found
that the frontswap enabling isn't flexible.  For example, if
CONFIG_ZSWAP=y (cannot be module), frontswap will be enabled even if zswap
itself isn't enabled.

Frontswap has multiple backends, to make it easy for one backend to enable
THP support, the THP checking is put in backend frontswap store functions
instead of the general interfaces.

Link: http://lkml.kernel.org/r/20180209084947.22749-1-ying.huang@intel.com
Fixes: bd4c82c22c367e068 ("mm, THP, swap: delay splitting THP after swapped out")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>	[put THP checking in backend]
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Shaohua Li <shli@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: <stable@vger.kernel.org>	[4.14]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/tmem.c |    4 ++++
 mm/zswap.c         |    6 ++++++
 2 files changed, 10 insertions(+)

diff -puN drivers/xen/tmem.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3 drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3
+++ a/drivers/xen/tmem.c
@@ -284,6 +284,10 @@ static int tmem_frontswap_store(unsigned
 	int pool = tmem_frontswap_poolid;
 	int ret;
 
+	/* THP isn't supported */
+	if (PageTransHuge(page))
+		return -1;
+
 	if (pool < 0)
 		return -1;
 	if (ind64 != ind)
diff -puN mm/zswap.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3 mm/zswap.c
--- a/mm/zswap.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3
+++ a/mm/zswap.c
@@ -1007,6 +1007,12 @@ static int zswap_frontswap_store(unsigne
 	u8 *src, *dst;
 	struct zswap_header zhdr = { .swpentry = swp_entry(type, offset) };
 
+	/* THP isn't supported */
+	if (PageTransHuge(page)) {
+		ret = -EINVAL;
+		goto reject;
+	}
+
 	if (!zswap_enabled || !tree) {
 		ret = -ENODEV;
 		goto reject;
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch

