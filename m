From: akpm@linux-foundation.org
Subject: + ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:56:55 -0800
Message-ID: <200801312356.m0VNut6G017874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbYAaX5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bjorn.helgaas@hp.com, tony.luck@intel.com


The patch titled
     ia64 aliasing-test: fix gcc warnings on non-ia64
has been added to the -mm tree.  Its filename is
     ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch

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
Subject: ia64 aliasing-test: fix gcc warnings on non-ia64
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate all build warnings.  OK, these build warnings are from
a build on x86_64.  When I build on ia64, I don't see warnings.

Now builds cleanly on ia64 and x86_64.

Documentation/ia64/aliasing-test.c: In function 'map_mem':
Documentation/ia64/aliasing-test.c:39: warning: implicit declaration of function 'ioctl'
Documentation/ia64/aliasing-test.c: In function 'scan_rom':
Documentation/ia64/aliasing-test.c:183: warning: format '%ld' expects type 'long int', but argument 4 has type 'int'
Documentation/ia64/aliasing-test.c: At top level:
Documentation/ia64/aliasing-test.c:208: warning: function declaration isn't a prototype
Documentation/ia64/aliasing-test.c: In function 'main':
Documentation/ia64/aliasing-test.c:259: warning: control reaches end of non-void function
Documentation/ia64/aliasing-test.c: In function 'scan_rom':
Documentation/ia64/aliasing-test.c:152: warning: 'rc' may be used uninitialized in this function
Documentation/ia64/aliasing-test.c: In function 'scan_tree':
Documentation/ia64/aliasing-test.c:68: warning: 'rc' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ia64/aliasing-test.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN Documentation/ia64/aliasing-test.c~ia64-aliasing-test-fix-gcc-warnings-on-non-ia64 Documentation/ia64/aliasing-test.c
--- a/Documentation/ia64/aliasing-test.c~ia64-aliasing-test-fix-gcc-warnings-on-non-ia64
+++ a/Documentation/ia64/aliasing-test.c
@@ -16,6 +16,7 @@
 #include <fcntl.h>
 #include <fnmatch.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <unistd.h>
@@ -65,7 +66,7 @@ int scan_tree(char *path, char *file, of
 {
 	struct dirent **namelist;
 	char *name, *path2;
-	int i, n, r, rc, result = 0;
+	int i, n, r, rc = 0, result = 0;
 	struct stat buf;
 
 	n = scandir(path, &namelist, 0, alphasort);
@@ -113,7 +114,7 @@ skip:
 		free(namelist[i]);
 	}
 	free(namelist);
-	return rc;
+	return result;
 }
 
 char buf[1024];
@@ -149,7 +150,7 @@ int scan_rom(char *path, char *file)
 {
 	struct dirent **namelist;
 	char *name, *path2;
-	int i, n, r, rc, result = 0;
+	int i, n, r, rc = 0, result = 0;
 	struct stat buf;
 
 	n = scandir(path, &namelist, 0, alphasort);
@@ -180,7 +181,7 @@ int scan_rom(char *path, char *file)
 			 * important thing is that no MCA happened.
 			 */
 			if (rc > 0)
-				fprintf(stderr, "PASS: %s read %ld bytes\n", path2, rc);
+				fprintf(stderr, "PASS: %s read %d bytes\n", path2, rc);
 			else {
 				fprintf(stderr, "PASS: %s not readable\n", path2);
 				return rc;
@@ -201,10 +202,10 @@ skip:
 		free(namelist[i]);
 	}
 	free(namelist);
-	return rc;
+	return result;
 }
 
-int main()
+int main(void)
 {
 	int rc;
 
@@ -256,4 +257,6 @@ int main()
 	scan_tree("/proc/bus/pci", "??.?", 0xA0000, 0x20000, 0);
 	scan_tree("/proc/bus/pci", "??.?", 0xC0000, 0x40000, 1);
 	scan_tree("/proc/bus/pci", "??.?", 0, 1024*1024, 0);
+
+	return rc;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
