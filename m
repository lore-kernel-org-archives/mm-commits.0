Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF222B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671908; cv=none; b=kK2z+2bPCOOggVvn+xsfHFUnBQVEsaqM1siMJAO9WH63BFVNrwPo8OMiSiotK6GlMcYiZtUT1NjtP1+UGwJ/uSABUwsJuT0StcxJjKM2VmXgficPAvC9BkXpcY+/W8mGIDgX7d2mfJS+t60AFtcy46rqXDdrXNft+0q5LxS0/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671908; c=relaxed/simple;
	bh=6RERU4kMK0fMY0tKaWdhCAOy5WgG9BejI+cXUwxNXeE=;
	h=Date:To:From:Subject:Message-Id; b=ca2Gd6iRWD73z/qGSELGIgWWhTe4zKEx3COVuNVvOis4uzr2i+xbXKxLqL2NXEfSklaN4QIssboTQKaX2AWa+DNDPme1VnWYfamdFFFDcXZQ25lVN2eT+eQs8Ytf2RlkCQLVeUQUDfOfQpx4JHSBEXfTDGwUyA1IMAGOuav4oEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ryqVk5V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ryqVk5V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73739C4CEF7;
	Sat, 28 Mar 2026 04:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671908;
	bh=6RERU4kMK0fMY0tKaWdhCAOy5WgG9BejI+cXUwxNXeE=;
	h=Date:To:From:Subject:From;
	b=ryqVk5V17Wnn79bSeGqwmUsGMqI112Pfwq5cnWq//rV3Orv8Ybz/jVqTi9lwW/d1p
	 lA2MasqSBpJulgngkUqju6AEfgPLHdLn6/dmCru5H1cC7Ru/HsVfoEPrTzLKUxxR2D
	 PsZ13FVEZbGRSSMHjsuFBldCWpMROmLgK7MWOUOs=
Date: Fri, 27 Mar 2026 21:25:07 -0700
To: mm-commits@vger.kernel.org,teknoraver@meta.com,joe@perches.com,technoboy85@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-add-glob-pattern-support.patch removed from -mm tree
Message-Id: <20260328042508.73739C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_maintainer: add ** glob pattern support
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-glob-pattern-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matteo Croce <technoboy85@gmail.com>
Subject: get_maintainer: add ** glob pattern support
Date: Mon, 2 Mar 2026 11:38:22 +0100

Add support for the ** glob operator in MAINTAINERS F: and X: patterns,
matching any number of path components (like Python's ** glob).

The existing * to .* conversion with slash-count check is preserved.  **
is converted to (?:.*), a non-capturing group used as a marker to bypass
the slash-count check in file_match_pattern(), allowing the pattern to
cross directory boundaries.

This enables patterns like F: **/*[_-]kunit*.c to match files at any depth
in the tree.

Link: https://lkml.kernel.org/r/20260302103822.77343-1-teknoraver@meta.com
Signed-off-by: Matteo Croce <teknoraver@meta.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS               |    1 +
 scripts/get_maintainer.pl |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~get_maintainer-add-glob-pattern-support
+++ a/MAINTAINERS
@@ -35,6 +35,7 @@ Descriptions of section entries and pref
 	   F:	drivers/net/	all files in and below drivers/net
 	   F:	drivers/net/*	all files in drivers/net, but not below
 	   F:	*/net/*		all files in "any top level directory"/net
+	   F:	fs/**/*foo*.c	all *foo*.c files in any subdirectory of fs
 	   One pattern per line.  Multiple F: lines acceptable.
 	X: *Excluded* files and directories that are NOT maintained, same
 	   rules as F:. Files exclusions are tested before file matches.
--- a/scripts/get_maintainer.pl~get_maintainer-add-glob-pattern-support
+++ a/scripts/get_maintainer.pl
@@ -375,8 +375,10 @@ sub read_maintainer_file {
 	    ##Filename pattern matching
 	    if ($type eq "F" || $type eq "X") {
 		$value =~ s@\.@\\\.@g;       ##Convert . to \.
+		$value =~ s/\*\*/\x00/g;     ##Convert ** to placeholder
 		$value =~ s/\*/\.\*/g;       ##Convert * to .*
 		$value =~ s/\?/\./g;         ##Convert ? to .
+		$value =~ s/\x00/(?:.*)/g;   ##Convert placeholder to (?:.*)
 		##if pattern is a directory and it lacks a trailing slash, add one
 		if ((-d $value)) {
 		    $value =~ s@([^/])$@$1/@;
@@ -746,8 +748,10 @@ sub self_test {
 	if (($type eq "F" || $type eq "X") &&
 	    ($self_test eq "" || $self_test =~ /\bpatterns\b/)) {
 	    $value =~ s@\.@\\\.@g;       ##Convert . to \.
+	    $value =~ s/\*\*/\x00/g;     ##Convert ** to placeholder
 	    $value =~ s/\*/\.\*/g;       ##Convert * to .*
 	    $value =~ s/\?/\./g;         ##Convert ? to .
+	    $value =~ s/\x00/(?:.*)/g;   ##Convert placeholder to (?:.*)
 	    ##if pattern is a directory and it lacks a trailing slash, add one
 	    if ((-d $value)) {
 		$value =~ s@([^/])$@$1/@;
@@ -921,7 +925,7 @@ sub get_maintainers {
 				my $value_pd = ($value =~ tr@/@@);
 				my $file_pd = ($file  =~ tr@/@@);
 				$value_pd++ if (substr($value,-1,1) ne "/");
-				$value_pd = -1 if ($value =~ /^\.\*/);
+				$value_pd = -1 if ($value =~ /^(\.\*|\(\?:\.\*\))/);
 				if ($value_pd >= $file_pd &&
 				    range_is_maintained($start, $end) &&
 				    range_has_maintainer($start, $end)) {
@@ -955,6 +959,7 @@ sub get_maintainers {
 			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
 			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
 			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\(\?:\.\*\)/\*\*/g;	##Convert (?:.*) to **
 			$line =~ s/\.\*/\*/g;       	##Convert .* to *
 		    }
 		    my $count = $line =~ s/^([A-Z]):/$1:\t/g;
@@ -1048,7 +1053,7 @@ sub file_match_pattern {
 	if ($file =~ m@^$pattern@) {
 	    my $s1 = ($file =~ tr@/@@);
 	    my $s2 = ($pattern =~ tr@/@@);
-	    if ($s1 == $s2) {
+	    if ($s1 == $s2 || $pattern =~ /\(\?:/) {
 		return 1;
 	    }
 	}
_

Patches currently in -mm which might be from technoboy85@gmail.com are


