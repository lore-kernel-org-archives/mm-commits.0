From: akpm@linux-foundation.org
Subject: + swsusp-dont-copy-pages-that-arent-ram.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:56:17 -0800
Message-ID: <200702052256.l15MuHQ1001822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbXBEW4j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     swsusp: don't copy pages that arent RAM
has been added to the -mm tree.  Its filename is
     swsusp-dont-copy-pages-that-arent-ram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: don't copy pages that arent RAM
From: Johannes Berg <johannes@sipsolutions.net>

Pages that aren't RAM obviously cannot be saved during suspend-to-disk so
skip them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/power/snapshot.c~swsusp-dont-copy-pages-that-arent-ram kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-dont-copy-pages-that-arent-ram
+++ a/kernel/power/snapshot.c
@@ -686,6 +686,8 @@ static struct page *saveable_page(unsign
 
 	if (PageReserved(page) && pfn_is_nosave(pfn))
 		return NULL;
+	if (!page_is_ram(pfn))
+		return NULL;
 
 	return page;
 }
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
windfarm-dont-die-on-suspend-thread-signal.patch
swsusp-dont-copy-pages-that-arent-ram.patch
