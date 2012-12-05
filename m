From: akpm@linux-foundation.org
Subject: + pnpacpi-fix-incorrect-test_alpha-test.patch added to -mm tree
Date: Wed, 05 Dec 2012 13:39:02 -0800
Message-ID: <20121205213903.990A3820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56446 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEVjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2012 16:39:09 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so675864ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Dec 2012 13:39:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, andi@lisas.de, bhelgaas@google.com, bp@alien8.de, shaohua.li@intel.com


The patch titled
     Subject: pnpacpi: fix incorrect TEST_ALPHA() test
has been added to the -mm tree.  Its filename is
     pnpacpi-fix-incorrect-test_alpha-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: pnpacpi: fix incorrect TEST_ALPHA() test

TEST_ALPHA() is broken and always returns 0.

[akpm@linux-foundation.org: return false for '@' as well, per Bjorn]
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/pnpacpi/core.c~pnpacpi-fix-incorrect-test_alpha-test drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnpacpi-fix-incorrect-test_alpha-test
+++ a/drivers/pnp/pnpacpi/core.c
@@ -58,7 +58,7 @@ static inline int __init is_exclusive_de
 	if (!(('0' <= (c) && (c) <= '9') || ('A' <= (c) && (c) <= 'F'))) \
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <= (c) || (c) <= 'Z')) \
+	if (!('A' <= (c) && (c) <= 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
pnpacpi-fix-incorrect-test_alpha-test.patch

