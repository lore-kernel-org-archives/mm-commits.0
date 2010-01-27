From: akpm@linux-foundation.org
Subject: + markup_oopspl-fix-func_offset-error-with-x86_64.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:44:30 -0800
Message-ID: <201001272344.o0RNiUVB007396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932217Ab0A0XpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teawater@gmail.com, arjan@linux.intel.com


The patch titled
     markup_oops.pl: fix $func_offset error with x86_64
has been added to the -mm tree.  Its filename is
     markup_oopspl-fix-func_offset-error-with-x86_64.patch

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
Subject: markup_oops.pl: fix $func_offset error with x86_64
From: Hui Zhu <teawater@gmail.com>

When I use markup_oops.pl parse a x8664 oops, I got:

objdump: --start-address: bad number: NaN
No matching code found
This is because:
main::(./m.pl:228):	open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
  DB<3> p $decodestart
NaN

This NaN is from:
main::(./m.pl:176):	my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
  DB<2> p $func_offset
0x175

There is already a "0x" in $func_offset, another 0x makes it a NaN.

The $func_offset is from line:

	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
		$function = $1;
		$func_offset = $2;
	}

I make a patch to change "(0x[0-9a-f]+)\/0x[a-f0-9]/)" to "0x([0-9a-f]+)\/0x[a-f0-9]/)".

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/markup_oops.pl~markup_oopspl-fix-func_offset-error-with-x86_64 scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oopspl-fix-func_offset-error-with-x86_64
+++ a/scripts/markup_oops.pl
@@ -158,7 +158,7 @@ while (<STDIN>) {
 		$function = $1;
 		$func_offset = $2;
 	}
-	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
_

Patches currently in -mm which might be from teawater@gmail.com are

markup_oopspl-fix-func_offset-error-with-x86_64.patch

