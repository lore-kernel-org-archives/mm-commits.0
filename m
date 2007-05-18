From: akpm@linux-foundation.org
Subject: - add-support-for-reading-stdin-with-gen_init_cpio.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:52 -0700
Message-ID: <200705180706.l4I76pHs010218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762072AbXERHJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     add support for reading stdin with gen_init_cpio
has been removed from the -mm tree.  Its filename was
     add-support-for-reading-stdin-with-gen_init_cpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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

git-kbuild.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
