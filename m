From: akpm@linux-foundation.org
Subject: +
 scripts-tagssh-collect-compiled-source-precisely-v2.patch added to -mm tree
Date: Thu, 02 Jul 2020 22:01:09 -0700
Message-ID: <20200703050109.luoTJhsD0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgGCFBL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 01:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, joe@perches.com, masahiroy@kernel.org, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, xujialu@vimux.org


The patch titled
     Subject: scripts-tagssh-collect-compiled-source-precisely-v2
has been added to the -mm tree.  Its filename is
     scripts-tagssh-collect-compiled-source-precisely-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-collect-compiled-source-precisely-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-collect-compiled-source-precisely-v2.patch

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
Subject: scripts-tagssh-collect-compiled-source-precisely-v2

don't expand symlinks by add option -s for realpath

Link: http://lkml.kernel.org/r/5efc5bfb.1c69fb81.41bf5.7131SMTPIN_ADDED_MISSING@mx.google.com
Signed-off-by: Jialu Xu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh~scripts-tagssh-collect-compiled-source-precisely-v2
+++ a/scripts/tags.sh
@@ -91,7 +91,7 @@ all_sources()
 
 all_compiled_sources()
 {
-	realpath -e $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
+	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
 		include/generated/autoconf.h $(find -name "*.cmd" -exec \
 		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
 		awk '!a[$0]++') | sort -u
_

Patches currently in -mm which might be from xujialu@vimux.org are

scripts-tagssh-collect-compiled-source-precisely.patch
scripts-tagssh-collect-compiled-source-precisely-v2.patch
