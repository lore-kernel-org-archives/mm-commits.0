From: akpm@linux-foundation.org
Subject: - taskstats-fix-getdelays-usage-information.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:24 -0700
Message-ID: <200705090250.l492oOV2009349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969964AbXEICuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, balbir@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Taskstats: fix getdelays usage information
has been removed from the -mm tree.  Its filename was
     taskstats-fix-getdelays-usage-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 12 insertions(+), 2 deletions(-)

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
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
