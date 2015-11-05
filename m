From: akpm@linux-foundation.org
Subject: + get_maintainer-add-subsystem-to-reviewer-output.patch added to
 -mm tree
Date: Thu, 05 Nov 2015 03:07:10 -0800
Message-ID: <563b385e.t6RBI9ta+/kFAkjq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032225AbbKELHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 06:07:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, k.kozlowski@samsung.com, lee.jones@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add subsystem to reviewer output
has been added to the -mm tree.  Its filename is
     get_maintainer-add-subsystem-to-reviewer-output.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-add-subsystem-to-reviewer-output.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-add-subsystem-to-reviewer-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: add subsystem to reviewer output

Reviewer output currently does not include the subsystem
that matched.  Add it.

Miscellanea:

o Add a get_subsystem_name routine to centralize this

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-add-subsystem-to-reviewer-output scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-add-subsystem-to-reviewer-output
+++ a/scripts/get_maintainer.pl
@@ -974,20 +974,29 @@ sub find_ending_index {
     return $index;
 }
 
-sub get_maintainer_role {
+sub get_subsystem_name {
     my ($index) = @_;
 
-    my $i;
     my $start = find_starting_index($index);
-    my $end = find_ending_index($index);
 
-    my $role = "unknown";
     my $subsystem = $typevalue[$start];
     if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
 	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
 	$subsystem =~ s/\s*$//;
 	$subsystem = $subsystem . "...";
     }
+    return $subsystem;
+}
+
+sub get_maintainer_role {
+    my ($index) = @_;
+
+    my $i;
+    my $start = find_starting_index($index);
+    my $end = find_ending_index($index);
+
+    my $role = "unknown";
+    my $subsystem = get_subsystem_name($index);
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
@@ -1021,16 +1030,7 @@ sub get_maintainer_role {
 sub get_list_role {
     my ($index) = @_;
 
-    my $i;
-    my $start = find_starting_index($index);
-    my $end = find_ending_index($index);
-
-    my $subsystem = $typevalue[$start];
-    if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
-	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
-	$subsystem =~ s/\s*$//;
-	$subsystem = $subsystem . "...";
-    }
+    my $subsystem = get_subsystem_name($index);
 
     if ($subsystem eq "THE REST") {
 	$subsystem = "";
@@ -1118,7 +1118,8 @@ sub add_categories {
 		    }
 		}
 		if ($email_reviewer) {
-		    push_email_addresses($pvalue, 'reviewer');
+		    my $subsystem = get_subsystem_name($i);
+		    push_email_addresses($pvalue, "reviewer:$subsystem");
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-add-subsystem-to-reviewer-output.patch
checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log.patch
checkpatch-improve-the-unnecessary-initialisers-tests.patch

