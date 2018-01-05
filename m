From: akpm@linux-foundation.org
Subject: + build_bugh-remove-build_bug_on_null.patch added to -mm tree
Date: Fri, 05 Jan 2018 13:01:18 -0800
Message-ID: <5a4fe79e.XU3jnTrpGw8awNYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbeAEVBT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jan 2018 16:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, abbotti@mev.co.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, mm-commits@vger.kernel.org


The patch titled
     Subject: build_bug.h: remove BUILD_BUG_ON_NULL()
has been added to the -mm tree.  Its filename is
     build_bugh-remove-build_bug_on_null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/build_bugh-remove-build_bug_on_null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/build_bugh-remove-build_bug_on_null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: build_bug.h: remove BUILD_BUG_ON_NULL()

This macro is only used by net/ipv6/mcast.c, but there is no reason
why it must be BUILD_BUG_ON_NULL().

Replace it with BUILD_BUG_ON_ZERO(), and remove BUILD_BUG_ON_NULL()
definition from <linux/build_bug.h>.

Link: http://lkml.kernel.org/r/1515121833-3174-3-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |    2 --
 net/ipv6/mcast.c          |    8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN include/linux/build_bug.h~build_bugh-remove-build_bug_on_null include/linux/build_bug.h
--- a/include/linux/build_bug.h~build_bugh-remove-build_bug_on_null
+++ a/include/linux/build_bug.h
@@ -8,7 +8,6 @@
 #define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
-#define BUILD_BUG_ON_NULL(e) ((void *)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
 #define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
@@ -28,7 +27,6 @@
  * aren't permitted).
  */
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:(-!!(e)); }))
 
 /*
  * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
diff -puN net/ipv6/mcast.c~build_bugh-remove-build_bug_on_null net/ipv6/mcast.c
--- a/net/ipv6/mcast.c~build_bugh-remove-build_bug_on_null
+++ a/net/ipv6/mcast.c
@@ -65,10 +65,10 @@
 #include <net/ip6_checksum.h>
 
 /* Ensure that we have struct in6_addr aligned on 32bit word. */
-static void *__mld2_query_bugs[] __attribute__((__unused__)) = {
-	BUILD_BUG_ON_NULL(offsetof(struct mld2_query, mld2q_srcs) % 4),
-	BUILD_BUG_ON_NULL(offsetof(struct mld2_report, mld2r_grec) % 4),
-	BUILD_BUG_ON_NULL(offsetof(struct mld2_grec, grec_mca) % 4)
+static int __mld2_query_bugs[] __attribute__((__unused__)) = {
+	BUILD_BUG_ON_ZERO(offsetof(struct mld2_query, mld2q_srcs) % 4),
+	BUILD_BUG_ON_ZERO(offsetof(struct mld2_report, mld2r_grec) % 4),
+	BUILD_BUG_ON_ZERO(offsetof(struct mld2_grec, grec_mca) % 4)
 };
 
 static struct in6_addr mld2_all_mcr = MLD2_ALL_MCR_INIT;
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

genl_magic-remove-own-build_bug_on-defines.patch
build_bugh-remove-build_bug_on_null.patch

