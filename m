From: akpm@linux-foundation.org
Subject: + fix-all-wmissing-prototypes-warnings-in-x86-defconfig.patch added to -mm tree
Date: Fri, 24 Jul 2009 14:49:20 -0700
Message-ID: <200907242149.n6OLnKxb023771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbZGXVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsrk@tsrk.net, sam@ravnborg.org


The patch titled
     Fix all -Wmissing-prototypes warnings in x86 defconfig
has been added to the -mm tree.  Its filename is
     fix-all-wmissing-prototypes-warnings-in-x86-defconfig.patch

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
Subject: Fix all -Wmissing-prototypes warnings in x86 defconfig
From: Trevor Keith <tsrk@tsrk.net>

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/conmakehash.c     |    6 +++---
 scripts/mod/modpost.c     |    4 ++--
 scripts/selinux/mdp/mdp.c |    4 ++--
 usr/gen_init_cpio.c       |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN scripts/conmakehash.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig scripts/conmakehash.c
--- a/scripts/conmakehash.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig
+++ a/scripts/conmakehash.c
@@ -24,14 +24,14 @@
 
 typedef unsigned short unicode;
 
-void usage(char *argv0)
+static void usage(char *argv0)
 {
   fprintf(stderr, "Usage: \n"
          "        %s chartable [hashsize] [hashstep] [maxhashlevel]\n", argv0);
   exit(EX_USAGE);
 }
 
-int getunicode(char **p0)
+static int getunicode(char **p0)
 {
   char *p = *p0;
 
@@ -49,7 +49,7 @@ unicode unitable[MAX_FONTLEN][255];
 				/* Massive overkill, but who cares? */
 int unicount[MAX_FONTLEN];
 
-void addpair(int fp, int un)
+static void addpair(int fp, int un)
 {
   int i;
 
diff -puN scripts/mod/modpost.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig
+++ a/scripts/mod/modpost.c
@@ -691,7 +691,7 @@ static int number_prefix(const char *sym
  *   The $ syntax is for sections where ld append a dot number
  *   to make section name unique.
  */
-int match(const char *sym, const char * const pat[])
+static int match(const char *sym, const char * const pat[])
 {
 	const char *p;
 	while (*pat) {
@@ -1746,7 +1746,7 @@ static void add_header(struct buffer *b,
 	buf_printf(b, "};\n");
 }
 
-void add_staging_flag(struct buffer *b, const char *name)
+static void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
 
diff -puN scripts/selinux/mdp/mdp.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig scripts/selinux/mdp/mdp.c
--- a/scripts/selinux/mdp/mdp.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig
+++ a/scripts/selinux/mdp/mdp.c
@@ -31,13 +31,13 @@
 
 #include "flask.h"
 
-void usage(char *name)
+static void usage(char *name)
 {
 	printf("usage: %s [-m] policy_file context_file\n", name);
 	exit(1);
 }
 
-void find_common_name(char *cname, char *dest, int len)
+static void find_common_name(char *cname, char *dest, int len)
 {
 	char *start, *end;
 
diff -puN usr/gen_init_cpio.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~fix-all-wmissing-prototypes-warnings-in-x86-defconfig
+++ a/usr/gen_init_cpio.c
@@ -446,7 +446,7 @@ static int cpio_mkfile_line(const char *
 	return rc;
 }
 
-void usage(const char *prog)
+static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
 		"\t%s <cpio_list>\n"
_

Patches currently in -mm which might be from tsrk@tsrk.net are

fix-all-wmissing-prototypes-warnings-in-x86-defconfig.patch

