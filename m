From: akpm@linux-foundation.org
Subject: + markup_oopspl-fix-error-with-x86.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:18:23 -0800
Message-ID: <201001112218.o0BMINIP031676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab0AKWS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teawater@gmail.com, arjan@linux.intel.com


The patch titled
     markup_oops.pl: fix error with x86
has been added to the -mm tree.  Its filename is
     markup_oopspl-fix-error-with-x86.patch

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
Subject: markup_oops.pl: fix error with x86
From: Hui Zhu <teawater@gmail.com>

When I try to use markup_oops.pl in x86, I always get:

cat 1 | perl markup_oops.pl ./vmlinux
objdump: --start-address: bad number: NaN
No matching code found

This is because in line:
	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}

$func_offset will get a number like "0x2"

But in follow code:

my $decodestart = Math::BigInt->from_hex("0x$target") -
Math::BigInt->from_hex("0x$func_offset");

It add other ox to ox2.  Then this value will be set to NaN.

So I made a small patch to fix it.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/markup_oops.pl~markup_oopspl-fix-error-with-x86 scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oopspl-fix-error-with-x86
+++ a/scripts/markup_oops.pl
@@ -154,7 +154,7 @@ while (<STDIN>) {
 	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
-	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
_

Patches currently in -mm which might be from teawater@gmail.com are

markup_oopspl-fix-error-with-x86.patch

