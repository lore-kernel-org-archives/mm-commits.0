From: akpm@linux-foundation.org
Subject: - scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:37 -0700
Message-ID: <200810301904.m9UJ4bgb024846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717AbYJ3TEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/package: don't break if %{_smp_mflags} isn't set
has been removed from the -mm tree.  Its filename was
     scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/package: don't break if %{_smp_mflags} isn't set
From: Jeremy Kerr <jk@ozlabs.org>

Currently, if we do a 'make rpm-pkg' without the _smp_mflags rpm macro
defined, the build fails with:

  [snip]
  Executing(%build): /bin/bash -e /var/tmp/rpm-tmp.67959
  + umask 022
  + cd /home/jk/devel/kernel-snapshot/rpm/BUILD
  + cd kernel-2.6.26
  + make clean
  + make '%{_smp_mflags}'
  make[3]: *** No rule to make target `%{_smp_mflags}'.  Stop.
  error: Bad exit status from /var/tmp/rpm-tmp.67959 (%build)

This change uses the 'null if not set' reference to the _smp_mflags
macro instead.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/package/mkspec |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/package/mkspec~scripts-package-dont-break-if-%_smp_mflags-isnt-set scripts/package/mkspec
--- a/scripts/package/mkspec~scripts-package-dont-break-if-%_smp_mflags-isnt-set
+++ a/scripts/package/mkspec
@@ -57,7 +57,7 @@ fi
 echo "%build"
 
 if ! $PREBUILT; then
-echo "make clean && make %{_smp_mflags}"
+echo "make clean && make %{?_smp_mflags}"
 echo ""
 fi
 
_

Patches currently in -mm which might be from jk@ozlabs.org are

linux-next.patch
scripts-package-allow-custom-options-to-rpm.patch

