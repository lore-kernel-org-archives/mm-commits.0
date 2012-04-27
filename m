From: akpm@linux-foundation.org
Subject: [merged] acerhdf-lowered-default-temp-fanon-fanoff-values.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:20 -0700
Message-ID: <20120427193520.7842BA02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41549 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761331Ab2D0TfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:22 -0400
Received: by bkwj5 with SMTP id j5so54044bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@piie.net, mjg@redhat.com, petkovbb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acerhdf: lowered default temp fanon/fanoff values
has been removed from the -mm tree.  Its filename was
     acerhdf-lowered-default-temp-fanon-fanoff-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Peter Feuerer <peter@piie.net>
Subject: acerhdf: lowered default temp fanon/fanoff values

Due to new supported hardware, of which the actual temperature limits of
processor, harddisk and other components are unknown, it feels safer with
lower fanon / fanoff settings.

It won't change much for most people, already using acerhdf, as they use
their own fanon/fanoff variable settings when loading the module.

Furthermore seems like kernel and userspace tools have been improved to
work more efficient and netbooks don't get so hot anymore.

Signed-off-by: Peter Feuerer <peter@piie.net>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-lowered-default-temp-fanon-fanoff-values drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-lowered-default-temp-fanon-fanoff-values
+++ a/drivers/platform/x86/acerhdf.c
@@ -83,8 +83,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 63000;
-static unsigned int fanoff = 58000;
+static unsigned int fanon = 60000;
+static unsigned int fanoff = 53000;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
_

Patches currently in -mm which might be from peter@piie.net are

origin.patch

