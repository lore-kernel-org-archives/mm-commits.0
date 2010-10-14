From: akpm@linux-foundation.org
Subject: + scripts-namespacepl-some-bug-fixes.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:56:34 -0700
Message-ID: <201010142256.o9EMuYo8024302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab0JNW5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, mmarek@suse.cz, shemminger@vyatta.com


The patch titled
     scripts/namespace.pl: some bug fixes
has been added to the -mm tree.  Its filename is
     scripts-namespacepl-some-bug-fixes.patch

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
Subject: scripts/namespace.pl: some bug fixes
From: Amerigo Wang <amwang@redhat.com>

1. Teach namespace.pl to understand "V" and "v"
2. cond_syscalls are moved into kernel/sys_ni.c

Signed-off-by: Amerigo Wang <amwang@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN scripts/namespace.pl~scripts-namespacepl-some-bug-fixes scripts/namespace.pl
--- a/scripts/namespace.pl~scripts-namespacepl-some-bug-fixes
+++ a/scripts/namespace.pl
@@ -266,6 +266,7 @@ sub do_nm
 		# T global label/procedure
 		# U external reference
 		# W weak external reference to text that has been resolved
+		# V similar to W, but the value of the weak symbol becomes zero with no error.
 		# a assembler equate
 		# b static variable, uninitialised
 		# d static variable, initialised
@@ -274,8 +275,9 @@ sub do_nm
 		# s static variable, uninitialised, small bss
 		# t static label/procedures
 		# w weak external reference to text that has not been resolved
+		# v similar to w
 		# ? undefined type, used a lot by modules
-		if ($type !~ /^[ABCDGRSTUWabdgrstw?]$/) {
+		if ($type !~ /^[ABCDGRSTUWVabdgrstwv?]$/) {
 			printf STDERR "nm output for $fullname contains unknown type '$_'\n";
 		}
 		elsif ($name =~ /\./) {
@@ -286,7 +288,7 @@ sub do_nm
 			# binutils keeps changing the type for exported symbols, force it to R
 			$type = 'R' if ($name =~ /^__ksymtab/ || $name =~ /^__kstrtab/);
 			$name =~ s/_R[a-f0-9]{8}$//;	# module versions adds this
-			if ($type =~ /[ABCDGRSTW]/ &&
+			if ($type =~ /[ABCDGRSTWV]/ &&
 				$name ne 'init_module' &&
 				$name ne 'cleanup_module' &&
 				$name ne 'Using_Versions' &&
@@ -353,11 +355,12 @@ sub list_multiply_defined
 	foreach my $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
-			if ($#{$def{$name}} == 1 && $name =~ /^sys_/ &&
-			    ($def{$name}[0] eq "kernel/sys.o" ||
-			     $def{$name}[1] eq "kernel/sys.o")) {
-				&drop_def("kernel/sys.o", $name);
-				next;
+			if ($#{$def{$name}} == 1 && $name =~ /^sys_/) {
+				if($def{$name}[0] eq "kernel/sys_ni.o" ||
+				   $def{$name}[1] eq "kernel/sys_ni.o") {
+					&drop_def("kernel/sys_ni.o", $name);
+					next;
+				}
 			}
 			# Special case for i386 entry code
 			if ($#{$def{$name}} == 1 && $name =~ /^__kernel_/ &&
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
scripts-namespacepl-fix-wrong-source-path.patch
scripts-namespacepl-update-file-exclusion-list.patch
scripts-namespacepl-some-bug-fixes.patch
scripts-namespacepl-improve-to-get-more-correct-results.patch
scripts-namespacepl-add-source-file-location-exceptions.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch

