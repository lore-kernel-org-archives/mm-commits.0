From: akpm@linux-foundation.org
Subject: [merged] pnpacpi-fix-incorrect-test_alpha-test.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:56:47 -0800
Message-ID: <20121212195647.D8C0882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:47233 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2LLUCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:02:43 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so117024vba.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:02:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, andi@lisas.de, bhelgaas@google.com, bp@alien8.de, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pnpacpi: fix incorrect TEST_ALPHA() test
has been removed from the -mm tree.  Its filename was
     pnpacpi-fix-incorrect-test_alpha-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

