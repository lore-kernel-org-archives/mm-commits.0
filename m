From: akpm@linux-foundation.org
Subject: + mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch added to -mm tree
Date: Thu, 28 Jun 2012 12:50:39 -0700
Message-ID: <20120628195039.D98CDA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62143 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2F1Tum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 15:50:42 -0400
Received: by eaao13 with SMTP id o13so146317eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 12:50:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails

We should goto error to release memory resource if hotadd_new_pgdat()
failed.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~release-memory-resources-if-hotadd_new_pgdat-failed mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~release-memory-resources-if-hotadd_new_pgdat-failed
+++ a/mm/memory_hotplug.c
@@ -618,7 +618,7 @@ int __ref add_memory(int nid, u64 start,
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
 		if (!pgdat)
-			goto out;
+			goto error;
 		new_pgdat = 1;
 	}
 
_
Subject: Subject: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch

