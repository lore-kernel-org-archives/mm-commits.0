From: akpm@linux-foundation.org
Subject: - genksyms-include-extern-information-in-dumps.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:28 -0700
Message-ID: <200808042006.m74K6Sga027694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762719AbYHDUHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@suse.de, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     genksyms: include extern information in dumps
has been removed from the -mm tree.  Its filename was
     genksyms-include-extern-information-in-dumps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
git-unionfs.patch

