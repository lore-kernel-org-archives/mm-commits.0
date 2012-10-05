From: akpm@linux-foundation.org
Subject: + localmodconfig-document-localmodconfig-in-readme.patch added to -mm tree
Date: Fri, 05 Oct 2012 14:12:14 -0700
Message-ID: <20121005211214.969F5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37717 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2JEVMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 17:12:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so244101vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 14:12:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mmarek@suse.cz


The patch titled
     Subject: localmodconfig: document localmodconfig in README
has been added to the -mm tree.  Its filename is
     localmodconfig-document-localmodconfig-in-readme.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
localmodconfig-document-localmodconfig-in-readme.patch

