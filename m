From: akpm@linux-foundation.org
Subject: + checkkconfigsymbolssh-kconfig-symbols-sometimes-have-lowercase-letters.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:24:18 -0700
Message-ID: <201006022124.o52LOIgR017851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894Ab0FBVYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, mmarek@suse.cz, rolandd@cisco.com


The patch titled
     checkkconfigsymbols.sh: Kconfig symbols sometimes have lowercase letters
has been added to the -mm tree.  Its filename is
     checkkconfigsymbolssh-kconfig-symbols-sometimes-have-lowercase-letters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkkconfigsymbols.sh: Kconfig symbols sometimes have lowercase letters
From: Roland Dreier <rdreier@cisco.com>

Quite a few Kconfig symbols contain lowercase letters.  The current
checkkconfigsymbols.sh code only contains A-Z in the regexp it uses to
find config symbols in source code, so it comes up with the wrong symbol
to look for in Kconfig files and then generates false positives when it
doesn't find that wrong symbol.  For example checking drivers/net
generates a false positive for MAC89 because the the actual config option
is MAC89x0.

Fix this by also adding a-z to the regexp.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkkconfigsymbols.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkkconfigsymbols.sh~checkkconfigsymbolssh-kconfig-symbols-sometimes-have-lowercase-letters scripts/checkkconfigsymbols.sh
--- a/scripts/checkkconfigsymbols.sh~checkkconfigsymbolssh-kconfig-symbols-sometimes-have-lowercase-letters
+++ a/scripts/checkkconfigsymbols.sh
@@ -14,7 +14,7 @@ find $paths -name '*.[chS]' -o -name 'Ma
 do
 	# Output the bare Kconfig variable and the filename; the _MODULE part at
 	# the end is not removed here (would need perl an not-hungry regexp for that).
-	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Z_]\+\).*!\2 '$i'!p' < $i
+	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Za-z_]\+\).*!\2 '$i'!p' < $i
 done | \
 # Smart "sort|uniq" implemented in awk and tuned to collect the names of all
 # files which use a given symbol
_

Patches currently in -mm which might be from rdreier@cisco.com are

checkkconfigsymbolssh-kconfig-symbols-sometimes-have-lowercase-letters.patch
vfs-o_-bit-numbers-uniqueness-check.patch

