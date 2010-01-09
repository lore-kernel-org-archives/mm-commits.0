From: akpm@linux-foundation.org
Subject: + acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:35:21 -0800
Message-ID: <201001090035.o090ZMDL023853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab0AIAhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:37:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, corbet@lwn.net, error27@gmail.com, eteo@redhat.com, lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com


The patch titled
     acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
has been added to the -mm tree.  Its filename is
     acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info.patch

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
Subject: acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Dan's list contains:

drivers/acpi/processor_throttling.c +1139 acpi_processor_get_throttling_info(11) warning: variable derefenced before check 'pr'

acpi_processor_get_throttling_info() is never called with pr == NULL.

[ bart: the potential NULL pointer dereference was finally fixed in
  (much later than mine) commit 5cfa245 but my patch is still valid ]

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info
+++ a/drivers/acpi/processor_throttling.c
@@ -1133,9 +1133,6 @@ int acpi_processor_get_throttling_info(s
 	int result = 0;
 	struct acpi_processor_throttling *pthrottling;
 
-	if (!pr)
-		return -EINVAL;
