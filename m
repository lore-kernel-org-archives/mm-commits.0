From: akpm@linux-foundation.org
Subject: + find-dynamic-stack-allocations-in-checkstackpl.patch added to -mm tree
Date: Fri, 02 May 2008 19:30:15 -0700
Message-ID: <200805030230.m432UFad026973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590AbYECCbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 22:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     find dynamic stack allocations in checkstack.pl
has been added to the -mm tree.  Its filename is
     find-dynamic-stack-allocations-in-checkstackpl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: find dynamic stack allocations in checkstack.pl
From: Eric Sandeen <sandeen@redhat.com>

Currently, checkstack.pl only looks for fixed subtractions from the stack
pointer.  However, things like this:

void function(int size)
{
        char stackbuster[size << 2];
...

are certainly worth pointing out, I think.

This could perhaps be done more cleanly, and the following patch only
adds "dynamic" REs for x86 and x86_64, but it works:

0x00b0 crypto_cbc_decrypt_inplace [cbc]:                Dynamic (%rax)
0x00ad crypto_pcbc_decrypt_inplace [pcbc]:              Dynamic (%rax)
0x02f6 crypto_pcbc_encrypt_inplace [pcbc]:              Dynamic (%rax)
0x036c _crypto_xcbc_digest_setkey [xcbc]:               Dynamic (%rax)
...

(Inspired by Keith Owens' old stack-check script)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN scripts/checkstack.pl~find-dynamic-stack-allocations-in-checkstackpl scripts/checkstack.pl
--- a/scripts/checkstack.pl~find-dynamic-stack-allocations-in-checkstackpl
+++ a/scripts/checkstack.pl
@@ -26,8 +26,12 @@
 # $& (whole re) matches the complete objdump line with the stack growth
 # $1 (first bracket) matches the size of the stack growth
 #
+# $dre is similar, but for dynamic stack redutions:
+# $& (whole re) matches the complete objdump line with the stack growth
+# $1 (first bracket) matches the dynamic amount of the stack growth
+#
 # use anything else and feel the pain ;)
-my (@stack, $re, $x, $xs);
+my (@stack, $re, $dre, $x, $xs);
 {
 	my $arch = shift;
 	if ($arch eq "") {
@@ -46,9 +50,11 @@ my (@stack, $re, $x, $xs);
 	} elsif ($arch =~ /^i[3456]86$/) {
 		#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%esp$/o;
+		$dre = qr/^.*[as][du][db]    (%.*),\%esp$/o;
 	} elsif ($arch eq 'x86_64') {
 		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
+		$dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
 		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
@@ -141,6 +147,22 @@ while (my $line = <STDIN>) {
 		next if ($size < 100);
 		push @stack, "$intro$size\n";
 	}
+	elsif (defined $dre && $line =~ m/$dre/) {
+		my $size = "Dynamic ($1)";
+
+		next if $line !~ m/^($xs*)/;
+		my $addr = $1;
+		$addr =~ s/ /0/g;
+		$addr = "0x$addr";
+
+		my $intro = "$addr $func [$file]:";
+		my $padlen = 56 - length($intro);
+		while ($padlen > 0) {
+			$intro .= '	';
+			$padlen -= 8;
+		}
+		push @stack, "$intro$size\n";
+	}
 }
 
 print sort bysize @stack;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
linux-next.patch
find-dynamic-stack-allocations-in-checkstackpl.patch
fix-checkstackpl-arch-detection.patch

