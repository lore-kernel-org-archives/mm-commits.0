From: akpm@linux-foundation.org
Subject: + scripts-tagssh-collect-compiled-source-precisely.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 13:02:26 -0700
Message-ID: <20200616200226.lkQGj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbgFPUC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 16:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab+huawei@kernel.org, masahiroy@kernel.org, joe@perches.com, gregkh@linuxfoundation.org, corbet@lwn.net, xujialu@vimux.org


The patch titled
     Subject: scripts/tags.sh: collect compiled source precisely
has been added to the -mm tree.  Its filename is
     scripts-tagssh-collect-compiled-source-precisely.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-collect-compiled-source-precisely.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-collect-compiled-source-precisely.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jialu Xu <xujialu@vimux.org>
Subject: scripts/tags.sh: collect compiled source precisely

Parse compiled source from *.cmd but don't 'find' too many files that are
not related to compilation.

Link: http://lkml.kernel.org/r/5ee5d8e3.1c69fb81.9b804.47b2SMTPIN_ADDED_MISSING@mx.google.com
Signed-off-by: Jialu Xu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/scripts/tags.sh~scripts-tagssh-collect-compiled-source-precisely
+++ a/scripts/tags.sh
@@ -91,20 +91,10 @@ all_sources()
 
 all_compiled_sources()
 {
-	for i in $(all_sources); do
-		case "$i" in
-			*.[cS])
-				j=${i/\.[cS]/\.o}
-				j="${j#$tree}"
-				if [ -e $j ]; then
-					echo $i
-				fi
-				;;
-			*)
-				echo $i
-				;;
-		esac
-	done
+	realpath -e $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
+		include/generated/autoconf.h $(find -name "*.cmd" -exec \
+		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+		awk '!a[$0]++') | sort -u
 }
 
 all_target_sources()
_

Patches currently in -mm which might be from xujialu@vimux.org are

scripts-tagssh-collect-compiled-source-precisely.patch
