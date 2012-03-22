From: akpm@linux-foundation.org
Subject: + drivers-staging-telephony-ixjc-fix-warning-about-sequence-points.patch added to -mm tree
Date: Thu, 22 Mar 2012 16:03:42 -0700
Message-ID: <20120322230342.D96F6A020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59452 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2CVXDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 19:03:45 -0400
Received: by bkcjm19 with SMTP id jm19so138656bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 16:03:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uwe@kleine-koenig.org, greg@kroah.com, lucas.demarchi@profusion.mobi


The patch titled
     Subject: drivers/staging/telephony/ixj.c: fix warning about sequen=
ce points
has been added to the -mm tree.  Its filename is
     drivers-staging-telephony-ixjc-fix-warning-about-sequence-points.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Subject: drivers/staging/telephony/ixj.c: fix warning about sequence po=
ints

In the statement

	j->caplist[j->caps].handle =3D j->caps++;

there is no sequence point between the usage of j->caps on the LHS of t=
he
assignment and the incrementation on its RHS.  So it's not defined in
Standard C if j->caps is already incremented when used on the LHS even
though the postfix ++ operator is used.  To properly fix that the
incrementation has to be done in a separate expression.

This fixes:
	drivers/telephony/ixj.c: In function `add_caps':
	drivers/telephony/ixj.c:5930:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5950:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5954:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5965:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5976:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5988:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5998:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6003:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6008:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6013:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6019:38: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6026:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6031:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6036:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6041:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6049:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6057:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6065:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6071:39: warning: operation on `j->caps' may b=
e undefined [-Wsequence-point]

Signed-off-by: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/telephony/ixj.c |   57 ++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff -puN drivers/staging/telephony/ixj.c~drivers-staging-telephony-ixj=
c-fix-warning-about-sequence-points drivers/staging/telephony/ixj.c
--- a/drivers/staging/telephony/ixj.c~drivers-staging-telephony-ixjc-fi=
x-warning-about-sequence-points
+++ a/drivers/staging/telephony/ixj.c
@@ -5927,7 +5927,8 @@ static void add_caps(IXJ *j)
 	j->caplist[j->caps].cap =3D PHONE_VENDOR_QUICKNET;
 	strcpy(j->caplist[j->caps].desc, "Quicknet Technologies, Inc. (www.qu=
icknet.net)");
 	j->caplist[j->caps].captype =3D vendor;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
 	j->caplist[j->caps].captype =3D device;
 	switch (j->cardtype) {
 	case QTI_PHONEJACK:
@@ -5947,11 +5948,13 @@ static void add_caps(IXJ *j)
 		break;
 	}
 	j->caplist[j->caps].cap =3D j->cardtype;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
 	strcpy(j->caplist[j->caps].desc, "POTS");
 	j->caplist[j->caps].captype =3D port;
 	j->caplist[j->caps].cap =3D pots;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
  	/* add devices that can do speaker/mic */
 	switch (j->cardtype) {
@@ -5962,7 +5965,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "SPEAKER");
 		j->caplist[j->caps].captype =3D port;
 		j->caplist[j->caps].cap =3D speaker;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
         default:
      		break;
 	}
@@ -5973,7 +5977,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "HANDSET");
 		j->caplist[j->caps].captype =3D port;
 		j->caplist[j->caps].cap =3D handset;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5985,7 +5990,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "PSTN");
 		j->caplist[j->caps].captype =3D port;
 		j->caplist[j->caps].cap =3D pstn;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5995,50 +6001,59 @@ static void add_caps(IXJ *j)
 	strcpy(j->caplist[j->caps].desc, "ULAW");
 	j->caplist[j->caps].captype =3D codec;
 	j->caplist[j->caps].cap =3D ULAW;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
 	strcpy(j->caplist[j->caps].desc, "LINEAR 16 bit");
 	j->caplist[j->caps].captype =3D codec;
 	j->caplist[j->caps].cap =3D LINEAR16;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
 	strcpy(j->caplist[j->caps].desc, "LINEAR 8 bit");
 	j->caplist[j->caps].captype =3D codec;
 	j->caplist[j->caps].cap =3D LINEAR8;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
 	strcpy(j->caplist[j->caps].desc, "Windows Sound System");
 	j->caplist[j->caps].captype =3D codec;
 	j->caplist[j->caps].cap =3D WSS;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
 	/* software ALAW codec, made from ULAW */
 	strcpy(j->caplist[j->caps].desc, "ALAW");
 	j->caplist[j->caps].captype =3D codec;
 	j->caplist[j->caps].cap =3D ALAW;
-	j->caplist[j->caps].handle =3D j->caps++;
+	j->caplist[j->caps].handle =3D j->caps;
+	j->caps++;
=20
 	/* version 12 of the 8020 does the following codecs in a broken way *=
/
 	if (j->dsp.low !=3D 0x20 || j->ver.low !=3D 0x12) {
 		strcpy(j->caplist[j->caps].desc, "G.723.1 6.3kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D G723_63;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
=20
 		strcpy(j->caplist[j->caps].desc, "G.723.1 5.3kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D G723_53;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
=20
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.8kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D TS48;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
=20
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.1kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D TS41;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 	}
=20
 	/* 8020 chips can do TS8.5 native, and 8021/8022 can load it */
@@ -6046,7 +6061,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 8.5kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D TS85;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 	}
=20
 	/* 8021 chips can do G728 */
@@ -6054,7 +6070,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.728 16kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D G728;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 	}
=20
 	/* 8021/8022 chips can do G729 if loaded */
@@ -6062,13 +6079,15 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.729A 8kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D G729;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 	}
 	if (j->dsp.low !=3D 0x20 && j->flags.g729_loaded) {
 		strcpy(j->caplist[j->caps].desc, "G.729B 8kbps");
 		j->caplist[j->caps].captype =3D codec;
 		j->caplist[j->caps].cap =3D G729B;
-		j->caplist[j->caps].handle =3D j->caps++;
+		j->caplist[j->caps].handle =3D j->caps;
+		j->caps++;
 	}
 }
=20
_
Subject: Subject: drivers/staging/telephony/ixj.c: fix warning about se=
quence points

Patches currently in -mm which might be from uwe@kleine-koenig.org are

drivers-staging-telephony-ixjc-fix-warning-about-sequence-points.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
