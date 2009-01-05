From: akpm@linux-foundation.org
Subject: - i8k-add-support-for-dell-precisions.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:43 -0800
Message-ID: <200901050641.n056fhFi005693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbZAEGmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spenceal@rose-hulman.edu, andrew@ishiboo.com, dtor@mail.ru, dz@debian.org, mm-commits@vger.kernel.org


The patch titled
     i8k: add support for Dell Precisions
has been removed from the -mm tree.  Its filename was
     i8k-add-support-for-dell-precisions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8k: add support for Dell Precisions
From: Andy Spencer <spenceal@rose-hulman.edu>

Make i8k work on Dell Precisions.  I have been using this on my Dell
Precision M70 for a while and haven't noticed any problems.

Reported-by: Andrew Paprocki <andrew@ishiboo.com>
Cc: Massimo Dal Zotto <dz@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~i8k-add-support-for-dell-precisions drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-add-support-for-dell-precisions
+++ a/drivers/char/i8k.c
@@ -492,6 +492,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
+	{
+		.ident = "Dell Precision",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from spenceal@rose-hulman.edu are

origin.patch

