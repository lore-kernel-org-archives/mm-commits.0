From: akpm@linux-foundation.org
Subject: + fujitsu-laptop-autoload-module-on-lifebook-p1510d.patch added to -mm tree
Date: Mon, 02 Jun 2008 14:56:38 -0700
Message-ID: <200806022156.m52Lucnt001923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416AbYFBV5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 17:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcbw@redhat.com, greg@kroah.com, jwoithe@physics.adelaide.edu.au, len.brown@intel.com


The patch titled
     fujitsu-laptop: autoload module on Lifebook P1510D
has been added to the -mm tree.  Its filename is
     fujitsu-laptop-autoload-module-on-lifebook-p1510d.patch

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
Subject: fujitsu-laptop: autoload module on Lifebook P1510D
From: Dan Williams <dcbw@redhat.com>

Signed-off-by: Dan Williams <dcbw@redhat.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fujitsu-laptop.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/misc/fujitsu-laptop.c~fujitsu-laptop-autoload-module-on-lifebook-p1510d drivers/misc/fujitsu-laptop.c
--- a/drivers/misc/fujitsu-laptop.c~fujitsu-laptop-autoload-module-on-lifebook-p1510d
+++ a/drivers/misc/fujitsu-laptop.c
@@ -352,3 +352,9 @@ MODULE_AUTHOR("Jonathan Woithe");
 MODULE_DESCRIPTION("Fujitsu laptop extras support");
 MODULE_VERSION(FUJITSU_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
+
+static struct pnp_device_id pnp_ids[] = {
+	{ .id = "FUJ02bf" },
+	{ .id = "" }
+};
+MODULE_DEVICE_TABLE(pnp, pnp_ids);
_

Patches currently in -mm which might be from dcbw@redhat.com are

origin.patch
fujitsu-laptop-autoload-module-on-lifebook-p1510d.patch
linux-next.patch

