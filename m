From: akpm@linux-foundation.org
Subject: + modpost-add-flag-e-for-making-section-mismatches-fatal.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 15:24:56 -0700
Message-ID: <5612f8b8.Q2c6kgoAP0Yt/Wm7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbJEWY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 18:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drinkcat@chromium.org, mmarek@suse.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: modpost: add flag -E for making section mismatches fatal
has been added to the -mm tree.  Its filename is
     modpost-add-flag-e-for-making-section-mismatches-fatal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/modpost-add-flag-e-for-making-section-mismatches-fatal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/modpost-add-flag-e-for-making-section-mismatches-fatal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Boichat <drinkcat@chromium.org>
Subject: modpost: add flag -E for making section mismatches fatal

The section mismatch warning can be easy to miss during the kernel build
process.  Allow it to be marked as fatal to be easily caught and prevent
bugs from slipping in.

Setting CONFIG_SECTION_MISMATCH_WARN_ONLY=y causes these warnings to be
non-fatal, since there are a number of section mismatches when using
allmodconfig on some architectures, and we do not want to break these
builds by default.

Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug        |    9 +++++++++
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |   24 +++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff -puN lib/Kconfig.debug~modpost-add-flag-e-for-making-section-mismatches-fatal lib/Kconfig.debug
--- a/lib/Kconfig.debug~modpost-add-flag-e-for-making-section-mismatches-fatal
+++ a/lib/Kconfig.debug
@@ -311,6 +311,15 @@ config DEBUG_SECTION_MISMATCH
 	  - Enable verbose reporting from modpost in order to help resolve
 	    the section mismatches that are reported.
 
+config SECTION_MISMATCH_WARN_ONLY
+	bool "Make section mismatch errors non-fatal"
+	default y
+	help
+	  If you say N here, the build process will fail if there are any
+	  section mismatch, instead of just throwing warnings.
+
+	  If unsure, say Y.
+
 #
 # Select this config option from the architecture Kconfig, if it
 # is preferred to always offer frame pointers as a config
diff -puN scripts/Makefile.modpost~modpost-add-flag-e-for-making-section-mismatches-fatal scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~modpost-add-flag-e-for-making-section-mismatches-fatal
+++ a/scripts/Makefile.modpost
@@ -77,6 +77,7 @@ modpost = scripts/mod/modpost
  $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
+ $(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)  \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 MODPOST_OPT=$(subst -i,-n,$(filter -i,$(MAKEFLAGS)))
diff -puN scripts/mod/modpost.c~modpost-add-flag-e-for-making-section-mismatches-fatal scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-add-flag-e-for-making-section-mismatches-fatal
+++ a/scripts/mod/modpost.c
@@ -38,6 +38,7 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+static int sec_mismatch_fatal = 0;
 /* ignore missing files */
 static int ignore_missing_files;
 
@@ -2374,7 +2375,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:mnsST:o:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:mnsST:o:awM:K:E")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2415,6 +2416,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'E':
+			sec_mismatch_fatal = 1;
+			break;
 		default:
 			exit(1);
 		}
@@ -2464,14 +2468,20 @@ int main(int argc, char **argv)
 		sprintf(fname, "%s.mod.c", mod->name);
 		write_if_changed(&buf, fname);
 	}
-
 	if (dump_write)
 		write_dump(dump_write);
-	if (sec_mismatch_count && !sec_mismatch_verbose)
-		warn("modpost: Found %d section mismatch(es).\n"
-		     "To see full details build your kernel with:\n"
-		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
-		     sec_mismatch_count);
+	if (sec_mismatch_count) {
+		if (!sec_mismatch_verbose) {
+			warn("modpost: Found %d section mismatch(es).\n"
+			     "To see full details build your kernel with:\n"
+			     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
+			     sec_mismatch_count);
+		}
+		if (sec_mismatch_fatal) {
+			fatal("modpost: Section mismatches detected.\n"
+			      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
+		}
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from drinkcat@chromium.org are

modpost-add-flag-e-for-making-section-mismatches-fatal.patch

