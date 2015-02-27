From: akpm@linux-foundation.org
Subject: + lib-vsprintf-move-integer-format-types-to-the-top.patch added
 to -mm tree
Date: Fri, 27 Feb 2015 14:19:01 -0800
Message-ID: <54f0ed55.AZ4s1b1KzJBK5wy6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbbB0WTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 17:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, corbet@lwn.net, mturquette@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: Move integer format types to the top
has been added to the -mm tree.  Its filename is
     lib-vsprintf-move-integer-format-types-to-the-top.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-move-integer-format-types-to-the-top.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-move-integer-format-types-to-the-top.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/vsprintf: Move integer format types to the top

Move the format types for 64-bit integers and configurable size integers
to the top, so they're next to the other integer format types.  While at
it, add the missing format types for s32 and u32.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   32 +++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-move-integer-format-types-to-the-top Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-move-integer-format-types-to-the-top
+++ a/Documentation/printk-formats.txt
@@ -8,6 +8,21 @@ If variable is of Type,		use printk form
 		unsigned long long	%llu or %llx
 		size_t			%zu or %zx
 		ssize_t			%zd or %zx
+		s32			%d or %x
+		u32			%u or %x
+		s64			%lld or %llx
+		u64			%llu or %llx
+
+If <type> is dependent on a config option for its size (e.g., sector_t,
+blkcnt_t) or is architecture-dependent for its size (e.g., tcflag_t), use a
+format specifier of its largest possible type and explicitly cast to it.
+Example:
+
+	printk("test: sector number/total blocks: %llu/%llu\n",
+		(unsigned long long)sector, (unsigned long long)blockcount);
+
+Reminder: sizeof() result is of type size_t.
+
 
 Raw pointer value SHOULD be printed with %p. The kernel supports
 the following extended format specifiers for pointer types:
@@ -246,23 +261,6 @@ struct va_format:
 
 	Passed by reference.
 
-u64 SHOULD be printed with %llu/%llx:
-
-	printk("%llu", u64_var);
-
-s64 SHOULD be printed with %lld/%llx:
-
-	printk("%lld", s64_var);
-
-If <type> is dependent on a config option for its size (e.g., sector_t,
-blkcnt_t) or is architecture-dependent for its size (e.g., tcflag_t), use a
-format specifier of its largest possible type and explicitly cast to it.
-Example:
-
-	printk("test: sector number/total blocks: %llu/%llu\n",
-		(unsigned long long)sector, (unsigned long long)blockcount);
