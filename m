From: akpm@linux-foundation.org
Subject: + clk-validate-pointer-in-__clk_disable.patch added to -mm tree
Date: Fri, 08 Jun 2012 16:43:10 -0700
Message-ID: <20120608234310.A1709A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44094 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761653Ab2FHXnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 19:43:13 -0400
Received: by lbbgp10 with SMTP id gp10so137697lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 16:43:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, paul.gortmaker@windriver.com, rmk@arm.linux.org.uk, viresh.kumar@st.com, viresh.linux@gmail.com


The patch titled
     Subject: clk: validate pointer in __clk_disable()
has been added to the -mm tree.  Its filename is
     clk-validate-pointer-in-__clk_disable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: clk: validate pointer in __clk_disable()

clk_get() returns -ENOENT on error and some careless caller might
dereference it without error checking:

In mxc_rnga_remove():

        struct clk *clk = clk_get(&pdev->dev, "rng");

	// ...

        clk_disable(clk);

Since it's insane to audit the lots of existing and future clk users,
let's add a check in the callee to avoid kernel panic and warn about
any buggy user.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/clk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/clk/clk.c~clk-validate-pointer-in-__clk_disable drivers/clk/clk.c
--- a/drivers/clk/clk.c~clk-validate-pointer-in-__clk_disable
+++ a/drivers/clk/clk.c
@@ -464,6 +464,9 @@ static void __clk_disable(struct clk *cl
 	if (!clk)
 		return;
 
+	if (WARN_ON(IS_ERR(clk)))
+		return;
+
 	if (WARN_ON(clk->enable_count == 0))
 		return;
 
_
Subject: Subject: clk: validate pointer in __clk_disable()

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
clk-validate-pointer-in-__clk_disable.patch

