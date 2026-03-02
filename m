Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A191F39150F
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484844; cv=none; b=uHay2YvuZ6kJ13rQMXfocq/vNFXD8EJJ+1yMIP6IiwMYn/YuqvNgvLvs5PScgZRzh1bKxgMtxqc8onTe7pxXHr5jmj3KB53giBGXJp+5X0/yWVQhFNO9osXj6P9ohNrVeGEu4X7tF+dNK2EFkZLNuw5h0bZeRK6xdUxA7aulwzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484844; c=relaxed/simple;
	bh=c7ssq803acVYruLMH4ibt3nfvfC58kvCmJKoel+hkAo=;
	h=Date:To:From:Subject:Message-Id; b=tVId3lro0bqghWmS3czi/Jdw9ZwCNl672jHZ8ryjUTXRD3S34CF2sGFOTVJ9XRqe0Yj9mx/4kwWmoaTMp9QlbHYxIUvK5llO6hheFMoS1izwYLvK90RfvOlUFWnZ1se4q4hoTCMpF1oZcRVIKJOHA3+X8/ir9Oh3kKVH+3oo2FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pd3XEdL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pd3XEdL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FAC19423;
	Mon,  2 Mar 2026 20:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772484844;
	bh=c7ssq803acVYruLMH4ibt3nfvfC58kvCmJKoel+hkAo=;
	h=Date:To:From:Subject:From;
	b=Pd3XEdL/aKc13ztqNg5xgpgdS1YVlQNiTz3QR0uT1lcWyZmqYmV6zbOJXC6OiuK7G
	 cNMhZQlHgzN8L9mBXb3gft0fyBG5dXgk0QVBvaUm4aSHWd5HqaIoL1FllDttlQDE4c
	 0hPpYIqNQFoOLkkAM0OzbCS9lkufFbKYHXasTGR0=
Date: Mon, 02 Mar 2026 12:54:03 -0800
To: mm-commits@vger.kernel.org,teknoraver@meta.com,joe@perches.com,technoboy85@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-add-glob-pattern-support.patch added to mm-nonmm-unstable branch
Message-Id: <20260302205404.0A7FAC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_maintainer: add ** glob pattern support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainer-add-glob-pattern-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-glob-pattern-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

get_maintainer-add-glob-pattern-support.patch

