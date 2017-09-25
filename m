From: akpm@linux-foundation.org
Subject: [merged]
 objtool-do-not-retrieve-data-from-empty-sections.patch removed from -mm
 tree
Date: Mon, 25 Sep 2017 13:58:20 -0700
Message-ID: <20170925205820.3HqH3oI65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964935AbdIYU6V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 16:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, mm-commits@vger.kernel.org, petr@vandrovec.name


The patch titled
     Subject: objtool: do not retrieve data from empty sections
has been removed from the -mm tree.  Its filename was
     objtool-do-not-retrieve-data-from-empty-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
