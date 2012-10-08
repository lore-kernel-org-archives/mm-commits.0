From: akpm@linux-foundation.org
Subject: [merged] localmodconfig-document-localmodconfig-in-readme.patch removed from -mm tree
Date: Mon, 08 Oct 2012 11:54:04 -0700
Message-ID: <20121008185404.7AF99100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62935 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2JHSyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 14:54:05 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so410785yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 11:54:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: document localmodconfig in README
has been removed from the -mm tree.  Its filename was
     localmodconfig-document-localmodconfig-in-readme.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: localmodconfig: document localmodconfig in README

Someone (over a year ago :-p) asked me to document localmodconfig in the
README file in the source code.  I thought it was a good idea but other
things were more important and I simply forgot about it.  Well, I stumbled
on the email asking me about this and I'm sending it out now.

Signed-off-by: Steven "Mr. Procrastinator" Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 README |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN README~localmodconfig-document-localmodconfig-in-readme README
--- a/README~localmodconfig-document-localmodconfig-in-readme
+++ a/README
@@ -206,6 +206,24 @@ CONFIGURING the kernel:
      "make randconfig"  Create a ./.config file by setting symbol
                         values to random values.
 
+     "make localmodconfig" Create a config based on current config and
+                           loaded modules (lsmod). Disables any module
+                           option that is not needed for the loaded modules.
+
+                           To create a localmodconfig for another machine,
+                           store the lsmod of that machine into a file
+                           and pass it in as a LSMOD parameter.
+
+                   target$ lsmod > /tmp/mylsmod
+                   target$ scp /tmp/mylsmod host:/tmp
+
+                   host$ make LSMOD=/tmp/mylsmod localmodconfig
+
+                           The above also works when cross compiling.
+
+     "make localyesconfig" Similar to localmodconfig, except it will convert
+                           all module options to built in (=y) options.
+
    You can find more information on using the Linux kernel config tools
    in Documentation/kbuild/kconfig.txt.
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch

