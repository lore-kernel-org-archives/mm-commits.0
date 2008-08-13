From: akpm@linux-foundation.org
Subject: + ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch added to -mm tree
Date: Wed, 13 Aug 2008 15:51:44 -0700
Message-ID: <200808132251.m7DMpius010740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYHMWwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 18:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     ibmaem: prevent infinite probing loop on x3650 M2 systems
has been added to the -mm tree.  Its filename is
     ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch

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
Subject: ibmaem: prevent infinite probing loop on x3650 M2 systems
From: "Darrick J. Wong" <djwong@us.ibm.com>

On older machines, probing for a nonexistent AEM interface returned an
IPMI error; when we saw this, we'd stop probing.  On the x3650 M2 and
(presumably) later, we are returned a value indicating success and a
buffer full of garbage or zeroes.  This causes the probe function to run
in an infinite loop.  To fix this, we add one last check--if the interface
number we're looking for is higher than the number of interfaces that AEM
claims to have, stop probing.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmaem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/ibmaem.c~ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems
+++ a/drivers/hwmon/ibmaem.c
@@ -676,7 +676,8 @@ static int aem_find_aem2(struct aem_ipmi
 		return -ETIMEDOUT;
 
 	if (data->rx_result || data->rx_msg_len != sizeof(*fi_resp) ||
-	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)))
+	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)) ||
+	    fi_resp->num_instances <= instance_num)
 		return -ENOENT;
 
 	return 0;
_

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-provide-labels-for-temperature-sensors.patch
ibmaem-update-the-documentation-to-reflect-the-current-name.patch
ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch

