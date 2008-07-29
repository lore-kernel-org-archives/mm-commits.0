From: akpm@linux-foundation.org
Subject: + genksyms-include-extern-information-in-dumps.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:51:44 -0700
Message-ID: <200807290351.m6T3pi1q012701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYG2Dw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 23:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@suse.de, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     genksyms: include extern information in dumps
has been added to the -mm tree.  Its filename is
     genksyms-include-extern-information-in-dumps.patch

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
Subject: genksyms: include extern information in dumps
From: Andreas Gruenbacher <agruen@suse.de>

The extern flag currently is not included in type dump files (genksyms
--dump-types).  Include that flag there for completeness.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/genksyms/genksyms.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/genksyms/genksyms.c~genksyms-include-extern-information-in-dumps scripts/genksyms/genksyms.c
--- a/scripts/genksyms/genksyms.c~genksyms-include-extern-information-in-dumps
+++ a/scripts/genksyms/genksyms.c
@@ -545,6 +545,8 @@ int main(int argc, char **argv)
 			}
 			fputs(sym->name, dumpfile);
 			putc(' ', dumpfile);
+			if (sym->is_extern)
+				fputs("extern ", dumpfile);
 			print_list(dumpfile, sym->defn);
 			putc('\n', dumpfile);
 
_

Patches currently in -mm which might be from agruen@suse.de are

genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
git-unionfs.patch

