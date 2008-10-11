From: akpm@linux-foundation.org
Subject: + edac-i5000-fix-thermal-issues.patch added to -mm tree
Date: Fri, 10 Oct 2008 19:43:55 -0700
Message-ID: <200810110243.m9B2htu5002094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYJKCof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 22:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com


The patch titled
     edac i5000: fix thermal issues
has been added to the -mm tree.  Its filename is
     edac-i5000-fix-thermal-issues.patch

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
Subject: edac i5000: fix thermal issues
From: Aristeu Rozanski <aris@redhat.com>

Make the Thermal messages (temperature got past Tmid) be displayed only
once because:

1) it's the BIOS job to configure and handle the memory throttling
2) if the BIOS is broken or is aware about the condition, flooding the
   system logs won't help anything.
3) According to the specification update for Intel 5000 MCHs, all the
   revisions of this MCH have problems on the thermal sensors, making
   not automatic (a.k.a. intelligent thermal throttling) impossible.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~edac-i5000-fix-thermal-issues drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~edac-i5000-fix-thermal-issues
+++ a/drivers/edac/i5000_edac.c
@@ -511,8 +511,23 @@ static void i5000_process_fatal_error_in
 				"retry";
 		break;
 	case FERR_FAT_M3ERR:
+		{
+		static int done;
+
+		/*
+		 * This error is generated to inform that the intelligent
+		 * throttling is disabled and the temperature passed the
+		 * specified middle point. Since this is something the BIOS
+		 * should take care of, we'll warn only once to avoid
+		 * worthlessly flooding the log.
+		 */
+		if (done)
+			return;
+		done++;
+
 		specific = ">Tmid Thermal event with intelligent "
-				"throttling disabled";
+			   "throttling disabled";
+		}
 		break;
 	}
 
_

Patches currently in -mm which might be from aris@redhat.com are

git-tip.patch
git-security-testing.patch
edac-i5000-fix-error-messages.patch
edac-i5000-fix-thermal-issues.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch

