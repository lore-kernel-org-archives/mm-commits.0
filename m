From: akpm@linux-foundation.org
Subject: + objtool-do-not-retrieve-data-from-empty-sections.patch added to -mm tree
Date: Thu, 14 Sep 2017 14:11:47 -0700
Message-ID: <59baf093.LPn0VYpAiRA8QdPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdINVLs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2017 17:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petr@vandrovec.name, jpoimboe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: objtool: do not retrieve data from empty sections
has been added to the -mm tree.  Its filename is
     objtool-do-not-retrieve-data-from-empty-sections.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/objtool-do-not-retrieve-data-from-empty-sections.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/objtool-do-not-retrieve-data-from-empty-sections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Vandrovec <petr@vandrovec.name>
Subject: objtool: do not retrieve data from empty sections

Binutils 2.29-9 in Debian returns an error when elf_getdata is invoked on
empty section (.note.GNU-stack in all kernel files), causing immediate
failure of kernel build with:

elf_getdata: can't manipulate null section

As nothing is done with sections that have zero size, just do not retrieve
their data at all.

Link: http://lkml.kernel.org/r/20170914191111.embq3bfkppem3l5u@petr-dev3.eng.vmware.com
Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/elf.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN tools/objtool/elf.c~objtool-do-not-retrieve-data-from-empty-sections tools/objtool/elf.c
--- a/tools/objtool/elf.c~objtool-do-not-retrieve-data-from-empty-sections
+++ a/tools/objtool/elf.c
@@ -175,19 +175,20 @@ static int read_sections(struct elf *elf
 			return -1;
 		}
 
-		sec->data = elf_getdata(s, NULL);
-		if (!sec->data) {
-			WARN_ELF("elf_getdata");
-			return -1;
+		if (sec->sh.sh_size != 0) {
+			sec->data = elf_getdata(s, NULL);
+			if (!sec->data) {
+				WARN_ELF("elf_getdata");
+				return -1;
+			}
+			if (sec->data->d_off != 0 ||
+			    sec->data->d_size != sec->sh.sh_size) {
+				WARN("unexpected data attributes for %s",
+				     sec->name);
+				return -1;
+			}
 		}
-
-		if (sec->data->d_off != 0 ||
-		    sec->data->d_size != sec->sh.sh_size) {
-			WARN("unexpected data attributes for %s", sec->name);
-			return -1;
-		}
