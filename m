From: akpm@linux-foundation.org
Subject: [merged]
 dynamic-debug-howtotxt-update-since-new-wildcard-support.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:53 -0800
Message-ID: <52e2b865.ByfzkBB5asbpPXfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jbaron@akamai.com, changbin.du@gmail.com

Subject: [merged] dynamic-debug-howtotxt-update-since-new-wildcard-support.patch removed from -mm tree
To: changbin.du@gmail.com,jbaron@akamai.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:53 -0800


The patch titled
     Subject: dynamic-debug-howto.txt: update since new wildcard support
has been removed from the -mm tree.  Its filename was
     dynamic-debug-howtotxt-update-since-new-wildcard-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Du, Changbin" <changbin.du@gmail.com>
Subject: dynamic-debug-howto.txt: update since new wildcard support

Add the usage of using new feature wildcard support.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dynamic-debug-howto.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/dynamic-debug-howto.txt~dynamic-debug-howtotxt-update-since-new-wildcard-support Documentation/dynamic-debug-howto.txt
--- a/Documentation/dynamic-debug-howto.txt~dynamic-debug-howtotxt-update-since-new-wildcard-support
+++ a/Documentation/dynamic-debug-howto.txt
@@ -108,6 +108,12 @@ If your query set is big, you can batch
 
   ~# cat query-batch-file > <debugfs>/dynamic_debug/control
 
+A another way is to use wildcard. The match rule support '*' (matches
+zero or more characters) and '?' (matches exactly one character).For
+example, you can match all usb drivers:
+
+  ~# echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
+
 At the syntactical level, a command comprises a sequence of match
 specifications, followed by a flags change specification.
 
@@ -315,6 +321,9 @@ nullarbor:~ # echo -n 'func svc_process
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
 
+// enable messages in files of which the pathes include string "usb"
+nullarbor:~ # echo -n '*usb* +p' > <debugfs>/dynamic_debug/control
+
 // enable all messages
 nullarbor:~ # echo -n '+p' > <debugfs>/dynamic_debug/control
 
_

Patches currently in -mm which might be from changbin.du@gmail.com are

origin.patch

