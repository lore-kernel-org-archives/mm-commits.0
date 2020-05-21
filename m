From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked]
 scripts-support-compiled-source-improved-precise.patch removed from -mm
 tree
Date: Thu, 21 May 2020 10:28:34 -0700
Message-ID: <20200521172834.HNvITuDlF%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgEUR2f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 May 2020 13:28:35 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, masahiroy@kernel.org, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, xujialu@vimux.org


The patch titled
     Subject: scripts/tags.sh: support compiled source, improved precise
has been removed from the -mm tree.  Its filename was
     scripts-support-compiled-source-improved-precise.patch

This patch was dropped because it was nacked

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
