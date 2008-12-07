From: akpm@linux-foundation.org
Subject: - gen_init_cpio-expand-shell-variables-in-file-names.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:06:03 -0800
Message-ID: <200812070006.mB7063mu021754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbYLGAGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Gene.Sally@timesys.com, gene.sally@timesys.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gen_init_cpio: expand shell variables in file names
has been removed from the -mm tree.  Its filename was
     gen_init_cpio-expand-shell-variables-in-file-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gen_init_cpio: expand shell variables in file names
From: "Sally, Gene" <Gene.Sally@timesys.com>

This modifies gen_init_cpio so that lines that specify files can contain
what looks like a shell variable that's expanded during processing.

For example:

file /sbin/kinit ${RFS_BASE}/usr/src/klibc/kinit/kinit 0755 0 0

given RFS_BASE is "/some/directory" in the environment

would be expanded to

file /sbin/kinit /some/directory/usr/src/klibc/kinit/kinit 0755 0 0

If several environment variables appear in a line, they are all expanded
with processing happening from left to right.  Undefined variables expand
to a null string.  Syntax errors stop processing, letting the existing
error handling show the user offending line.

This helps embedded folks who frequently create several RFS directories
and then switch between them as they're tuning an initramfs.  Having just
been such an embedded folk, this seems the most efficient solution.

Signed-off-by: Gene Sally <gene.sally@timesys.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN usr/gen_init_cpio.c~gen_init_cpio-expand-shell-variables-in-file-names usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~gen_init_cpio-expand-shell-variables-in-file-names
+++ a/usr/gen_init_cpio.c
@@ -370,6 +370,30 @@ error:
 	return rc;
 }
 
+static char *cpio_replace_env(char *new_location)
+{
+       char expanded[PATH_MAX + 1];
+       char env_var[PATH_MAX + 1];
+       char *start;
+       char *end;
+
+       for (start = NULL; (start = strstr(new_location, "${")); ) {
+	       end = strchr(start, '}');
+	       if (start < end) {
+		       *env_var = *expanded = '\0';
+		       strncat(env_var, start + 2, end - start - 2);
+		       strncat(expanded, new_location, start - new_location);
+		       strncat(expanded, getenv(env_var), PATH_MAX);
+		       strncat(expanded, end + 1, PATH_MAX);
+		       strncpy(new_location, expanded, PATH_MAX);
+	       } else
+		       break;
+       }
+
+       return new_location;
+}
+
+
 static int cpio_mkfile_line(const char *line)
 {
 	char name[PATH_MAX + 1];
@@ -415,7 +439,8 @@ static int cpio_mkfile_line(const char *
 	} else {
 		dname = name;
 	}
-	rc = cpio_mkfile(dname, location, mode, uid, gid, nlinks);
+       rc = cpio_mkfile(dname, cpio_replace_env(location),
+			mode, uid, gid, nlinks);
  fail:
 	if (dname_len) free(dname);
 	return rc;
@@ -439,6 +464,7 @@ void usage(const char *prog)
 		"\n"
 		"<name>       name of the file/dir/nod/etc in the archive\n"
 		"<location>   location of the file in the current filesystem\n"
+		"             expands shell variables quoted with ${}\n"
 		"<target>     link target\n"
 		"<mode>       mode/permissions of the file\n"
 		"<uid>        user id (0=root)\n"
_

Patches currently in -mm which might be from Gene.Sally@timesys.com are

linux-next.patch

