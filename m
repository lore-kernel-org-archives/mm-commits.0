From: akpm@linux-foundation.org
Subject: + gitignore-ignore-tar-install-build-directory.patch added to -mm tree
Date: Thu, 29 Jan 2015 13:53:06 -0800
Message-ID: <54caabc2.CKPgYtSFNLRqx3Fd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbbA2VxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:53:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrej.skvortzov@gmail.com, ak@linux.intel.com, boaz@plexistor.com, gregkh@linuxfoundation.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: gitignore: ignore tar-install build directory
has been added to the -mm tree.  Its filename is
     gitignore-ignore-tar-install-build-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gitignore-ignore-tar-install-build-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gitignore-ignore-tar-install-build-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: gitignore: ignore tar-install build directory

Have git ignore the Debian directory created when running:
     make tar-pkg / targz-pkg / tarbz2-pkg / tarxz-pkg

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN .gitignore~gitignore-ignore-tar-install-build-directory .gitignore
--- a/.gitignore~gitignore-ignore-tar-install-build-directory
+++ a/.gitignore
@@ -53,6 +53,11 @@ Module.symvers
 /debian/
 
 #
+# tar directory (make tar*-pkg)
+#
+/tar-install/
+
+#
 # git files that we don't want to ignore even it they are dot-files
 #
 !.gitignore
_

Patches currently in -mm which might be from andrej.skvortzov@gmail.com are

gitignore-ignore-tar-install-build-directory.patch

