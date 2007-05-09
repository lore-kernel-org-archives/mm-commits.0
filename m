From: akpm@linux-foundation.org
Subject: + add-support-for-reading-stdin-with-gen_init_cpio.patch added to -mm tree
Date: Wed, 09 May 2007 13:43:52 -0700
Message-ID: <200705092043.l49KhqMb000598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbXEIUn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, sam@ravnborg.org


The patch titled
     add support for reading stdin with gen_init_cpio
has been added to the -mm tree.  Its filename is
     add-support-for-reading-stdin-with-gen_init_cpio.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add support for reading stdin with gen_init_cpio
From: Mike Frysinger <vapier@gentoo.org>

Treat an argument of "-" as meaning "read stdin for cpio files" so
gen_init_cpio can be piped into.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN usr/gen_init_cpio.c~add-support-for-reading-stdin-with-gen_init_cpio usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~add-support-for-reading-stdin-with-gen_init_cpio
+++ a/usr/gen_init_cpio.c
@@ -498,7 +498,9 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
-	if (! (cpio_list = fopen(argv[1], "r"))) {
+	if (!strcmp(argv[1], "-"))
+		cpio_list = stdin;
+	else if (! (cpio_list = fopen(argv[1], "r"))) {
 		fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
 			argv[1], strerror(errno));
 		usage(argv[0]);
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
add-support-for-reading-stdin-with-gen_init_cpio.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
