From: akpm@linux-foundation.org
Subject: [merged] kstrto-accept-0-for-signed-conversion.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:50 -0700
Message-ID: <55f31966.Yh0FM06D6y/4ZQsi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbIKSLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, jack@suse.cz, jlbec@evilplan.org, linux@rasmusvillemoes.dk, mfasheh@suse.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: kstrto*: accept "-0" for signed conversion
has been removed from the -mm tree.  Its filename was
     kstrto-accept-0-for-signed-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


