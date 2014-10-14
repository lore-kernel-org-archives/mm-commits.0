From: akpm@linux-foundation.org
Subject: [merged]
 scripts-sortextable-suppress-warning-relocs_size-may-be-used-uninitialized.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:58 -0700
Message-ID: <543d69c6.uDdB9bjWqa88aRU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaJNSV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, jamie.iles@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/sortextable: suppress warning: `relocs_size' may be used uninitialized
has been removed from the -mm tree.  Its filename was
     scripts-sortextable-suppress-warning-relocs_size-may-be-used-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

diff -puN scripts/sortextable.h~scripts-sortextable-suppress-warning-relocs_size-may-be-used-uninitialized scripts/sortextable.h
--- a/scripts/sortextable.h~scripts-sortextable-suppress-warning-relocs_size-may-be-used-uninitialized
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

origin.patch

