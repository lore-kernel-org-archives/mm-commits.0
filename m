From: akpm@linux-foundation.org
Subject: + taskstats-fix-getdelays-usage-information.patch added to -mm tree
Date: Thu, 19 Apr 2007 15:14:51 -0700
Message-ID: <200704192214.l3JMEpiI032395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239AbXDSWPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 18:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, balbir@in.ibm.com


The patch titled
     Taskstats: fix getdelays usage information
has been added to the -mm tree.  Its filename is
     taskstats-fix-getdelays-usage-information.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Taskstats: fix getdelays usage information
From: Randy Dunlap <randy.dunlap@oracle.com>

Add usage to getdelays.c. This patch was originally posted by Randy Dunlap
http://lkml.org/lkml/2007/3/19/168

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~taskstats-fix-getdelays-usage-information Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~taskstats-fix-getdelays-usage-information
+++ a/Documentation/accounting/getdelays.c
@@ -72,6 +72,16 @@ struct msgtemplate {
 
 char cpumask[100+6*MAX_CPUS];
 
+static void usage(void)
+{
+	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] "
+			"[-m cpumask] [-t tgid] [-p pid]\n");
+	fprintf(stderr, "  -d: print delayacct stats\n");
+	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
+	fprintf(stderr, "  -l: listen forever\n");
+	fprintf(stderr, "  -v: debug on\n");
+}
+
 /*
  * Create a raw netlink socket and bind
  */
@@ -227,7 +237,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:v:l");
+		c = getopt(argc, argv, "diw:r:m:t:p:vl");
 		if (c < 0)
 			break;
 
@@ -277,7 +287,7 @@ int main(int argc, char *argv[])
 			loop = 1;
 			break;
 		default:
-			printf("Unknown option %d\n", c);
+			usage();
 			exit(-1);
 		}
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
