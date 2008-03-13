From: akpm@linux-foundation.org
Subject: + ntfs-update-parse_options-with-filesystem-argument-parser.patch added to -mm tree
Date: Thu, 13 Mar 2008 12:47:23 -0700
Message-ID: <200803131947.m2DJlNrh029807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbYCMTsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com, aarapov@redhat.com, rdunlap@xenotime.net


The patch titled
     ntfs: update parse_options() with filesystem argument parser
has been added to the -mm tree.  Its filename is
     ntfs-update-parse_options-with-filesystem-argument-parser.patch

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
Subject: ntfs: update parse_options() with filesystem argument parser
From: Shen Feng <shen@cn.fujitsu.com>

The ntfs driver uses the macros defined by itself to parse the filesystem
argument.  This makes the code look ugly.  Change it by using the standard
filesystem argument parser.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Cc: Anton Arapov <aarapov@redhat.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/super.c |  342 +++++++++++++++++++++++++++-------------------
 1 file changed, 201 insertions(+), 141 deletions(-)

diff -puN fs/ntfs/super.c~ntfs-update-parse_options-with-filesystem-argument-parser fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-update-parse_options-with-filesystem-argument-parser
+++ a/fs/ntfs/super.c
@@ -31,6 +31,7 @@
 #include <linux/vfs.h>
 #include <linux/moduleparam.h>
 #include <linux/smp_lock.h>
+#include <linux/parser.h>
 
 #include "sysctl.h"
 #include "logfile.h"
@@ -69,24 +70,91 @@ const option_t on_errors_arr[] = {
 	{ 0,			NULL }
 };
 
-/**
- * simple_getbool -
- *
- * Copied from old ntfs driver (which copied from vfat driver).
- */
-static int simple_getbool(char *s, bool *setval)
-{
-	if (s) {
-		if (!strcmp(s, "1") || !strcmp(s, "yes") || !strcmp(s, "true"))
-			*setval = true;
-		else if (!strcmp(s, "0") || !strcmp(s, "no") ||
-							!strcmp(s, "false"))
-			*setval = false;
-		else
-			return 0;
-	} else
-		*setval = true;
-	return 1;
+enum {
+	Opt_uid, Opt_gid, Opt_umask, Opt_fmask, Opt_dmask,
+	Opt_mft_zone_multiplier, Opt_sloppy_no, Opt_sloppy_yes,
+	Opt_show_sys_files_no, Opt_show_sys_files_yes,
+	Opt_case_sensitive_no, Opt_case_sensitive_yes,
+	Opt_disable_sparse_no, Opt_disable_sparse_yes,
+	Opt_errors_panic, Opt_errors_remount_ro, Opt_errors_continue,
+	Opt_errors_recover, Opt_posix, Opt_show_inodes, Opt_nls,
+	Opt_iocharset, Opt_utf8_no, Opt_utf8_yes, Opt_err
+};
+
+static match_table_t tokens = {
+	{Opt_uid, "uid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_umask, "umask=%o"},
+	{Opt_fmask, "fmask=%o"},
+	{Opt_dmask, "dmask=%o"},
+	{Opt_mft_zone_multiplier, "mft_zone_multiplier=%u"},
+	{Opt_sloppy_no, "sloppy=0"},
+	{Opt_sloppy_no, "sloppy=no"},
+	{Opt_sloppy_no, "sloppy=false"},
+	{Opt_sloppy_yes, "sloppy=1"},
+	{Opt_sloppy_yes, "sloppy=yes"},
+	{Opt_sloppy_yes, "sloppy=true"},
+	{Opt_show_sys_files_no, "show_sys_files=0"},
+	{Opt_show_sys_files_no, "show_sys_files=no"},
+	{Opt_show_sys_files_no, "show_sys_files=false"},
+	{Opt_show_sys_files_yes, "show_sys_files=1"},
+	{Opt_show_sys_files_yes, "show_sys_files=yes"},
+	{Opt_show_sys_files_yes, "show_sys_files=true"},
+	{Opt_case_sensitive_no, "case_sensitive=0"},
+	{Opt_case_sensitive_no, "case_sensitive=no"},
+	{Opt_case_sensitive_no, "case_sensitive=false"},
+	{Opt_case_sensitive_yes, "case_sensitive=1"},
+	{Opt_case_sensitive_yes, "case_sensitive=yes"},
+	{Opt_case_sensitive_yes, "case_sensitive=true"},
+	{Opt_disable_sparse_no, "disable_sparse=0"},
+	{Opt_disable_sparse_no, "disable_sparse=no"},
+	{Opt_disable_sparse_no, "disable_sparse=false"},
+	{Opt_disable_sparse_yes, "disable_sparse=1"},
+	{Opt_disable_sparse_yes, "disable_sparse=yes"},
+	{Opt_disable_sparse_yes, "disable_sparse=true"},
+	{Opt_errors_panic, "errors=panic"},
+	{Opt_errors_remount_ro, "errors=remount-ro"},
+	{Opt_errors_continue, "errors=continue"},
+	{Opt_errors_recover, "errors=recover"},
+	{Opt_posix, "posix=%s"},             /*obsolete*/
+	{Opt_show_inodes, "show_inodes=%s"}, /*obsolete*/
+	{Opt_nls, "nls=%s"},
+	{Opt_iocharset, "iocharset=%s"},     /*Deprecated*/
+	{Opt_utf8_no, "utf8=0"},             /*no longer supported*/
+	{Opt_utf8_no, "utf8=no"},
+	{Opt_utf8_no, "utf8=false"},
+	{Opt_utf8_yes, "utf8=1"},
+	{Opt_utf8_yes, "utf8=yes"},
+	{Opt_utf8_yes, "utf8=true"},
+	{Opt_utf8_yes, "utf8"},
+	{Opt_err, NULL}
+};
+
+ /**
+  * load_nls_ntfs - load the nls map
+  * @vol:    ntfs volume
+  * @nls_name:    nls name
+  *
+  * Load the nls map which name is @nls_name. If load failed and the @vol has
+  * load the nls map before, use the old nls map.
+  */
+static struct nls_table *load_nls_ntfs(ntfs_volume *vol, char *nls_name)
+{
+	struct nls_table *nls_map = NULL, *old_nls = vol->nls_map;
+
+	nls_map = load_nls(nls_name);
+	if (!nls_map) {
+		if (!old_nls) {
+			ntfs_error(vol->sb, "NLS character set "
+				"%s not found.", nls_name);
+			return NULL;
+		}
+	ntfs_error(vol->sb, "NLS character set %s not "
+		"found. Using previous one %s.",
+		nls_name, old_nls->charset);
+	nls_map = old_nls;
+	}
+	return nls_map;
 }
 
 /**
@@ -98,136 +166,137 @@ static int simple_getbool(char *s, bool 
  */
 static bool parse_options(ntfs_volume *vol, char *opt)
 {
-	char *p, *v, *ov;
+	char *p, *v;
 	static char *utf8 = "utf8";
-	int errors = 0, sloppy = 0;
+	int errors = 0, sloppy = 0, mask = -1;
 	uid_t uid = (uid_t)-1;
 	gid_t gid = (gid_t)-1;
 	mode_t fmask = (mode_t)-1, dmask = (mode_t)-1;
 	int mft_zone_multiplier = -1, on_errors = -1;
 	int show_sys_files = -1, case_sensitive = -1, disable_sparse = -1;
-	struct nls_table *nls_map = NULL, *old_nls;
+	struct nls_table *nls_map = NULL;
+	substring_t args[MAX_OPT_ARGS];
+	int token;
 
-	/* I am lazy... (-8 */
-#define NTFS_GETOPT_WITH_DEFAULT(option, variable, default_value)	\
-	if (!strcmp(p, option)) {					\
-		if (!v || !*v)						\
-			variable = default_value;			\
-		else {							\
-			variable = simple_strtoul(ov = v, &v, 0);	\
-			if (*v)						\
-				goto needs_val;				\
-		}							\
-	}
-#define NTFS_GETOPT(option, variable)					\
-	if (!strcmp(p, option)) {					\
-		if (!v || !*v)						\
-			goto needs_arg;					\
-		variable = simple_strtoul(ov = v, &v, 0);		\
-		if (*v)							\
-			goto needs_val;					\
-	}
-#define NTFS_GETOPT_OCTAL(option, variable)				\
-	if (!strcmp(p, option)) {					\
-		if (!v || !*v)						\
-			goto needs_arg;					\
-		variable = simple_strtoul(ov = v, &v, 8);		\
-		if (*v)							\
-			goto needs_val;					\
-	}
-#define NTFS_GETOPT_BOOL(option, variable)				\
-	if (!strcmp(p, option)) {					\
-		bool val;						\
-		if (!simple_getbool(v, &val))				\
-			goto needs_bool;				\
-		variable = val;						\
-	}
-#define NTFS_GETOPT_OPTIONS_ARRAY(option, variable, opt_array)		\
-	if (!strcmp(p, option)) {					\
-		int _i;							\
-		if (!v || !*v)						\
-			goto needs_arg;					\
-		ov = v;							\
-		if (variable == -1)					\
-			variable = 0;					\
-		for (_i = 0; opt_array[_i].str && *opt_array[_i].str; _i++) \
-			if (!strcmp(opt_array[_i].str, v)) {		\
-				variable |= opt_array[_i].val;		\
-				break;					\
-			}						\
-		if (!opt_array[_i].str || !*opt_array[_i].str)		\
-			goto needs_val;					\
-	}
 	if (!opt || !*opt)
 		goto no_mount_options;
 	ntfs_debug("Entering with mount options string: %s", opt);
 	while ((p = strsep(&opt, ","))) {
-		if ((v = strchr(p, '=')))
-			*v++ = 0;
-		NTFS_GETOPT("uid", uid)
-		else NTFS_GETOPT("gid", gid)
-		else NTFS_GETOPT_OCTAL("umask", fmask = dmask)
-		else NTFS_GETOPT_OCTAL("fmask", fmask)
-		else NTFS_GETOPT_OCTAL("dmask", dmask)
-		else NTFS_GETOPT("mft_zone_multiplier", mft_zone_multiplier)
-		else NTFS_GETOPT_WITH_DEFAULT("sloppy", sloppy, true)
-		else NTFS_GETOPT_BOOL("show_sys_files", show_sys_files)
-		else NTFS_GETOPT_BOOL("case_sensitive", case_sensitive)
-		else NTFS_GETOPT_BOOL("disable_sparse", disable_sparse)
-		else NTFS_GETOPT_OPTIONS_ARRAY("errors", on_errors,
-				on_errors_arr)
-		else if (!strcmp(p, "posix") || !strcmp(p, "show_inodes"))
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_uid:
+			if (match_int(&args[0], &uid))
+				return false;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &gid))
+				return false;
+			break;
+		case Opt_umask:
+			if (match_octal(&args[0], &mask))
+				return false;
+			dmask = fmask = (mode_t)mask;
+			break;
+		case Opt_fmask:
+			if (match_octal(&args[0], &mask))
+				return false;
+			fmask = (mode_t)mask;
+			break;
+		case Opt_dmask:
+			if (match_octal(&args[0], &mask))
+				return false;
+			dmask = (mode_t)mask;
+			break;
+		case Opt_mft_zone_multiplier:
+			if (match_int(&args[0], &mft_zone_multiplier))
+				return false;
+			break;
+		case Opt_sloppy_no:
+			sloppy = false;
+			break;
+		case Opt_sloppy_yes:
+			sloppy = true;
+			break;
+		case Opt_show_sys_files_no:
+			show_sys_files = false;
+			break;
+		case Opt_show_sys_files_yes:
+			show_sys_files = true;
+			break;
+		case Opt_case_sensitive_no:
+			case_sensitive = false;
+			break;
+		case Opt_case_sensitive_yes:
+			case_sensitive = true;
+			break;
+		case Opt_disable_sparse_no:
+			disable_sparse = false;
+			break;
+		case Opt_disable_sparse_yes:
+			disable_sparse = true;
+			break;
+		case Opt_errors_panic:
+			if (on_errors == -1)
+				on_errors = ON_ERRORS_PANIC;
+			else
+				on_errors |= ON_ERRORS_PANIC;
+			break;
+		case Opt_errors_remount_ro:
+			if (on_errors == -1)
+				on_errors = ON_ERRORS_REMOUNT_RO;
+			else
+				on_errors |= ON_ERRORS_REMOUNT_RO;
+			break;
+		case Opt_errors_continue:
+			if (on_errors == -1)
+				on_errors = ON_ERRORS_CONTINUE;
+			else
+				on_errors |= ON_ERRORS_CONTINUE;
+			break;
+		case Opt_errors_recover:
+			if (on_errors == -1)
+				on_errors = ON_ERRORS_RECOVER;
+			else
+				on_errors |= ON_ERRORS_RECOVER;
+			break;
+		case Opt_posix:
+		case Opt_show_inodes:
 			ntfs_warning(vol->sb, "Ignoring obsolete option %s.",
-					p);
-		else if (!strcmp(p, "nls") || !strcmp(p, "iocharset")) {
-			if (!strcmp(p, "iocharset"))
-				ntfs_warning(vol->sb, "Option iocharset is "
-						"deprecated. Please use "
-						"option nls=<charsetname> in "
-						"the future.");
-			if (!v || !*v)
-				goto needs_arg;
-use_utf8:
-			old_nls = nls_map;
-			nls_map = load_nls(v);
-			if (!nls_map) {
-				if (!old_nls) {
-					ntfs_error(vol->sb, "NLS character set "
-							"%s not found.", v);
-					return false;
-				}
-				ntfs_error(vol->sb, "NLS character set %s not "
-						"found. Using previous one %s.",
-						v, old_nls->charset);
-				nls_map = old_nls;
-			} else /* nls_map */ {
-				if (old_nls)
-					unload_nls(old_nls);
-			}
-		} else if (!strcmp(p, "utf8")) {
-			bool val = false;
+				     p);
+			break;
+		case Opt_iocharset:
+			ntfs_warning(vol->sb, "Option iocharset is "
+				     "deprecated. Please use "
+				     "option nls=<charsetname> in "
+				     "the future.");
+		case Opt_nls:
+			v = match_strdup(&args[0]);
+			if (!v)
+				return false;
+			nls_map = load_nls_ntfs(vol, v);
+			kfree(v);
+			break;
+		case Opt_utf8_yes:
+		case Opt_utf8_no:
 			ntfs_warning(vol->sb, "Option utf8 is no longer "
-				   "supported, using option nls=utf8. Please "
-				   "use option nls=utf8 in the future and "
-				   "make sure utf8 is compiled either as a "
-				   "module or into the kernel.");
-			if (!v || !*v)
-				val = true;
-			else if (!simple_getbool(v, &val))
-				goto needs_bool;
-			if (val) {
-				v = utf8;
-				goto use_utf8;
-			}
-		} else {
-			ntfs_error(vol->sb, "Unrecognized mount option %s.", p);
+				     "supported, using option nls=utf8. Please "
+				     "use option nls=utf8 in the future and "
+				     "make sure utf8 is compiled either as a "
+				     "module or into the kernel.");
+			if (token == Opt_utf8_no)
+				break;
+			nls_map = load_nls_ntfs(vol, utf8);
+			break;
+		default: /* Opt_err */
+			ntfs_error(vol->sb, "Unrecognized or incorrect "
+				   "mount option %s.", p);
 			if (errors < INT_MAX)
 				errors++;
+			break;
 		}
-#undef NTFS_GETOPT_OPTIONS_ARRAY
-#undef NTFS_GETOPT_BOOL
-#undef NTFS_GETOPT
-#undef NTFS_GETOPT_WITH_DEFAULT
 	}
 no_mount_options:
 	if (errors && !sloppy)
@@ -319,15 +388,6 @@ no_mount_options:
 		}
 	}
 	return true;
-needs_arg:
-	ntfs_error(vol->sb, "The %s option requires an argument.", p);
-	return false;
-needs_bool:
-	ntfs_error(vol->sb, "The %s option requires a boolean argument.", p);
-	return false;
-needs_val:
-	ntfs_error(vol->sb, "Invalid %s option argument: %s", p, ov);
-	return false;
 }
 
 #ifdef NTFS_RW
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

ntfs-update-parse_options-with-filesystem-argument-parser.patch

