From: akpm@linux-foundation.org
Subject: [merged]
 get_maintainer-fix-perl-522-524-deprecated-incompatible-c-use.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:42 -0700
Message-ID: <5591aeee.iqt+Tnv7Sfhoyh38%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbbF2Urm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: fix perl 5.22/5.24 deprecated/incompatible "\C" use
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-perl-522-524-deprecated-incompatible-c-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: fix perl 5.22/5.24 deprecated/incompatible "\C" use

Perl 5.22 emits a deprecated message when "\C" is used in a regex.  Perl
5.24 will disallow it altogether.

Fix it by using [A-Z] instead of \C.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-fix-perl-522-524-deprecated-incompatible-c-use scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-fix-perl-522-524-deprecated-incompatible-c-use
+++ a/scripts/get_maintainer.pl
@@ -305,7 +305,7 @@ open (my $maint, '<', "${lk_path}MAINTAI
 while (<$maint>) {
     my $line = $_;
 
-    if ($line =~ m/^(\C):\s*(.*)/) {
+    if ($line =~ m/^([A-Z]):\s*(.*)/) {
 	my $type = $1;
 	my $value = $2;
 
@@ -550,7 +550,7 @@ sub range_is_maintained {
 
     for (my $i = $start; $i < $end; $i++) {
 	my $line = $typevalue[$i];
-	if ($line =~ m/^(\C):\s*(.*)/) {
+	if ($line =~ m/^([A-Z]):\s*(.*)/) {
 	    my $type = $1;
 	    my $value = $2;
 	    if ($type eq 'S') {
@@ -568,7 +568,7 @@ sub range_has_maintainer {
 
     for (my $i = $start; $i < $end; $i++) {
 	my $line = $typevalue[$i];
-	if ($line =~ m/^(\C):\s*(.*)/) {
+	if ($line =~ m/^([A-Z]):\s*(.*)/) {
 	    my $type = $1;
 	    my $value = $2;
 	    if ($type eq 'M') {
@@ -617,7 +617,7 @@ sub get_maintainers {
 
 	    for ($i = $start; $i < $end; $i++) {
 		my $line = $typevalue[$i];
-		if ($line =~ m/^(\C):\s*(.*)/) {
+		if ($line =~ m/^([A-Z]):\s*(.*)/) {
 		    my $type = $1;
 		    my $value = $2;
 		    if ($type eq 'X') {
@@ -632,7 +632,7 @@ sub get_maintainers {
 	    if (!$exclude) {
 		for ($i = $start; $i < $end; $i++) {
 		    my $line = $typevalue[$i];
-		    if ($line =~ m/^(\C):\s*(.*)/) {
+		    if ($line =~ m/^([A-Z]):\s*(.*)/) {
 			my $type = $1;
 			my $value = $2;
 			if ($type eq 'F') {
@@ -933,7 +933,7 @@ sub find_first_section {
 
     while ($index < @typevalue) {
 	my $tv = $typevalue[$index];
-	if (($tv =~ m/^(\C):\s*(.*)/)) {
+	if (($tv =~ m/^([A-Z]):\s*(.*)/)) {
 	    last;
 	}
 	$index++;
@@ -947,7 +947,7 @@ sub find_starting_index {
 
     while ($index > 0) {
 	my $tv = $typevalue[$index];
-	if (!($tv =~ m/^(\C):\s*(.*)/)) {
+	if (!($tv =~ m/^([A-Z]):\s*(.*)/)) {
 	    last;
 	}
 	$index--;
@@ -961,7 +961,7 @@ sub find_ending_index {
 
     while ($index < @typevalue) {
 	my $tv = $typevalue[$index];
-	if (!($tv =~ m/^(\C):\s*(.*)/)) {
+	if (!($tv =~ m/^([A-Z]):\s*(.*)/)) {
 	    last;
 	}
 	$index++;
@@ -987,7 +987,7 @@ sub get_maintainer_role {
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
-	if ($tv =~ m/^(\C):\s*(.*)/) {
+	if ($tv =~ m/^([A-Z]):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "S") {
@@ -1046,7 +1046,7 @@ sub add_categories {
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
-	if ($tv =~ m/^(\C):\s*(.*)/) {
+	if ($tv =~ m/^([A-Z]):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "L") {
@@ -1088,7 +1088,7 @@ sub add_categories {
 		if ($name eq "") {
 		    if ($i > 0) {
 			my $tv = $typevalue[$i - 1];
-			if ($tv =~ m/^(\C):\s*(.*)/) {
+			if ($tv =~ m/^([A-Z]):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name = $2;
 				$pvalue = format_email($name, $address, $email_usename);
@@ -1105,7 +1105,7 @@ sub add_categories {
 		if ($name eq "") {
 		    if ($i > 0) {
 			my $tv = $typevalue[$i - 1];
-			if ($tv =~ m/^(\C):\s*(.*)/) {
+			if ($tv =~ m/^([A-Z]):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name = $2;
 				$pvalue = format_email($name, $address, $email_usename);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

