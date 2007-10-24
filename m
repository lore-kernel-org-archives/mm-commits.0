From: akpm@linux-foundation.org
Subject: + ipmi-fix-comparison-in-demangle_device_id.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:35:29 -0700
Message-ID: <200710240635.l9O6ZTrF026673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244AbXJXGgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, bunk@kernel.org, liste@jordet.net


The patch titled
     IPMI: fix comparison in demangle_device_id
has been added to the -mm tree.  Its filename is
     ipmi-fix-comparison-in-demangle_device_id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPMI: fix comparison in demangle_device_id
From: Corey Minyard <cminyard@mvista.com>

Coverity spotted some incorrect code in a recent change to the IPMI driver;
this patch make sure the data is really long enough to pull the
manufacturer id and product id out of a get device id message.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Stian Jordet <liste@jordet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipmi_smi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ipmi_smi.h~ipmi-fix-comparison-in-demangle_device_id include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-fix-comparison-in-demangle_device_id
+++ a/include/linux/ipmi_smi.h
@@ -173,7 +173,7 @@ static inline int ipmi_demangle_device_i
 	id->firmware_revision_2 = data[3];
 	id->ipmi_version = data[4];
 	id->additional_device_support = data[5];
-	if (data_len >= 6) {
+	if (data_len >= 11) {
 		id->manufacturer_id = (data[6] | (data[7] << 8) |
 				       (data[8] << 16));
 		id->product_id = data[9] | (data[10] << 8);
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch
ipmi-fix-comparison-in-demangle_device_id.patch
