From: akpm@linux-foundation.org
Subject: + scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:30:52 -0700
Message-ID: <200808112030.m7BKUrId019864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbYHKUbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, sam@ravnborg.org


The patch titled
     scripts/package: don't break if %{_smp_mflags} isn't set
has been added to the -mm tree.  Its filename is
     scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch

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

scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch
scripts-package-allow-custom-options-to-rpm.patch

