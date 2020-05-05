From: akpm@linux-foundation.org
Subject: + scripts-support-compiled-source-improved-precise.patch
 added to -mm tree
Date: Tue, 05 May 2020 13:22:57 -0700
Message-ID: <20200505202257.ZFnIhw_Yd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgEEUW7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 16:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, masahiroy@kernel.org, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, xujialu@vimux.org


The patch titled
     Subject: scripts/tags.sh: support compiled source, improved precise
has been added to the -mm tree.  Its filename is
     scripts-support-compiled-source-improved-precise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-support-compiled-source-improved-precise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-support-compiled-source-improved-precise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xujialu <xujialu@vimux.org>
Subject: scripts/tags.sh: support compiled source, improved precise

Original 'COMPILED_SOURCE=1 make cscope' collects nearly 30000 files
include too many unused files, this patch precisely collects source
files from *.cmd, in this case just 3000 files include dts and dtsi.

Usage:
  1) COMPILED_SOURCE=1                           make {cscope,gtags}
  2) COMPILED_SOURCE=1 KBUILD_ABS_SRCTREE=1      make {cscope,gtags}
  3) COMPILED_SOURCE=1              ./scripts/tags.sh {cscope,gtags}
  4) COMPILED_SOURCE=1 ABSPWD=$PWD/ ./scripts/tags.sh {cscope,gtags}

Link: http://lkml.kernel.org/r/20200502052619.26457-2-xujialu@vimux.org
Signed-off-by: xujialu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/scripts/tags.sh~scripts-support-compiled-source-improved-precise
+++ a/scripts/tags.sh
@@ -89,22 +89,30 @@ all_sources()
 	find_other_sources '*.[chS]'
 }
 
+# COMPILED_SOURCE=1                           make {cscope,gtags}
+# COMPILED_SOURCE=1 KBUILD_ABS_SRCTREE=1      make {cscope,gtags}
+# COMPILED_SOURCE=1              ./scripts/tags.sh {cscope,gtags}
+# COMPILED_SOURCE=1 ABSPWD=$PWD/ ./scripts/tags.sh {cscope,gtags}
+xtags_juggle_list()
+{
+	SRCTREE=$(realpath ${tree}.)
+
+	cd $(dirname $(find -name .config -print -quit).)
+
+	realpath -e --relative-to=${SRCTREE} $(find -name "*.cmd" -exec \
+		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+		awk '!a[$0]++') include/generated/autoconf.h |
+	sed -e "/\.\./d" -e "s,^,${ABSPWD}${tree},"
+}
+
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
+	# Consider 'git ls-files' features:
+	#   1) sort and uniq target files
+	#   2) limit target files by index
+	# git ls-files $(xtags_juggle_list)
+
+	xtags_juggle_list | sort -u
 }
 
 all_target_sources()
_

Patches currently in -mm which might be from xujialu@vimux.org are

scripts-support-compiled-source-improved-precise.patch
scripts-add-a-intermediate-file-for-make-gtags.patch
