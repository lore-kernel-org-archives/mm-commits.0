From: akpm@linux-foundation.org
Subject: [merged] fixdep-faster-config_-search-v2.patch removed from -mm
 tree
Date: Thu, 25 Aug 2016 13:31:13 -0700
Message-ID: <57bf5591.AykF1qrj6Y+Q/7H0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933073AbcHYUbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 16:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fixdep: faster CONFIG_ search
has been removed from the -mm tree.  Its filename was
     fixdep-faster-config_-search-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fixdep: faster CONFIG_ search

Link: http://lkml.kernel.org/r/20160824180305.GA22266@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/fixdep.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff -puN scripts/basic/fixdep.c~fixdep-faster-config_-search-v2 scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~fixdep-faster-config_-search-v2
+++ a/scripts/basic/fixdep.c
@@ -114,11 +114,6 @@
 #include <ctype.h>
 #include <arpa/inet.h>
 
-#define INT_CONF ntohl(0x434f4e46)
-#define INT_ONFI ntohl(0x4f4e4649)
-#define INT_NFIG ntohl(0x4e464947)
-#define INT_FIG_ ntohl(0x4649475f)
-
 int insert_extra_deps;
 char *target;
 char *depfile;
@@ -435,22 +430,8 @@ static void print_deps(void)
 	close(fd);
 }
 
-static void traps(void)
-{
-	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
-	int *p = (int *)test;
-
-	if (*p != INT_CONF) {
-		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianness? %#x\n",
-			*p);
-		exit(2);
-	}
-}
-
 int main(int argc, char *argv[])
 {
-	traps();
