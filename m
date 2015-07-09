From: akpm@linux-foundation.org
Subject: + kstrto-accept-0-for-signed-conversion.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:03 -0700
Message-ID: <559ecacb.MrudHkyqz+fAfTTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbGIT0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, jack@suse.cz, jlbec@evilplan.org, linux@rasmusvillemoes.dk, mfasheh@suse.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: kstrto*: accept "-0" for signed conversion
has been added to the -mm tree.  Its filename is
     kstrto-accept-0-for-signed-conversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrto-accept-0-for-signed-conversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrto-accept-0-for-signed-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: kstrto*: accept "-0" for signed conversion

strtol(3) et al accept "-0", so should we.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c      |    2 +-
 lib/test-kstrtox.c |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN lib/kstrtox.c~kstrto-accept-0-for-signed-conversion lib/kstrtox.c
--- a/lib/kstrtox.c~kstrto-accept-0-for-signed-conversion
+++ a/lib/kstrtox.c
@@ -152,7 +152,7 @@ int kstrtoll(const char *s, unsigned int
 		rv = _kstrtoull(s + 1, base, &tmp);
 		if (rv < 0)
 			return rv;
-		if ((long long)(-tmp) >= 0)
+		if ((long long)-tmp > 0)
 			return -ERANGE;
 		*res = -tmp;
 	} else {
diff -puN lib/test-kstrtox.c~kstrto-accept-0-for-signed-conversion lib/test-kstrtox.c
--- a/lib/test-kstrtox.c~kstrto-accept-0-for-signed-conversion
+++ a/lib/test-kstrtox.c
@@ -260,6 +260,7 @@ static void __init test_kstrtoll_ok(void
 		{"4294967297",	10,	4294967297LL},
 		{"9223372036854775807",	10,	9223372036854775807LL},
 
+		{"-0",	10,	0LL},
 		{"-1",	10,	-1LL},
 		{"-2",	10,	-2LL},
 		{"-9223372036854775808",	10,	LLONG_MIN},
@@ -277,11 +278,6 @@ static void __init test_kstrtoll_fail(vo
 		{"-9223372036854775809",	10},
 		{"-18446744073709551614",	10},
 		{"-18446744073709551615",	10},
-		/* negative zero isn't an integer in Linux */
-		{"-0",	0},
-		{"-0",	8},
-		{"-0",	10},
-		{"-0",	16},
 		/* sign is first character if any */
 		{"-+1", 0},
 		{"-+1", 8},
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch

