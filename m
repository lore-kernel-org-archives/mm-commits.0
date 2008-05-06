From: akpm@linux-foundation.org
Subject: + lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch added to -mm tree
Date: Tue, 06 May 2008 13:24:39 -0700
Message-ID: <200805062024.m46KOd7o025517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbYEFUZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     lib: allow memparse() to accept a NULL and ignorable second parm
has been added to the -mm tree.  Its filename is
     lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch

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
Subject: lib: allow memparse() to accept a NULL and ignorable second parm
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Extend memparse() to allow the caller to use a NULL second parameter, which
would represent no interest in returning the address of the end of the parsed
string.

In numerous cases, callers invoke memparse() to parse a possibly-suffixed
string (such as "64K" or "2G" or whatever) and define a character pointer to
accept the end pointer being returned by memparse() even though they have no
interest in it and promptly throw it away.

This (backward-compatible) enhancement allows callers to use NULL in the cases
where they just don't care about getting back that end pointer.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm lib/cmdline.c
--- a/lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm
+++ a/lib/cmdline.c
@@ -116,7 +116,7 @@ char *get_options(const char *str, int n
 /**
  *	memparse - parse a string with mem suffixes into a number
  *	@ptr: Where parse begins
- *	@retptr: (output) Pointer to next char after parse completes
+ *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
@@ -128,9 +128,11 @@ char *get_options(const char *str, int n
 
 unsigned long long memparse (char *ptr, char **retptr)
 {
-	unsigned long long ret = simple_strtoull (ptr, retptr, 0);
+	char *endptr;	/* local pointer to end of parsed string */
 
-	switch (**retptr) {
+	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+
+	switch (*endptr) {
 	case 'G':
 	case 'g':
 		ret <<= 10;
@@ -140,10 +142,15 @@ unsigned long long memparse (char *ptr, 
 	case 'K':
 	case 'k':
 		ret <<= 10;
-		(*retptr)++;
+		endptr++;
 	default:
 		break;
 	}
+
+	if (retptr) {
+		*retptr = endptr;
+	}
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch

