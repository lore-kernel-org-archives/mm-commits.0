From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-tar-install-build-directory.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:49 -0800
Message-ID: <54de5cdd.F2L+sCVPpNAsygsC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrej.skvortzov@gmail.com, ak@linux.intel.com, boaz@plexistor.com, gregkh@linuxfoundation.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: gitignore: ignore tar-install build directory
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-tar-install-build-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

