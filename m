From: akpm@linux-foundation.org
Subject: [merged] checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:18 -0700
Message-ID: <20120326193018.62FDCA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52960 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2CZTaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:20 -0400
Received: by faaa19 with SMTP id a19so298455faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, marek.vasut@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: catch [ ... ] usage when not at the beginning of definition
has been removed from the -mm tree.  Its filename was
     checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: catch [ ... ] usage when not at the beginning of definition

Handle the [ A ... B ] form deeper into a definition, for example:

    static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
	    {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
	    {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
    };

Reported-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-catch-usage-when-not-at-the-beginning-of-defination scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-catch-usage-when-not-at-the-beginning-of-defination
+++ a/scripts/checkpatch.pl
@@ -2391,7 +2391,7 @@ sub process {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
-			    $prefix !~ /{\s+$/) {
+			    $prefix !~ /[{,]\s+$/) {
 				ERROR("BRACKET_SPACE",
 				      "space prohibited before open square bracket '['\n" . $herecurr);
 			}
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

