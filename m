From: akpm@linux-foundation.org
Subject: [merged] gen_init_cpio-avoid-stack-overflow-when-expanding.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:36 -0700
Message-ID: <20121029195036.B38871E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51182 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2J2Tuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:37 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so376402qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mmarek@suse.cz, pageexec@freemail.hu, spender@grsecurity.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: gen_init_cpio: avoid stack overflow when expanding
has been removed from the -mm tree.  Its filename was
     gen_init_cpio-avoid-stack-overflow-when-expanding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: gen_init_cpio: avoid stack overflow when expanding

Fix possible overflow of the buffer used for expanding environment
variables when building file list.  In the extremely unlikely case of an
attacker having control over the environment variables visible to
gen_init_cpio, control over the contents of the file gen_init_cpio parses,
and gen_init_cpio was built without compiler hardening, the attacker can
gain arbitrary execution control via a stack buffer overflow.

$ cat usr/crash.list
file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
$ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
*** buffer overflow detected ***: ./usr/gen_init_cpio terminated

This also replaces the space-indenting with tabs.

Patch based on existing fix extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff -puN usr/gen_init_cpio.c~gen_init_cpio-avoid-stack-overflow-when-expanding usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~gen_init_cpio-avoid-stack-overflow-when-expanding
+++ a/usr/gen_init_cpio.c
@@ -303,7 +303,7 @@ static int cpio_mkfile(const char *name,
 	int retval;
 	int rc = -1;
 	int namesize;
-	int i;
+	unsigned int i;
 
 	mode |= S_IFREG;
 
@@ -381,25 +381,28 @@ error:
 
 static char *cpio_replace_env(char *new_location)
 {
-       char expanded[PATH_MAX + 1];
-       char env_var[PATH_MAX + 1];
-       char *start;
-       char *end;
-
-       for (start = NULL; (start = strstr(new_location, "${")); ) {
-               end = strchr(start, '}');
-               if (start < end) {
-                       *env_var = *expanded = '\0';
-                       strncat(env_var, start + 2, end - start - 2);
-                       strncat(expanded, new_location, start - new_location);
-                       strncat(expanded, getenv(env_var), PATH_MAX);
-                       strncat(expanded, end + 1, PATH_MAX);
-                       strncpy(new_location, expanded, PATH_MAX);
-               } else
-                       break;
-       }
+	char expanded[PATH_MAX + 1];
+	char env_var[PATH_MAX + 1];
+	char *start;
+	char *end;
+
+	for (start = NULL; (start = strstr(new_location, "${")); ) {
+		end = strchr(start, '}');
+		if (start < end) {
+			*env_var = *expanded = '\0';
+			strncat(env_var, start + 2, end - start - 2);
+			strncat(expanded, new_location, start - new_location);
+			strncat(expanded, getenv(env_var),
+				PATH_MAX - strlen(expanded));
+			strncat(expanded, end + 1,
+				PATH_MAX - strlen(expanded));
+			strncpy(new_location, expanded, PATH_MAX);
+			new_location[PATH_MAX] = 0;
+		} else
+			break;
+	}
 
-       return new_location;
+	return new_location;
 }
 
 
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
proc-dont-show-nonexistent-capabilities.patch

