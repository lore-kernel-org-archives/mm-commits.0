From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:53 -0700
Message-ID: <201010052109.o95L9r2E020211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab0JEVK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: correct indentation in a few places
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch

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
Subject: scripts/get_maintainer.pl: correct indentation in a few places
From: Joe Perches <joe@perches.com>

And a miscellaneous conversion of You to you in a help message

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  156 ++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 78 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-correct-indentation-in-a-few-places scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-correct-indentation-in-a-few-places
+++ a/scripts/get_maintainer.pl
@@ -306,7 +306,7 @@ sub read_mailmap {
     my $mailmap = {
 	names => {},
 	addresses => {}
-   };
+    };
 
     if (!$email_remove_duplicates) {
 	return $mailmap;
@@ -327,39 +327,39 @@ sub read_mailmap {
 	# name1 <mail1> name2 <mail2>
 	# (see man git-shortlog)
 	if (/^(.+)<(.+)>$/) {
-		my $real_name = $1;
-		my $address = $2;
+	    my $real_name = $1;
+	    my $address = $2;
 
-		$real_name =~ s/\s+$//;
-		$mailmap->{names}->{$address} = $real_name;
+	    $real_name =~ s/\s+$//;
+	    $mailmap->{names}->{$address} = $real_name;
 
 	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
-		my $real_address = $1;
-		my $wrong_address = $2;
+	    my $real_address = $1;
+	    my $wrong_address = $2;
 
-		$mailmap->{addresses}->{$wrong_address} = $real_address;
+	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
 	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
-		my $real_name= $1;
-		my $real_address = $2;
-		my $wrong_address = $3;
+	    my $real_name= $1;
+	    my $real_address = $2;
+	    my $wrong_address = $3;
 
-		$real_name =~ s/\s+$//;
+	    $real_name =~ s/\s+$//;
 
-		$mailmap->{names}->{$wrong_address} = $real_name;
-		$mailmap->{addresses}->{$wrong_address} = $real_address;
+	    $mailmap->{names}->{$wrong_address} = $real_name;
+	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
 	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
-		my $real_name = $1;
-		my $real_address = $2;
-		my $wrong_name = $3;
-		my $wrong_address = $4;
+	    my $real_name = $1;
+	    my $real_address = $2;
+	    my $wrong_name = $3;
+	    my $wrong_address = $4;
 
-		$real_name =~ s/\s+$//;
-		$wrong_name =~ s/\s+$//;
+	    $real_name =~ s/\s+$//;
+	    $wrong_name =~ s/\s+$//;
 
-		$mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
-		$mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
+	    $mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
+	    $mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
 	}
     }
     close($mailmap_file);
@@ -743,30 +743,30 @@ EOT
 }
 
 sub top_of_kernel_tree {
-	my ($lk_path) = @_;
+    my ($lk_path) = @_;
 
-	if ($lk_path ne "" && substr($lk_path,length($lk_path)-1,1) ne "/") {
-	    $lk_path .= "/";
-	}
-	if (   (-f "${lk_path}COPYING")
-	    && (-f "${lk_path}CREDITS")
-	    && (-f "${lk_path}Kbuild")
-	    && (-f "${lk_path}MAINTAINERS")
-	    && (-f "${lk_path}Makefile")
-	    && (-f "${lk_path}README")
-	    && (-d "${lk_path}Documentation")
-	    && (-d "${lk_path}arch")
-	    && (-d "${lk_path}include")
-	    && (-d "${lk_path}drivers")
-	    && (-d "${lk_path}fs")
-	    && (-d "${lk_path}init")
-	    && (-d "${lk_path}ipc")
-	    && (-d "${lk_path}kernel")
-	    && (-d "${lk_path}lib")
-	    && (-d "${lk_path}scripts")) {
-		return 1;
-	}
-	return 0;
+    if ($lk_path ne "" && substr($lk_path,length($lk_path)-1,1) ne "/") {
+	$lk_path .= "/";
+    }
+    if (   (-f "${lk_path}COPYING")
+	&& (-f "${lk_path}CREDITS")
+	&& (-f "${lk_path}Kbuild")
+	&& (-f "${lk_path}MAINTAINERS")
+	&& (-f "${lk_path}Makefile")
+	&& (-f "${lk_path}README")
+	&& (-d "${lk_path}Documentation")
+	&& (-d "${lk_path}arch")
+	&& (-d "${lk_path}include")
+	&& (-d "${lk_path}drivers")
+	&& (-d "${lk_path}fs")
+	&& (-d "${lk_path}init")
+	&& (-d "${lk_path}ipc")
+	&& (-d "${lk_path}kernel")
+	&& (-d "${lk_path}lib")
+	&& (-d "${lk_path}scripts")) {
+	return 1;
+    }
+    return 0;
 }
 
 sub parse_email {
@@ -1107,29 +1107,30 @@ sub which_conf {
 }
 
 sub mailmap_email {
-	my $line = shift;
+    my $line = shift;
 
-	my ($name, $address) = parse_email($line);
-	my $email = format_email($name, $address, 1);
-	my $real_name = $name;
-	my $real_address = $address;
-
-	if (exists $mailmap->{names}->{$email} || exists $mailmap->{addresses}->{$email}) {
-		if (exists $mailmap->{names}->{$email}) {
-			$real_name = $mailmap->{names}->{$email};
-		}
-		if (exists $mailmap->{addresses}->{$email}) {
-			$real_address = $mailmap->{addresses}->{$email};
-		}
-	} else {
-		if (exists $mailmap->{names}->{$address}) {
-			$real_name = $mailmap->{names}->{$address};
-		}
-		if (exists $mailmap->{addresses}->{$address}) {
-			$real_address = $mailmap->{addresses}->{$address};
-		}
+    my ($name, $address) = parse_email($line);
+    my $email = format_email($name, $address, 1);
+    my $real_name = $name;
+    my $real_address = $address;
+
+    if (exists $mailmap->{names}->{$email} ||
+	exists $mailmap->{addresses}->{$email}) {
+	if (exists $mailmap->{names}->{$email}) {
+	    $real_name = $mailmap->{names}->{$email};
+	}
+	if (exists $mailmap->{addresses}->{$email}) {
+	    $real_address = $mailmap->{addresses}->{$email};
+	}
+    } else {
+	if (exists $mailmap->{names}->{$address}) {
+	    $real_name = $mailmap->{names}->{$address};
+	}
+	if (exists $mailmap->{addresses}->{$address}) {
+	    $real_address = $mailmap->{addresses}->{$address};
 	}
-	return format_email($real_name, $real_address, 1);
+    }
+    return format_email($real_name, $real_address, 1);
 }
 
 sub mailmap {
@@ -1146,18 +1147,17 @@ sub mailmap {
 }
 
 sub merge_by_realname {
-	my %address_map;
-	my (@emails) = @_;
-	foreach my $email (@emails) {
-		my ($name, $address) = parse_email($email);
-		if (!exists $address_map{$name}) {
-			$address_map{$name} = $address;
-		} else {
-			$address = $address_map{$name};
-			$email = format_email($name,$address,1);
-		}
+    my %address_map;
+    my (@emails) = @_;
+    foreach my $email (@emails) {
+	my ($name, $address) = parse_email($email);
+	if (!exists $address_map{$name}) {
+	    $address_map{$name} = $address;
+	} else {
+	    $address = $address_map{$name};
+	    $email = format_email($name,$address,1);
 	}
-
+    }
 }
 
 sub git_execute_cmd {
@@ -1555,7 +1555,7 @@ commit signers and mailing lists that co
 
 Any *'d entry is selected.
 
-If you have git or hg installed, You can choose to summarize the commit
+If you have git or hg installed, you can choose to summarize the commit
 history of files in the patch.  Also, each line of the current file can
 be matched to its commit author and that commits signers with blame.
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
lib-fix-scnprintf-if-size-is-==-0.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
maintainers-use-t-git-and-whitespace-trivia.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

