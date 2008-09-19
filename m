From: akpm@linux-foundation.org
Subject: + cdrom-update-ioctl-documentation.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:40:47 -0700
Message-ID: <200809192240.m8JMelbX010169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496AbYISWk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nm127@freemail.hu, bzolnier@gmail.com


The patch titled
     cdrom: update ioctl documentation
has been added to the -mm tree.  Its filename is
     cdrom-update-ioctl-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: cdrom: update ioctl documentation
=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

Correct copy-paste problem: CDROMCLOSETRAY is about closing the tray,
not opening it.

Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/cdrom.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/ioctl/cdrom.txt~cdrom-update-ioctl-documentatio=
n Documentation/ioctl/cdrom.txt
--- a/Documentation/ioctl/cdrom.txt~cdrom-update-ioctl-documentation
+++ a/Documentation/ioctl/cdrom.txt
@@ -271,14 +271,14 @@ CDROMCLOSETRAY			pendant of CDROMEJECT
=20
 	usage:
=20
-	  ioctl(fd, CDROMEJECT, 0);
+	  ioctl(fd, CDROMCLOSETRAY, 0);
=20
 	inputs:		none
=20
 	outputs:	none
=20
 	error returns:
-	  ENOSYS	cd drive not capable of ejecting
+	  ENOSYS	cd drive not capable of closing the tray
 	  EBUSY		other processes are accessing drive, or door is locked
=20
 	notes:
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from nm127@freemail.hu are

cdrom-update-ioctl-documentation.patch
smc-ultra-get-rid-of-eth%d-message.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
