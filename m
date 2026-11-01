Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793560629;
	b=iMIRV8cOgMIhhnBaBHMCsLN6A9QLdmWr0I7dO1PbHwmYlyUCUvViL2/CIcRnDFkkkJTu
	 N4sRaYfbDPoTPVrKCxMqMBNuAkUoUhGZsqVRnododSX7c7q0PuqxwVIhOXukA/VAloR0X
	 SNgxiyuR1zuuIGwlF1T25vXjI3X7PnCG8t6JyJaIFKmwcffdU7ThQJEZStlhgqbX5qkzn
	 GWq5Yr1chwdtLKLWJeMNGlu15gYF0r4eI/9nZS0We2Yiryxg7oNxDqhmAq5d/iF/4nMb6
	 ae6lJev+KYjt6X8F3fmcl+7ZHAltd2O+8rnsLAzYnRYLoKEFp+C23LqtihJ964v0MTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793560629;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3R8lEqHPutN8gVDBqld69oyt/Xg3TBni29NHa9yFLwM=;
	b=4jN5QzmKuQtAMHTuzC3K3Z7QEsND+eqhsNUrfcraftzBPmD8OAOnO/e0lVFD524ofSMr
	 n2SGv5bdmQM9ugQEr6wVpeQJbUE7cN4MRgXwDIF7Bde/hpMZFbjayvykKepnRC+9VOfpe
	 AqIk8hK550Dt39B6UxVPoVF15Gn/bvh0vJXCeaH2P80zvoPydu6JlAHsB3caPxKOzjDBQ
	 U47WYSikkJNORcoX5pt40yDh+AoRpBtuVqu7jZ1ZEW6jg8RtclYoY4NAG5MmozARbwWaE
	 MdJ4N3uK4xd4+lZrkGMm6nctqhNj3ahyap22P82SXqSaxn49KG9k47+zY+TRBK4rG5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="1el/aZZN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BEE606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1el/aZZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBD81F000C1;
	Sun,  1 Nov 2026 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793560628;
	bh=3R8lEqHPutN8gVDBqld69oyt/Xg3TBni29NHa9yFLwM=;
	h=Date:To:From:Subject;
	b=1el/aZZNn2AfsAuYSFn1d+QGJG6qUUesmMYhuagA0HLaHnz1iaslCuf7g/m7G3Tl1
	 5zbsU2Wv5e3uJ+xy0M2kkmy0aeJG6eKY92LHvHD4T4gxiO6mt7U+bGz7ilLfHa6Wyx
	 kAQeLoUl8LUepQI0yCQHesVd7qoY68sXzwzAmlsU=
Date: Sun, 01 Nov 2026 11:17:07 -0800
To: mm-commits@vger.kernel.org,bp@alien8.de,joe@perches.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainerpl-fix-inexact-file-pattern-matching.patch added to mm-nonmm-unstable branch
Message-Id: <20261101191708.3FBD81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: get_maintainer.pl: fix inexact file pattern matching
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainerpl-fix-inexact-file-pattern-matching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainerpl-fix-inexact-file-pattern-matching.patch

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
From: Joe Perches <joe@perches.com>
Subject: get_maintainer.pl: fix inexact file pattern matching
Date: Sun, 01 Nov 2026 10:36:27 -0800

The intent of file pattern matches is to exactly specify a file pattern
with or without wildcard **, *, or ?  expansion.

The pattern match code failed to include a trailing $ to match the end of
the pattern.

A pattern like:

F:	include/drm/drm

would match files like include/drm/drm_<foo>

Fix it and the self-test code too.

Link: https://lore.kernel.org/9d9626b16393901994012fa59824a63e96acd6ab.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
---

 scripts/get_maintainer.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/get_maintainer.pl~get_maintainerpl-fix-inexact-file-pattern-matching
+++ a/scripts/get_maintainer.pl
@@ -768,6 +768,10 @@ sub self_test {
 	    if ((-d $value)) {
 		$value =~ s@([^/])$@$1/@;
 	    }
+	    if (substr($value, -1) ne "/") {
+		$value .= '$';
+	    }
+
 	    if (!grep(m@^$value@, @lsfiles)) {
 		print("$x->{file}:$x->{linenr}: warning: no file matches\t$x->{line}\n");
 	    }
@@ -1062,7 +1066,7 @@ sub file_match_pattern {
 	    return 1;
 	}
     } else {
-	if ($file =~ m@^$pattern@) {
+	if ($file =~ m@^$pattern$@) {
 	    my $s1 = ($file =~ tr@/@@);
 	    my $s2 = ($pattern =~ tr@/@@);
 	    if ($s1 == $s2 || $pattern =~ /\(\?:/) {
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainerpl-fix-inexact-file-pattern-matching.patch

