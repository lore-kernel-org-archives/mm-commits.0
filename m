From: akpm@linux-foundation.org
Subject: + ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch added to -mm tree
Date: Wed, 13 Aug 2008 15:51:27 -0700
Message-ID: <200808132251.m7DMpRwJ010732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYHMWwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 18:52:16 -0400
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
Return-Path: <djwong@us.ibm.com>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=ham
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id m7DMgC9B014641
	for <akpm@localhost>; Wed, 13 Aug 2008 15:42:13 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with IMAP (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Wed, 13 Aug 2008 15:42:13 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7DMdXbx010304
	for <akpm@imap1.linux-foundation.org>; Wed, 13 Aug 2008 15:39:33 -0700
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7DMdPhN008433
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@linux-foundation.org>; Wed, 13 Aug 2008 15:39:27 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7DMdJLQ031371
	for <akpm@linux-foundation.org>; Wed, 13 Aug 2008 18:39:19 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7DMdJIn153524
	for <akpm@linux-foundation.org>; Wed, 13 Aug 2008 16:39:19 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7DMdJaB013880
	for <akpm@linux-foundation.org>; Wed, 13 Aug 2008 16:39:19 -0600
Received: from localhost (tree.beaverton.ibm.com [9.47.17.114])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m7DMdJhQ013860;
	Wed, 13 Aug 2008 16:39:19 -0600
Date: Wed, 13 Aug 2008 15:40:15 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] ibmaem: Prevent infinite probing loop on x3650 M2 systems
Message-ID: <20080813224015.GA28450@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Received-SPF: pass (domain of djwong@us.ibm.com designates 32.97.110.153 as permitted sender)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

On older machines, probing for a nonexistent AEM interface returned an IPMI
error; when we saw this, we'd stop probing.  On the x3650 M2 and (presumably)
later, we are returned a value indicating success and a buffer full of garbage
or zeroes.  This causes the probe function to run in an infinite loop.  To fix
this, we add one last check--if the interface number we're looking for is
higher than the number of interfaces that AEM claims to have, stop probing.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index c1ee7dd..0f70dc2 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -682,7 +682,8 @@ static int aem_find_aem2(struct aem_ipmi_data *data,
 		return -ETIMEDOUT;
 
 	if (data->rx_result || data->rx_msg_len != sizeof(*fi_resp) ||
-	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)))
+	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)) ||
+	    fi_resp->num_instances <= instance_num)
 		return -ENOENT;
 
 	return 0;

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-provide-labels-for-temperature-sensors.patch
ibmaem-update-the-documentation-to-reflect-the-current-name.patch
ibmaem-prevent-infinite-probing-loop-on-x3650-m2-systems.patch

