Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFC3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhLPWS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhLPWS4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:18:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC15EC061574
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 14:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8816761F98
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6445C36AE7;
        Thu, 16 Dec 2021 22:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639693134;
        bh=pTzzxro/GyVJp2z5EIg7uh5YBAvio9c2+x5smwCkmlg=;
        h=Date:From:To:Subject:From;
        b=opkB2LIqht5EcLRUS+/5Ai3x5XgmQT7Zp0Pi3QHqKw/vaUpdD3w9gk4L89tCuJC92
         U0gAysi9c3ttnK4uNrOHMdDpYMjs/bs4EsJO+hPwlja9jRnJsLfPbD7iGEEAek/eu+
         lZcWczE8EHmsxovBkPbpmycgCD4Ig+gzvnwqUvyc=
Date:   Thu, 16 Dec 2021 14:18:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, peterz@infradead.org, mingo@kernel.org,
        bsingharora@gmail.com, wang.yong12@zte.com.cn
Subject:  +
 documentation-accounting-add-thrashing-page-cache-and-direct-compact.patch
 added to -mm tree
Message-ID: <20211216221854.SPOcb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/accounting/delay-accounting.rst: add thrashing page cache and direct compact
has been added to the -mm tree.  Its filename is
     documentation-accounting-add-thrashing-page-cache-and-direct-compact.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-accounting-add-thrashing-page-cache-and-direct-compact.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-accounting-add-thrashing-page-cache-and-direct-compact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: wangyong <wang.yong12@zte.com.cn>
Subject: Documentation/accounting/delay-accounting.rst: add thrashing page cache and direct compact

Add thrashing page cache and direct compact related descriptions and
update the usage of getdelays userspace utility.

The following patches modifications have been updated:
https://lore.kernel.org/all/20190312102002.31737-4-jinpuwang@gmail.com/
https://lore.kernel.org/all/1638619795-71451-1-git-send-email-
wang.yong12@zte.com.cn/

Link: https://lkml.kernel.org/r/1639583021-92977-1-git-send-email-wang.yong12@zte.com.cn
Signed-off-by: wangyong <wang.yong12@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   63 +++++++---------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~documentation-accounting-add-thrashing-page-cache-and-direct-compact
+++ a/Documentation/accounting/delay-accounting.rst
@@ -13,6 +13,8 @@ a) waiting for a CPU (while being runnab
 b) completion of synchronous block I/O initiated by the task
 c) swapping in pages
 d) memory reclaim
+e) thrashing page cache
+f) direct compact
 
 and makes these statistics available to userspace through
 the taskstats interface.
@@ -41,11 +43,12 @@ generic data structure to userspace corr
 statistics. The delay accounting functionality populates specific fields of
 this structure. See
 
-     include/linux/taskstats.h
+     include/uapi/linux/taskstats.h
 
 for a description of the fields pertaining to delay accounting.
 It will generally be in the form of counters returning the cumulative
-delay seen for cpu, sync block I/O, swapin, memory reclaim etc.
+delay seen for cpu, sync block I/O, swapin, memory reclaim, thrash page
+cache, direct compact etc.
 
 Taking the difference of two successive readings of a given
 counter (say cpu_delay_total) for a task will give the delay
@@ -88,41 +91,37 @@ seen.
 
 General format of the getdelays command::
 
-	getdelays [-t tgid] [-p pid] [-c cmd...]
-
+	getdelays [-dilv] [-t tgid] [-p pid]
 
 Get delays, since system boot, for pid 10::
 
-	# ./getdelays -p 10
+	# ./getdelays -d -p 10
 	(output similar to next case)
 
 Get sum of delays, since system boot, for all pids with tgid 5::
 
-	# ./getdelays -t 5
-
+	# ./getdelays -d -t 5
+	print delayacct stats ON
+	TGID	5
+
+
+	CPU             count     real total  virtual total    delay total  delay average
+	                    8        7000000        6872122        3382277          0.423ms
+	IO              count    delay total  delay average
+		            0              0              0ms
+	SWAP            count    delay total  delay average
+	                    0              0              0ms
+	RECLAIM         count    delay total  delay average
+		            0              0              0ms
+	THRASHING       count    delay total  delay average
+	                    0              0              0ms
+	COMPACT         count    delay total  delay average
+	                    0              0              0ms
+
+Get IO accounting for pid 1, it works only with -p::
+
+	# ./getdelays -i -p 1
+	printing IO accounting
+	linuxrc: read=65536, write=0, cancelled_write=0
 
-	CPU	count	real total	virtual total	delay total
-		7876	92005750	100000000	24001500
-	IO	count	delay total
-		0	0
-	SWAP	count	delay total
-		0	0
-	RECLAIM	count	delay total
-		0	0
-
-Get delays seen in executing a given simple command::
-
-  # ./getdelays -c ls /
-
-  bin   data1  data3  data5  dev  home  media  opt   root  srv        sys  usr
-  boot  data2  data4  data6  etc  lib   mnt    proc  sbin  subdomain  tmp  var
-
-
-  CPU	count	real total	virtual total	delay total
-	6	4000250		4000000		0
-  IO	count	delay total
-	0	0
-  SWAP	count	delay total
-	0	0
-  RECLAIM	count	delay total
-	0	0
+The above command can be used with -v to get more debug information.
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are

documentation-accounting-add-thrashing-page-cache-and-direct-compact.patch

