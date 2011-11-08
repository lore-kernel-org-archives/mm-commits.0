From: akpm@linux-foundation.org
Subject: + acerhdf-lowered-default-temp-fanon-fanoff-values.patch added to -mm tree
Date: Tue, 08 Nov 2011 15:05:50 -0800
Message-ID: <201111082305.pA8N5pMR015114@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1KHXF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 18:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, mjg@redhat.com, petkovbb@gmail.com


The patch titled
     Subject: acerhdf: lowered default temp fanon/fanoff values
has been added to the -mm tree.  Its filename is
     acerhdf-lowered-default-temp-fanon-fanoff-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: acerhdf: lowered default temp fanon/fanoff values

Patches currently in -mm which might be from peter@piie.net are

acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch

