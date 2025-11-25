Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4154D3314D2
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095657; cv=none; b=OWjox8uYRiYQCez6UdJOyLYeCuQxrLmOLJZKiuuoSO7TfCd8wpwZJybOkMAwxP0q6KK01wQ7H6BpliQ2GklJ6hstL/fw4Cqalv57yB5DfPBI0R3k32RaywSPdkLKMcLT2yHNQc/Tp4RBJEAvXBrvJFsoooCtNw/5o/tzuO0k7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095657; c=relaxed/simple;
	bh=mg4E5PYiEA6qbFpJT5Yw3OfqoVYgiXI3/Jix6Uj92Q4=;
	h=Date:To:From:Subject:Message-Id; b=rrbUy8alW+11dBzOUrdRiIinAgXDzgoxaNz4ZA1GpcuonWRPJV7m+ZwujDENmmZFKJab9ooMmjny+JKFIzuZ/p5zgr2SFUf8auw4Zq9IUTa1YQ0ICkrOoe0E2YuQnL9PaiNEktlXoIfuaELy0npoxC6rVzyi+UcCoB/6WnNKlM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGjPRS5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGjPRS5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76CFC4CEF1;
	Tue, 25 Nov 2025 18:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764095656;
	bh=mg4E5PYiEA6qbFpJT5Yw3OfqoVYgiXI3/Jix6Uj92Q4=;
	h=Date:To:From:Subject:From;
	b=HGjPRS5I66qsxP1hg3KQ7rWy39GaLCBAz1+U3/jENbS/er3GyPaf/Hhs41vHmgwHc
	 oGs/DdJ994Lh1rNAQWNESxmIdiafj4cn8ShNznfGpxIEFUMyaTk3JusljHDvYFLxnE
	 7NhzhbQ68ryW3QCf7POQBlu/IUttNeQqnJu1/XJA=
Date: Tue, 25 Nov 2025 10:34:16 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,bboscaccy@linux.microsoft.com,James.Bottomley@HansenPartnership.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + oid_registry-allow-arbitrary-size-oids.patch added to mm-nonmm-unstable branch
Message-Id: <20251125183416.B76CFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: oid_registry: allow arbitrary size OIDs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     oid_registry-allow-arbitrary-size-oids.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/oid_registry-allow-arbitrary-size-oids.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: oid_registry: allow arbitrary size OIDs
Date: Tue, 25 Nov 2025 13:19:56 -0500

The current OID registry parser uses 64 bit arithmetic which limits us to
supporting 64 bit or smaller OIDs.  This isn't usually a problem except
that it prevents us from representing the 2.25.  prefix OIDs which are the
OID representation of UUIDs and have a 128 bit number following the
prefix.  Rather than import not often used perl arithmetic modules,
replace the current perl 64 bit arithmetic with a callout to bc, which is
arbitrary precision.

Link: https://lkml.kernel.org/r/833c858cd74533203b43180208734b84f1137af0.camel@HansenPartnership.com
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/build_OID_registry |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/lib/build_OID_registry~oid_registry-allow-arbitrary-size-oids
+++ a/lib/build_OID_registry
@@ -60,10 +60,12 @@ for (my $i = 0; $i <= $#names; $i++) {
     # Determine the encoded length of this OID
     my $size = $#components;
     for (my $loop = 2; $loop <= $#components; $loop++) {
-	my $c = $components[$loop];
+	$ENV{'BC_LINE_LENGTH'} = "200";
+	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
+	chomp($c);
 
 	# We will base128 encode the number
-	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	my $tmp = length($c) - 1;
 	$tmp = int($tmp / 7);
 	$size += $tmp;
     }
@@ -100,16 +102,27 @@ for (my $i = 0; $i <= $#names; $i++) {
     push @octets, $components[0] * 40 + $components[1];
 
     for (my $loop = 2; $loop <= $#components; $loop++) {
-	my $c = $components[$loop];
+	# get the base 2 representation of the component
+	$ENV{'BC_LINE_LENGTH'} = "200";
+	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
+	chomp($c);
 
-	# Base128 encode the number
-	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	my $tmp = length($c) - 1;
 	$tmp = int($tmp / 7);
 
-	for (; $tmp > 0; $tmp--) {
-	    push @octets, (($c >> $tmp * 7) & 0x7f) | 0x80;
+	# zero pad upto length multiple of 7
+	$c = substr("0000000", 0, ($tmp + 1) * 7 - length($c)).$c;
+
+	# Base128 encode the number
+	my $j;
+	my $b;
+	for ($j = 0; $j < $tmp; $j++) {
+	    $b = oct("0b".substr($c, $j * 7, 7));
+
+	    push @octets, $b | 0x80;
 	}
-	push @octets, $c & 0x7f;
+	$b = oct("0b".substr($c, $j * 7, 7));
+	push @octets, $b;
     }
 
     push @encoded_oids, \@octets;
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

oid_registry-allow-arbitrary-size-oids.patch

