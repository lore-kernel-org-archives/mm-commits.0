From: akpm@linux-foundation.org
Subject: - ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:09 -0700
Message-ID: <200808181940.m7IJe9VK008427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762978AbYHRToX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibmaem: prevent infinite probing loop on x3650 M2 systems
has been removed from the -mm tree.  Its filename was
     ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

