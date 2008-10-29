From: akpm@linux-foundation.org
Subject: + ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si.patch added to -mm tree
Date: Tue, 28 Oct 2008 17:31:35 -0700
Message-ID: <200810290031.m9T0VZMo006854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbYJ2Abz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 20:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scott@canonical.com, minyard@acm.org, scott@ubuntu.com, stable@kernel.org, tcanonical@tpi.com


The patch titled
     ipmi: add MODULE_ALIAS to load ipmi_devintf with ipmi_si
has been added to the -mm tree.  Its filename is
     ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si.patch

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
Subject: ipmi: add MODULE_ALIAS to load ipmi_devintf with ipmi_si
From: Scott James Remnant <scott@canonical.com>

The ipmi_devintf module contains the userspace interface for IPMI devices,
yet will not be loaded automatically with a system interface handler
driver.

Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by the
ipmi_si driver, so that userspace knows of the recommendation.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Cc: Tim Gardner <tcanonical@tpi.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: <stable@kernel.org>		[2.6.27.x, maybe earlier?]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_devintf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/ipmi/ipmi_devintf.c~ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si drivers/char/ipmi/ipmi_devintf.c
--- a/drivers/char/ipmi/ipmi_devintf.c~ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si
+++ a/drivers/char/ipmi/ipmi_devintf.c
@@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
 MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
+MODULE_ALIAS("platform:ipmi_si");
_

Patches currently in -mm which might be from scott@canonical.com are

ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si.patch

