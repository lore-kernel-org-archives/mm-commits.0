From: akpm@linux-foundation.org
Subject: + x.patch added to -mm tree
Date: Thu, 18 Sep 2014 15:33:26 -0700
Message-ID: <541b5db6.z7nOHfDnd/S5ORH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaIRWd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 18:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, jamie.iles@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/sortextable: suppress warning: `relocs_size' may be used uninitialized
has been added to the -mm tree.  Its filename is
     x.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Gardner <tim.gardner@canonical.com>
Subject: scripts/sortextable: suppress warning: `relocs_size' may be used uninitialized

In file included from scripts/sortextable.c:194:0:
scripts/sortextable.c: In function `main':
scripts/sortextable.h:176:3: warning: `relocs_size' may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: `relocs_size' was declared here
  int relocs_size;
      ^
In file included from scripts/sortextable.c:192:0:
scripts/sortextable.h:176:3: warning: `relocs_size' may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: `relocs_size' was declared here
  int relocs_size;
      ^

gcc 4.9.1

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Reviewed-by: Jamie Iles <jamie.iles@oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/sortextable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/sortextable.h~x scripts/sortextable.h
--- a/scripts/sortextable.h~x
+++ a/scripts/sortextable.h
@@ -103,7 +103,7 @@ do_func(Elf_Ehdr *ehdr, char const *cons
 	Elf_Sym *sort_needed_sym;
 	Elf_Shdr *sort_needed_sec;
 	Elf_Rel *relocs = NULL;
-	int relocs_size;
+	int relocs_size = 0;
 	uint32_t *sort_done_location;
 	const char *secstrtab;
 	const char *strtab;
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

x.patch
linux-next.patch

