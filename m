From: akpm@linux-foundation.org
Subject: + drivers-net-skfp-pmfc-use-offsetof-macro.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:18:35 -0700
Message-ID: <200808052118.m75LIZ36023951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758502AbYHEVUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, alan@redhat.com, jeff@garzik.org


The patch titled
     drivers/net/skfp/pmf.c: Use offsetof() macro
has been added to the -mm tree.  Its filename is
     drivers-net-skfp-pmfc-use-offsetof-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/skfp/pmf.c: Use offsetof() macro
From: Takashi Iwai <tiwai@suse.de>

Self-baked macros cause bunch of compile warnings like below:

  CC [M]  drivers/net/skfp/pmf.o
  CC      net/ipv4/fib_semantics.o
drivers/net/skfp/pmf.c:86: warning: cast from pointer to integer of different size
drivers/net/skfp/pmf.c:87: warning: cast from pointer to integer of different size
...

Use the standard offsetof() macro instead.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skfp/pmf.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/net/skfp/pmf.c~drivers-net-skfp-pmfc-use-offsetof-macro drivers/net/skfp/pmf.c
--- a/drivers/net/skfp/pmf.c~drivers-net-skfp-pmfc-use-offsetof-macro
+++ a/drivers/net/skfp/pmf.c
@@ -44,17 +44,10 @@ static SMbuf *smt_build_pmf_response(str
 				     int set, int local);
 static int port_to_mib(struct s_smc *smc, int p);
 
-#define MOFFSS(e)	((int)&(((struct fddi_mib *)0)->e))
-#define MOFFSA(e)	((int) (((struct fddi_mib *)0)->e))
-
-#define MOFFMS(e)	((int)&(((struct fddi_mib_m *)0)->e))
-#define MOFFMA(e)	((int) (((struct fddi_mib_m *)0)->e))
-
-#define MOFFAS(e)	((int)&(((struct fddi_mib_a *)0)->e))
-#define MOFFAA(e)	((int) (((struct fddi_mib_a *)0)->e))
-
-#define MOFFPS(e)	((int)&(((struct fddi_mib_p *)0)->e))
-#define MOFFPA(e)	((int) (((struct fddi_mib_p *)0)->e))
+#define MOFFSS(e)	offsetof(struct fddi_mib, e)
+#define MOFFMS(e)	offsetof(struct fddi_mib_m, e)
+#define MOFFAS(e)	offsetof(struct fddi_mib_a, e)
+#define MOFFPS(e)	offsetof(struct fddi_mib_p, e)
 
 
 #define AC_G	0x01		/* Get */
@@ -87,8 +80,8 @@ static const struct s_p_tab {
 	{ SMT_P100D,AC_G,	MOFFSS(fddiSMTOpVersionId),	"S"	} ,
 	{ SMT_P100E,AC_G,	MOFFSS(fddiSMTHiVersionId),	"S"	} ,
 	{ SMT_P100F,AC_G,	MOFFSS(fddiSMTLoVersionId),	"S"	} ,
-	{ SMT_P1010,AC_G,	MOFFSA(fddiSMTManufacturerData), "D" } ,
-	{ SMT_P1011,AC_GR,	MOFFSA(fddiSMTUserData),	"D"	} ,
+	{ SMT_P1010,AC_G,	MOFFSS(fddiSMTManufacturerData), "D" } ,
+	{ SMT_P1011,AC_GR,	MOFFSS(fddiSMTUserData),	"D"	} ,
 	{ SMT_P1012,AC_G,	MOFFSS(fddiSMTMIBVersionId),	"S"	} ,
 
 	/* StationConfigGrp */
@@ -103,7 +96,7 @@ static const struct s_p_tab {
 	{ SMT_P101D,AC_GR,	MOFFSS(fddiSMTTT_Notify),	"wS"	} ,
 	{ SMT_P101E,AC_GR,	MOFFSS(fddiSMTStatRptPolicy),	"bB"	} ,
 	{ SMT_P101F,AC_GR,	MOFFSS(fddiSMTTrace_MaxExpiration),"lL"	} ,
-	{ SMT_P1020,AC_G,	MOFFSA(fddiSMTPORTIndexes),	"II"	} ,
+	{ SMT_P1020,AC_G,	MOFFSS(fddiSMTPORTIndexes),	"II"	} ,
 	{ SMT_P1021,AC_G,	MOFFSS(fddiSMTMACIndexes),	"I"	} ,
 	{ SMT_P1022,AC_G,	MOFFSS(fddiSMTBypassPresent),	"F"	} ,
 
@@ -117,8 +110,8 @@ static const struct s_p_tab {
 
 	/* MIBOperationGrp */
 	{ SMT_P1032,AC_GROUP	} ,
-	{ SMT_P1033,AC_G,	MOFFSA(fddiSMTTimeStamp),"P"		} ,
-	{ SMT_P1034,AC_G,	MOFFSA(fddiSMTTransitionTimeStamp),"P"	} ,
+	{ SMT_P1033,AC_G,	MOFFSS(fddiSMTTimeStamp),"P"		} ,
+	{ SMT_P1034,AC_G,	MOFFSS(fddiSMTTransitionTimeStamp),"P"	} ,
 	/* NOTE : SMT_P1035 is already swapped ! SMT_P_SETCOUNT */
 	{ SMT_P1035,AC_G,	MOFFSS(fddiSMTSetCount),"4P"		} ,
 	{ SMT_P1036,AC_G,	MOFFSS(fddiSMTLastSetStationId),"8"	} ,
@@ -129,7 +122,7 @@ static const struct s_p_tab {
 	 * PRIVATE EXTENSIONS
 	 * only accessible locally to get/set passwd
 	 */
-	{ SMT_P10F0,AC_GR,	MOFFSA(fddiPRPMFPasswd),	"8"	} ,
+	{ SMT_P10F0,AC_GR,	MOFFSS(fddiPRPMFPasswd),	"8"	} ,
 	{ SMT_P10F1,AC_GR,	MOFFSS(fddiPRPMFStation),	"8"	} ,
 #ifdef	ESS
 	{ SMT_P10F2,AC_GR,	MOFFSS(fddiESSPayload),		"lL"	} ,
@@ -245,7 +238,7 @@ static const struct s_p_tab {
 	{ SMT_P400E,AC_GR,	MOFFPS(fddiPORTConnectionPolicies),"bB"	} ,
 	{ SMT_P400F,AC_G,	MOFFPS(fddiPORTMacIndicated),	"2"	} ,
 	{ SMT_P4010,AC_G,	MOFFPS(fddiPORTCurrentPath),	"E"	} ,
-	{ SMT_P4011,AC_GR,	MOFFPA(fddiPORTRequestedPaths),	"l4"	} ,
+	{ SMT_P4011,AC_GR,	MOFFPS(fddiPORTRequestedPaths),	"l4"	} ,
 	{ SMT_P4012,AC_G,	MOFFPS(fddiPORTMACPlacement),	"S"	} ,
 	{ SMT_P4013,AC_G,	MOFFPS(fddiPORTAvailablePaths),	"B"	} ,
 	{ SMT_P4016,AC_G,	MOFFPS(fddiPORTPMDClass),	"E"	} ,
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
drivers-net-skfp-pmfc-use-offsetof-macro.patch

