From: akpm@linux-foundation.org
Subject: + get_maintainerspl-improve-mailmap-parsing.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:01:38 -0700
Message-ID: <201106202201.p5KM1c53024411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023Ab1FTWBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     get_maintainers.pl: improve .mailmap parsing
has been added to the -mm tree.  Its filename is
     get_maintainerspl-improve-mailmap-parsing.patch

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
Subject: get_maintainers.pl: improve .mailmap parsing
From: Joe Perches <joe@perches.com>

Entries that used formats other than "Proper Name <commit@email.xx>"
were not parsed properly.

Try to improve the parsing so that the entries in the forms of:
    Proper Name <proper@email.xx> <commit@email.xx>
and
    Proper Name <proper@email.xx> Commit Name <commit@email.xx>
are transformed correctly.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainerspl-improve-mailmap-parsing scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerspl-improve-mailmap-parsing
+++ a/scripts/get_maintainer.pl
@@ -328,7 +328,8 @@ sub read_mailmap {
 	# name1 <mail1> <mail2>
 	# name1 <mail1> name2 <mail2>
 	# (see man git-shortlog)
-	if (/^(.+)<(.+)>$/) {
+
+	if (/^([^<]+)<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $address = $2;
 
@@ -336,13 +337,13 @@ sub read_mailmap {
 	    ($real_name, $address) = parse_email("$real_name <$address>");
 	    $mailmap->{names}->{$address} = $real_name;
 
-	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
+	} elsif (/^<([^>]+)>\s*<([^>]+)>$/) {
 	    my $real_address = $1;
 	    my $wrong_address = $2;
 
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
-	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
+	} elsif (/^(.+)<([^>]+)>\s*<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $real_address = $2;
 	    my $wrong_address = $3;
@@ -353,7 +354,7 @@ sub read_mailmap {
 	    $mailmap->{names}->{$wrong_address} = $real_name;
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
-	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
+	} elsif (/^(.+)<([^>]+)>\s*(.+)\s*<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $real_address = $2;
 	    my $wrong_name = $3;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

