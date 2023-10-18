Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54DFCDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjJRVoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344909AbjJRVn6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24003112
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B6AC433C9;
        Wed, 18 Oct 2023 21:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665435;
        bh=Te13HYMuNvpaPo/MafzgGqQQOEngFf77FThaUgKOOJ0=;
        h=Date:To:From:Subject:From;
        b=1og7fz70Ua03cWQbo5aRmcHQDfkid8cncbxosFZaS3rQ1mNVmQREJYCn/N4OJodR0
         63GUSz3iAnp0JjcBEJnRIcFLTiN8hdWv/6CKab+y+mYzaPaTBhQYTp/GTSvgwFwTsZ
         4aqUeFO1I3+8Amqcei3/LmCNQ2PdMPZ6AqQgx64k=
Date:   Wed, 18 Oct 2023 14:43:55 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        keescook@chromium.org, justinstitt@google.com, joe@perches.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-add-keywords-in-file-option.patch removed from -mm tree
Message-Id: <20231018214355.A0B6AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: get_maintainer: add --keywords-in-file option
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-keywords-in-file-option.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: add --keywords-in-file option
Date: Thu, 05 Oct 2023 14:35:17 -0700

There were some recent attempts [1] [2] to make the K: field less noisy
and its behavior more obvious.  Ultimately, a shift in the default
behavior and an associated command line flag is the best choice.

Currently, K: will match keywords found in both patches and files.

Matching content from entire files is (while documented) not obvious
behavior and is usually not wanted by maintainers.

Now only patch content will be matched against unless --keywords-in-file
is also provided as an argument to get_maintainer.

Add the actual keyword matched to the role or rolestats as well.

For instance given the diff below that removes clang:

:   diff --git a/drivers/hid/bpf/entrypoints/README b/drivers/hid/bpf/entrypoints/README
:    index 147e0d41509f..f88eb19e8ef2 100644
:    --- a/drivers/hid/bpf/entrypoints/README
:    +++ b/drivers/hid/bpf/entrypoints/README
:    @@ -1,4 +1,4 @@
:     WARNING:
:     If you change "entrypoints.bpf.c" do "make -j" in this directory to rebuild "entrypoints.skel.h".
:    -Make sure to have clang 10 installed.
:    +Make sure to have 10 installed.
:     See Documentation/bpf/bpf_devel_QA.rst

The new role/rolestats output includes ":Keyword:\b(?i:clang|llvm)\b"

$ git diff drivers/hid/bpf/entrypoints/README | .scripts/get_maintainer.pl
Jiri Kosina <jikos@kernel.org> (maintainer:HID CORE LAYER,commit_signer:1/1=100%)
Benjamin Tissoires <benjamin.tissoires@redhat.com> (maintainer:HID CORE LAYER,commit_signer:1/1=100%,authored:1/1=100%,added_lines:4/4=100%)
Nathan Chancellor <nathan@kernel.org> (supporter:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)
Nick Desaulniers <ndesaulniers@google.com> (supporter:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)
Tom Rix <trix@redhat.com> (reviewer:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:1/1=100%)
linux-input@vger.kernel.org (open list:HID CORE LAYER)
linux-kernel@vger.kernel.org (open list)
llvm@lists.linux.dev (open list:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)

Link: https://lore.kernel.org/r/20231004-get_maintainer_change_k-v1-1-ac7ced18306a@google.com
Link: https://lore.kernel.org/all/20230928-get_maintainer_add_d-v2-0-8acb3f394571@google.com
Link: https://lore.kernel.org/all/3dca40b677dd2fef979a5a581a2db91df2c21801.camel@perches.com
Original-patch-by: Justin Stitt <justinstitt@google.com>
Link: https://lkml.kernel.org/r/01fe46f0c58aa8baf92156ae2bdccfb2bf0cb48e.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   38 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-keywords-in-file-option
+++ a/scripts/get_maintainer.pl
@@ -57,6 +57,7 @@ my $subsystem = 0;
 my $status = 0;
 my $letters = "";
 my $keywords = 1;
+my $keywords_in_file = 0;
 my $sections = 0;
 my $email_file_emails = 0;
 my $from_filename = 0;
@@ -272,6 +273,7 @@ if (!GetOptions(
 		'letters=s' => \$letters,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'kf|keywords-in-file!' => \$keywords_in_file,
 		'sections!' => \$sections,
 		'fe|file-emails!' => \$email_file_emails,
 		'f|file' => \$from_filename,
@@ -318,6 +320,7 @@ if ($sections || $letters ne "") {
     $subsystem = 0;
     $web = 0;
     $keywords = 0;
+    $keywords_in_file = 0;
     $interactive = 0;
 } else {
     my $selections = $email + $scm + $status + $subsystem + $web;
@@ -548,16 +551,14 @@ foreach my $file (@ARGV) {
 	$file =~ s/^\Q${cur_path}\E//;	#strip any absolute path
 	$file =~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
 	push(@files, $file);
-	if ($file ne "MAINTAINERS" && -f $file && $keywords) {
+	if ($file ne "MAINTAINERS" && -f $file && $keywords && $keywords_in_file) {
 	    open(my $f, '<', $file)
 		or die "$P: Can't open $file: $!\n";
 	    my $text = do { local($/) ; <$f> };
 	    close($f);
-	    if ($keywords) {
-		foreach my $line (keys %keyword_hash) {
-		    if ($text =~ m/$keyword_hash{$line}/x) {
-			push(@keyword_tvi, $line);
-		    }
+	    foreach my $line (keys %keyword_hash) {
+		if ($text =~ m/$keyword_hash{$line}/x) {
+		    push(@keyword_tvi, $line);
 		}
 	    }
 	}
@@ -919,7 +920,7 @@ sub get_maintainers {
 	}
 
 	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	    add_categories($line);
+	    add_categories($line, "");
 	    if ($sections) {
 		my $i;
 		my $start = find_starting_index($line);
@@ -947,7 +948,7 @@ sub get_maintainers {
     if ($keywords) {
 	@keyword_tvi = sort_and_uniq(@keyword_tvi);
 	foreach my $line (@keyword_tvi) {
-	    add_categories($line);
+	    add_categories($line, ":Keyword:$keyword_hash{$line}");
 	}
     }
 
@@ -1076,6 +1077,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: $keywords)
+  --keywords-in-file => scan file for keywords (default: $keywords_in_file)
   --sections => print all of the subsystem sections with pattern matches
   --letters => print all matching 'letter' types from all matching sections
   --mailmap => use .mailmap file (default: $email_use_mailmap)
@@ -1086,7 +1088,7 @@ Other options:
 
 Default options:
   [--email --tree --nogit --git-fallback --m --r --n --l --multiline
-   --pattern-depth=0 --remove-duplicates --rolestats]
+   --pattern-depth=0 --remove-duplicates --rolestats --keywords]
 
 Notes:
   Using "-f directory" may give unexpected results:
@@ -1312,7 +1314,7 @@ sub get_list_role {
 }
 
 sub add_categories {
-    my ($index) = @_;
+    my ($index, $suffix) = @_;
 
     my $i;
     my $start = find_starting_index($index);
@@ -1342,7 +1344,7 @@ sub add_categories {
 			if (!$hash_list_to{lc($list_address)}) {
 			    $hash_list_to{lc($list_address)} = 1;
 			    push(@list_to, [$list_address,
-					    "subscriber list${list_role}"]);
+					    "subscriber list${list_role}" . $suffix]);
 			}
 		    }
 		} else {
@@ -1352,12 +1354,12 @@ sub add_categories {
 				if ($email_moderated_list) {
 				    $hash_list_to{lc($list_address)} = 1;
 				    push(@list_to, [$list_address,
-						    "moderated list${list_role}"]);
+						    "moderated list${list_role}" . $suffix]);
 				}
 			    } else {
 				$hash_list_to{lc($list_address)} = 1;
 				push(@list_to, [$list_address,
-						"open list${list_role}"]);
+						"open list${list_role}" . $suffix]);
 			    }
 			}
 		    }
@@ -1365,19 +1367,19 @@ sub add_categories {
 	    } elsif ($ptype eq "M") {
 		if ($email_maintainer) {
 		    my $role = get_maintainer_role($i);
-		    push_email_addresses($pvalue, $role);
+		    push_email_addresses($pvalue, $role . $suffix);
 		}
 	    } elsif ($ptype eq "R") {
 		if ($email_reviewer) {
 		    my $subsystem = get_subsystem_name($i);
-		    push_email_addresses($pvalue, "reviewer:$subsystem");
+		    push_email_addresses($pvalue, "reviewer:$subsystem" . $suffix);
 		}
 	    } elsif ($ptype eq "T") {
-		push(@scm, $pvalue);
+		push(@scm, $pvalue . $suffix);
 	    } elsif ($ptype eq "W") {
-		push(@web, $pvalue);
+		push(@web, $pvalue . $suffix);
 	    } elsif ($ptype eq "S") {
-		push(@status, $pvalue);
+		push(@status, $pvalue . $suffix);
 	    }
 	}
     }
_

Patches currently in -mm which might be from joe@perches.com are


